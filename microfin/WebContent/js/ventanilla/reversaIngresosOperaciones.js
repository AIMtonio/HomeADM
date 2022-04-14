var safilocale = $("#socioClienteAlert").val();
var parametroBean = consultaParametrosSession();
$(document).ready(function() {
	esTab = true;
	$('#tipoOperacion').focus();
	 
	//Definicion de Constantes y Enums Tipo de Transaccion
	var catTipoTransaccionVen = {
  		'cargoCuenta'		:'1',
  		'abonoCuenta'		:'2',
  		'garantiaLiq'		:'4',	//
  	  	'comisionApertura'	:'6', 	// Reversa comision por Apertura
  	  	'desembolsoCredito'	:'7', 	// Reversa desembolso Credito
  	  	'aplicaSeguroVida'	:'9',	//Reversa Pago seguro de Vida por Fallecimiento	
  	  	'cobroSeguroVida'	:'10',	//Reversa Cobro Seguro de Vida
	};

	//Definicion de Constantes y Enums para los tipos de operacion.CAJATIPOSOPERA
	var catTipoOperacion = {
			'opeSalCargoCuenta'			:'11',	//salida de efectivo por cargo a cuenta
			'opeCajEntEfCta'			:'21',	// Entrada Efectivo Deposito Cuenta
			'opeCajEntGarLiq'			:'22',	// salida por Pago de GL
			'opeComisionAPCredito'		:'23',	// Entrada de efectivo por comision por apertura de Credito	  	  	 	
			'opeDesembolsoCredito'		:'10',	// Salida de efectivo por desembolso del credito
			'opeCajaEntCobroseguroVida'	:'38',	// Operacion de por cobro de seguro de Vida	  	  
	  	  	'opeSalAplicacionSegVida'	:'17', 	//salida de efectivo por aplicacion del seguro de Vida
	  	  	'opeEntXDepGLCargoCuenta'	:'61', 	//Entrada de Efectivo por deposito de GL con cargo a Cuenta
		};

	var numTransaccion 			= 0;
	var cargoCuenta 		= 31;
	var abonoCuenta 		= 32;
	var garantiaLiq 		= 33;
	var comAperCred 		= 34;
	var desemboCred 		= 35;
	var cobroSeguroVida		= 36;
	var aplicaSeguroVida	= 37;
	var seleccionar 		= 0;

	var mil = parseFloat(1000);
	var quinientos = parseFloat(500);
	var doscientos = parseFloat(200);
	var cien = parseFloat(100);
	var cincuenta = parseFloat(50);
	var veinte = parseFloat(20);
	var monedaValor = parseFloat(1);
	var bloquearCaja = "no";
	var existeTransaccion = 0;
	
	
	var numeroInstitucion=parametroBean.numeroInstitucion;
	$('#usuarioAutID').val(parametroBean.numeroUsuario);
	var ivaSucursal=parametroBean.ivaSucursal;
	var telefono=parametroBean.telefonoLocal;
	var rfcInstitucion=parametroBean.rfcRepresentante;
	var sucursalID=parametroBean.sucursal;
	var direccionInstitucion=parametroBean.direccionInstitucion;
	var monedaBase=parametroBean.desCortaMonedaBase;  
	var numeromonedaBase=parametroBean.numeroMonedaBase;
	var simboloMonedaBase=parametroBean.simboloMonedaBase;
	var descrpcion=parametroBean.nombreMonedaBase;
	var TipoImpresion=parametroBean.tipoImpTicket;	
	var tipoCajaSesion=parametroBean.tipoCaja;
	var numeroCaja=parametroBean.cajaID;
	$('#fechaSistema').val(parametroBean.fechaAplicacion);
	$('#fechaSistemaP').val(parametroBean.fechaSucursal);
	$('#nombreInstitucion').val(parametroBean.nombreInstitucion);
	$('#numeroSucursal').val(parametroBean.sucursal);
	$('#nombreSucursal').val(parametroBean.nombreSucursal);
	$('#numeroCaja').val(parametroBean.cajaID);
	$('#nomCajero').val(parametroBean.nombreUsuario);

	var printWin = "";
	var procedePago = 2; 
	var procedeGLAdi = 2; 
	var creditoPagado = "N";
	var mostrarSaldo = parametroBean.mostrarSaldDisCtaYSbc;
	var tipoOpe;
	$('#claveUsuarioLog').val(parametroBean.claveUsuario);
	
	//-----------ocultamos campos
	$('#tdGrupoCreditoSC').hide();
	$('#tdGrupoCreditoSInputC').hide();
	$('#tdGrupoCicloSC').hide();
	$('#tdGrupoCicloSinputC').hide();
	$('#grupoDesSC').hide();		
	$('#lblCreditoid').hide();
	$('#grupoIDSC').hide();
	//-----------------
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	consultarParametrosBean();
	inicializarEntradasSalidasEfectivo();
	consultaDisponibleDenominacion();
	inicializarCampos();
	inicializarCamposGL();
	consultaLimiteCaja();
	consultaOpcionesCaja();
	var parametros = consultaParametrosSession();
	if (parametros.tipoCaja == '' || parametros.tipoCaja == undefined){
		mensajeSis('El Usuario no tiene una Caja asignada.');
		deshabilitaItems();
	}else if (parametros.tipoCaja == 'CA' || parametros.tipoCaja == 'CP' || parametros.tipoCaja == 'BG'){
		estaAbiertaCaja($('#sucursalIDSesion').val(),$('#cajaIDSesion').val(),parametros.tipoCaja);
	}else{
		mensajeSis('El Tipo de Caja No esta Definido Correctamente.');
		deshabilitaItems();
	}

	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
	      	consultaTransaccionReversa();
	    	bloquearCaja=consultaLimiteCaja(); 
	  		if(bloquearCaja == "si"){
	  			deshabilitaBoton('graba', 'submit');
	  	    	$('#impTicket').hide();
	  		}else{
	  			if(bloquearCaja == "no"){
	  				if($('#numeroTransaccion').asNumber()>0 ){
	  		  			deshabilitaBoton('graba', 'submit');
	  		  		}else{ 
	  		  			if (existeTransaccion == 1) {
	  		  				mensajeSis("La Reversa del folio "+ numTransaccion + " ya Existe");
	  		  				deshabilitaBoton('graba', 'submit');
	  		  			} else{
	  		  				habilitaControl('pagoGLEfectivo');
							habilitaControl('pagoGLCargoCuenta');					
				  			grabaFormaTransaccionVentanilla(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','numeroTransaccion');
	  		  			}
	  		  		}  	
	  			}
	  		}	  		
     	}		
   });	

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#tipoOperacion').change(function() {
		
		habilitaEntradasSalidasEfectivo();
		$('#sumTotalSal').val(""); 
		$('#sumTotalEnt').val(""); 
		$('#montoCargar').val(""); 
		$('#montoAbonar').val(""); 
		$('#montoPagar').val("");
		$('#montoGarantiaLiq').val("");
		$('#totalDepAR').val("");
		$('#totalRetirarDC').val("");
		bloquearCaja = consultaLimiteCaja();
		$('#numeroTransaccion').val("");
		 if(bloquearCaja == "si"){
				deshabilitaBoton('graba', 'submit');
		    	$('#impTicket').hide();
		 }
		 else{
			if(bloquearCaja == "no"){
				setTimeout("$('#cajaLista').hide();", 200);
				switch($(this).asNumber())
				{
					case seleccionar:
						inicializaTipoOperacion();
						$('#usuarioContrasenia').hide();
					break;
		
					case cargoCuenta:
						inicializaTipoOperacion();
						$('#cargoCuenta').show();

						inicializaForma('formaGenerica','tipoOperacion' );
						inicializarEntradasSalidasEfectivo();
						consultaDisponibleDenominacion();						

						$('#tipoTransaccion').val(catTipoTransaccionVen.cargoCuenta);
						consultarParametrosBean();	
						mostrarSadosDisponibles(mostrarSaldo,$(this).asNumber());
						inicializarTransaccion();

					break;
					case abonoCuenta: 
						inicializaTipoOperacion();
						$('#abonoCuenta').show();
						
						inicializaForma('formaGenerica','tipoOperacion' );
						inicializarEntradasSalidasEfectivo();
						consultaDisponibleDenominacion();																	
						$('#tipoTransaccion').val(catTipoTransaccionVen.abonoCuenta);
						consultarParametrosBean();
						mostrarSadosDisponibles(mostrarSaldo,$(this).asNumber());
						inicializarTransaccion();
						
					break;	
					case garantiaLiq:
						inicializaTipoOperacion();
						$('#garantiaLiq').show();
						
						deshabilitaControl('pagoGLEfectivo');
						deshabilitaControl('pagoGLCargoCuenta');						
						inicializaForma('formaGenerica','tipoOperacion' );
						inicializarEntradasSalidasEfectivo();
						consultaDisponibleDenominacion();
						
						$('#tipoTransaccion').val(catTipoTransaccionVen.garantiaLiq);
						consultarParametrosBean();
						mostrarSadosDisponibles(mostrarSaldo,$(this).asNumber());
						inicializarTransaccion();

					break;

					case comAperCred:
						inicializaTipoOperacion();
						$('#comisionApertura').show();
						
						inicializaForma('formaGenerica','tipoOperacion' );						
						inicializarEntradasSalidasEfectivo();
						consultaDisponibleDenominacion();

						$('#tipoTransaccion').val(catTipoTransaccionVen.comisionApertura);
						consultarParametrosBean();
						mostrarSadosDisponibles(mostrarSaldo,$(this).asNumber());
						inicializarTransaccion();

					break;
					
					case cobroSeguroVida:
						inicializaTipoOperacion();						
						$('#cobroSeguroVida').show();

						inicializaForma('formaGenerica','tipoOperacion' );	
						inicializarEntradasSalidasEfectivo();
						consultaDisponibleDenominacion();
						
						$('#tipoTransaccion').val(catTipoTransaccionVen.cobroSeguroVida);
						consultarParametrosBean();						
						mostrarSadosDisponibles(mostrarSaldo,$(this).asNumber());
						inicializarTransaccion();

					break;
					case aplicaSeguroVida:
						inicializaTipoOperacion();
						$('#pagoSeguroVida').show();
						
						inicializaForma('formaGenerica','tipoOperacion' );
						inicializarEntradasSalidasEfectivo();
						consultaDisponibleDenominacion();
						
						$('#tipoTransaccion').val(catTipoTransaccionVen.aplicaSeguroVida);
						consultarParametrosBean();
						mostrarSadosDisponibles(mostrarSaldo,$(this).asNumber());
						inicializarTransaccion();

					break;					
					case desemboCred:
						inicializaTipoOperacion();
						$('#desembolsoCred').show();
						
						inicializaForma('formaGenerica','tipoOperacion' );						
						inicializarEntradasSalidasEfectivo();
						consultaDisponibleDenominacion();
						
						$('#tipoTransaccion').val(catTipoTransaccionVen.desembolsoCredito);
						consultarParametrosBean();
						mostrarSadosDisponibles(mostrarSaldo,$(this).asNumber());
						inicializarTransaccion();

					break;
				}
			}
		 }
	});	
	
	//Mostrar u ocultar saldo Dsiponible de la Cuenta del Socio //
	function mostrarSadosDisponibles(mostrarSaldoDis,tipoOpe){		
		switch(tipoOpe){
		case cargoCuenta:
			if(mostrarSaldoDis=="S"){
				$('#tdsaldoDisponCa').show();
				$('#saldoDisponCa').show();
			}else if(mostrarSaldoDis=="N"){
				$('#tdsaldoDisponCa').hide();
				$('#saldoDisponCa').hide();
			}
			break;
		case abonoCuenta:
			if(mostrarSaldoDis=="S"){
				$('#tdsaldoDisponAb').show();
				$('#saldoDisponAb').show();
			}else if(mostrarSaldoDis=="N"){
				$('#tdsaldoDisponAb').hide();
				$('#saldoDisponAb').hide();
			}
			break;
		case garantiaLiq:
			if(mostrarSaldoDis=="S"){
				$('#trsaldoDisponGL').show();
			}else if(mostrarSaldoDis=="N"){
				$('#trsaldoDisponGL').hide();
			}
			break;
		case desemboCred:
			if(mostrarSaldoDis=="S"){
				$('#tdsaldoDisponDC').show();
				$('#saldoDisponDC').show();
			}else if(mostrarSaldoDis=="N"){
				$('#tdsaldoDisponDC').hide();
				$('#saldoDisponDC').hide();
			}
			break;
		}		
		
	}


	//SECCION DE EVENTOS DE CARGO A CUENTA
	$('#numeroTransaccionCC').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "sucursal";
			camposLista[1] = "cajaID";
			camposLista[2] = "fecha";
			camposLista[3] = "tipoOperacion"; 
			parametrosLista[0] = $('#numeroSucursal').asNumber();	
			parametrosLista[1] = $('#numeroCaja').asNumber();
			parametrosLista[2] = $('#fechaSistema').val();				
			parametrosLista[3] = catTipoOperacion.opeSalCargoCuenta;		
			listaAlfanumerica('numeroTransaccionCC', '2', '1', camposLista, parametrosLista, 'listaCajasMovs.htm');
		}				       
	});	
	
	$('#numeroTransaccionCC').blur(function() { 
		$('#descripcionOper').val('CARGO A CUENTA');
		$('#tipoTransaccion').val(catTipoTransaccionVen.cargoCuenta);				
		inicializaOperacion(this.id);
  		consultaMovsCajaCargoCuenta(this.id);
	});

	$('#referenciaCa').blur(function() {
		ponerMayusculas(this);
	});
	
	
	//  SECCION DE EVENTOS DE ABONO A CUENTA
	$('#numeroTransaccionAC').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "sucursal";
			camposLista[1] = "cajaID";
			camposLista[2] = "fecha";
			camposLista[3] = "tipoOperacion"; 
			parametrosLista[0] = $('#numeroSucursal').asNumber();	
			parametrosLista[1] = $('#numeroCaja').asNumber();
			parametrosLista[2] = $('#fechaSistema').val();				
			parametrosLista[3] = catTipoOperacion.opeCajEntEfCta;		
			listaAlfanumerica('numeroTransaccionAC', '2', '1', camposLista, parametrosLista, 'listaCajasMovs.htm');
		}				       
	});	
	
	$('#numeroTransaccionAC').blur(function() { 
		$('#descripcionOper').val('ABONO A CUENTA');
		$('#tipoTransaccion').val(catTipoTransaccionVen.abonoCuenta);				
	 	inicializaOperacion(this.id);
  		consultaMovsCajaAbonoCuenta(this.id);
	});
	
	
	$('#referenciaAb').blur(function() {
		$('#claveUsuarioAut').focus();
		ponerMayusculas(this);
	});

	
	// SECCION DE EVENTOS DE GARANTIA LIQUIDA		
	$('#numeroTransaccionGL').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "sucursal";
			camposLista[1] = "cajaID";
			camposLista[2] = "fecha";
			camposLista[3] = "tipoOperacion"; 
			parametrosLista[0] = $('#numeroSucursal').asNumber();	
			parametrosLista[1] = $('#numeroCaja').asNumber();
			parametrosLista[2] = $('#fechaSistema').val();				
			parametrosLista[3] = catTipoOperacion.opeCajEntGarLiq;		
			listaAlfanumerica('numeroTransaccionGL', '2', '1', camposLista, parametrosLista, 'listaCajasMovs.htm');
		}				       
	});	
	
	$('#numeroTransaccionGL').blur(function() { 
		$('#descripcionOper').val('DEPOSITO DE GARANTIA LIQUIDA');  
		$('#tipoTransaccion').val(catTipoTransaccionVen.garantiaLiq);		
		inicializaOperacion(this.id);
  		consultaMovsCajaGarantiaLiquida(this.id);
  		  
	});
	
	// 	---- COMISION POR APERTURA	
	$('#numeroTransaccionAR').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "sucursal";
			camposLista[1] = "cajaID";
			camposLista[2] = "fecha";
			camposLista[3] = "tipoOperacion"; 
			parametrosLista[0] = $('#numeroSucursal').asNumber();	
			parametrosLista[1] = $('#numeroCaja').asNumber();
			parametrosLista[2] = $('#fechaSistema').val();				
			parametrosLista[3] = catTipoOperacion.opeComisionAPCredito;		
			listaAlfanumerica('numeroTransaccionAR', '2', '1', camposLista, parametrosLista, 'listaCajasMovs.htm');
		}				       
	});	
	
	$('#numeroTransaccionAR').blur(function() {    	
		$('#descripcionOper').val('COMISION POR APERTURA');
		$('#tipoTransaccion').val(catTipoTransaccionVen.comisionApertura);	
		inicializaOperacion(this.id);
		consultaMovsCajaComisionApertura(this.id);
	});
	
	
	// SECCION DE EVENTOS DESEMBOLSO CREDITO	
	$('#numeroTransaccionDC').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "sucursal";
			camposLista[1] = "cajaID";
			camposLista[2] = "fecha";
			camposLista[3] = "tipoOperacion"; 
			parametrosLista[0] = $('#numeroSucursal').asNumber();	
			parametrosLista[1] = $('#numeroCaja').asNumber();
			parametrosLista[2] = $('#fechaSistema').val();				
			parametrosLista[3] = catTipoOperacion.opeDesembolsoCredito;		
			listaAlfanumerica('numeroTransaccionDC', '2', '1', camposLista, parametrosLista, 'listaCajasMovs.htm');
		}				       
	});	
	
	$('#numeroTransaccionDC').blur(function() {  
		$('#descripcionOper').val('DESEMBOLSO DEL CREDITO ');
		$('#tipoTransaccion').val(catTipoTransaccionVen.desembolsoCredito);	
		inicializaOperacion(this.id);
		consultaMovsCajaDesemCredito(this.id);
	});
	
	
	//***EVENTOS PARA EL COBRO DEL SEGURO DE VIDA***
	$('#numeroTransaccionCSV').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "sucursal";
			camposLista[1] = "cajaID";
			camposLista[2] = "fecha";
			camposLista[3] = "tipoOperacion"; 
			parametrosLista[0] = $('#numeroSucursal').asNumber();	
			parametrosLista[1] = $('#numeroCaja').asNumber();
			parametrosLista[2] = $('#fechaSistema').val();
			parametrosLista[3] = catTipoOperacion.opeCajaEntCobroseguroVida;			
			listaAlfanumerica('numeroTransaccionCSV', '2', '1', camposLista, parametrosLista, 'listaCajasMovs.htm');
		}				       
	});	
	$('#numeroTransaccionCSV').blur(function() {   
		$('#descripcionOper').val('COBRO SEGURO DE VIDA');
		$('#tipoTransaccion').val(catTipoTransaccionVen.cobroSeguroVida);
		inicializaOperacion(this.id);
  		consultaMovsCaja(this.id);
	});
	
	//***EVENTOS PARA aPLICACION DEL SEGURO DE VIDA     ***	
	$('#numeroTransaccionSV').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "sucursal";
			camposLista[1] = "cajaID";
			camposLista[2] = "fecha";
			camposLista[3] = "tipoOperacion"; 
			parametrosLista[0] = $('#numeroSucursal').asNumber();	
			parametrosLista[1] = $('#numeroCaja').asNumber();
			parametrosLista[2] = $('#fechaSistema').val();				
			parametrosLista[3] = catTipoOperacion.opeSalAplicacionSegVida;		
			listaAlfanumerica('numeroTransaccionSV', '2', '1', camposLista, parametrosLista, 'listaCajasMovs.htm');
		}				       
	});	
	
	$('#numeroTransaccionSV').blur(function() {  
		$('#descripcionOper').val('APLICACION DEL SEGURO DE VIDA ');
		$('#tipoTransaccion').val(catTipoTransaccionVen.aplicaSeguroVida);
		inicializaOperacion(this.id);
		consultaMovsCajaAplicaSeguro(this.id);
	});
		
	//**** EVENTOS PARA LOS INPUTS DE ENTRADA DE EFECTIVO
	$('#cantEntraMil').blur(function() {
		if($('#cantEntraMil').asNumber()<=0){
			$('#cantEntraMil').val("0");
		}
		cantidadPorDenominacionMil(this.id);
		totalEntradasSalidasDiferencia();
	});
	$('#cantEntraQui').blur(function() {
		if($('#cantEntraQui').asNumber()<=0){
			$('#cantEntraQui').val("0");
		}
		cantidadPorDenominacionQui(this.id);
		totalEntradasSalidasDiferencia();
	});
	$('#cantEntraDos').blur(function() {
		if($('#cantEntraDos').asNumber()<=0){
			$('#cantEntraDos').val("0");
		}
		cantidadPorDenominacionDos(this.id);
		totalEntradasSalidasDiferencia();
	});
	$('#cantEntraCien').blur(function() {
		if($('#cantEntraCien').asNumber()<=0){
			$('#cantEntraCien').val("0");
		}
		cantidadPorDenominacionCien(this.id);
		totalEntradasSalidasDiferencia();
	});
	$('#cantEntraCin').blur(function() {
		if($('#cantEntraCin').asNumber()<=0){
			$('#cantEntraCin').val("0");
		}
		cantidadPorDenominacionCin(this.id);
		totalEntradasSalidasDiferencia();
	});
	$('#cantEntraVei').blur(function() {
		if($('#cantEntraVei').asNumber()<=0){
			$('#cantEntraVei').val("0");
		}
		cantidadPorDenominacionVei(this.id);
		totalEntradasSalidasDiferencia();
	});
	$('#cantEntraMon').blur(function() {
		if($('#cantEntraMon').asNumber()<=0){
			$('#cantEntraMon').val("0");
		}
		cantidadPorDenominacionMon(this.id);
		totalEntradasSalidasDiferencia();
	});
	// FIN EVENTOS PARA LOS INPUTS DE ENTRADA DE EFECTIVO
	
	
	
	//**** EVENTOS PARA LOS INPUTS DE SALIDA DE EFECTIVO
	$('#cantSalMil').blur(function() {
		if($('#cantSalMil').asNumber()>0 && $('#cantSalMil').asNumber()> $('#disponSalMil').asNumber()){
			mensajeSis("Efectivo Insuficiente.");
			$('#cantSalMil').val("0");
			$('#cantSalMil').focus();
			$('#cantSalMil').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalMil').asNumber()<=0){
				$('#cantSalMil').val("0");
			}
			cantidadPorDenominacionMilS(this.id);
		}	
		totalEntradasSalidasDiferencia();	
	});
	$('#cantSalQui').blur(function() {
		if($('#cantSalQui').asNumber()>0 && $('#cantSalQui').asNumber()> $('#disponSalQui').asNumber()){
			mensajeSis("Efectivo Insuficiente.");
			$('#cantSalQui').val("0");
			$('#cantSalQui').focus();
			$('#cantSalQui').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalQui').asNumber()<=0){
				$('#cantSalQui').val("0");
			}
			cantidadPorDenominacionQuiS(this.id);
		}				
		totalEntradasSalidasDiferencia();
	});
	$('#cantSalDos').blur(function() {
		if($('#cantSalDos').asNumber()>0 && $('#cantSalDos').asNumber()> $('#disponSalDos').asNumber()){
			mensajeSis("Efectivo Insuficiente.");
			$('#cantSalDos').val("0");
			$('#cantSalDos').focus();
			$('#cantSalDos').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalDos').asNumber()<=0){
				$('#cantSalDos').val("0");
			}
			cantidadPorDenominacionDosS(this.id);
		}
		totalEntradasSalidasDiferencia();
	});
	$('#cantSalCien').blur(function() {
		if($('#cantSalCien').asNumber()>0 && $('#cantSalCien').asNumber()> $('#disponSalCien').asNumber()){
			mensajeSis("Efectivo Insuficiente.");
			$('#cantSalCien').val("0");
			$('#cantSalCien').focus();
			$('#cantSalCien').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalCien').asNumber()<=0){
				$('#cantSalCien').val("0");
			}
			cantidadPorDenominacionCienS(this.id);
		}
		totalEntradasSalidasDiferencia();
	});
	$('#cantSalCin').blur(function() {
		if($('#cantSalCin').asNumber()>0 && $('#cantSalCin').asNumber()> $('#disponSalCin').asNumber()){
			mensajeSis("Efectivo Insuficiente.");
			$('#cantSalCin').val("0");
			$('#cantSalCin').focus();
			$('#cantSalCin').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalCin').asNumber()<=0){
				$('#cantSalCin').val("0");
			}
			cantidadPorDenominacionCinS(this.id);
		}
		totalEntradasSalidasDiferencia();
	});
	$('#cantSalVei').blur(function() {
		if($('#cantSalVei').asNumber()>0 && $('#cantSalVei').asNumber()> $('#disponSalVei').asNumber()){
			mensajeSis("Efectivo Insuficiente.");
			$('#cantSalVei').val("0");
			$('#cantSalVei').focus();
			$('#cantSalVei').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalVei').asNumber()<=0){
				$('#cantSalVei').val("0");
			}
			cantidadPorDenominacionVeiS(this.id);
		}
		totalEntradasSalidasDiferencia();
	});
	
	$('#cantSalMon').blur(function() {
		if($('#cantSalMon').asNumber()>0 && $('#cantSalMon').asNumber()> $('#disponSalMon').asNumber()){
			mensajeSis("Efectivo Insuficiente.");
			$('#cantSalMon').val("0");
			$('#cantSalMon').focus();
			$('#cantSalMon').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalMon').asNumber()<=0){
				$('#cantSalMon').val("0");
			}
			cantidadPorDenominacionMonS(this.id);
		}
		totalEntradasSalidasDiferencia();
	});
	
	
	
	// FIN EVENTOS PARA LOS INPUTS DE SALIDA DE EFECTIVO
	
	// llama metodo totalEntradasSalidasDiferencia
	$('#montoCargar').blur(function() {
		var monto = $('#montoCargar').asNumber(); 
		var disponible =  $('#saldoDisponCa').asNumber(); 
		if (parseFloat(monto)>parseFloat(disponible)){
			mensajeSis("El Monto es Superior al Saldo Disponible.");
			$('#montoCargar').focus();
			$('#montoCargar').select();	
			deshabilitaBoton('graba', 'submit');
		}else{
			totalEntradasSalidasDiferencia();
		}
	});
	
	//Clic a boton agregar
	$('#agregarEntEfec').click(function() {
		$('#impTicket').hide();
		totalEntradasSalidasDiferencia();

	});
	$('#agregarSalEfec').click(function() {
		$('#impTicket').hide();
		totalEntradasSalidasDiferencia();
	});
	

	//funcion que se carga cuando se realiza una transaccion
	function imprimirTicketVentanilla(){
		var ticket='T';
		consultaDisponibleDenominacion();
			switch($('#tipoTransaccion').val()){
				case catTipoTransaccionVen.cargoCuenta:
					reimprimeTickets(31, $('#numeroTransaccion').val(), 1);
				break;
				case catTipoTransaccionVen.abonoCuenta:
					reimprimeTickets(32, $('#numeroTransaccion').val(), 1);
				break;
				case catTipoTransaccionVen.garantiaLiq: 
					var fechaHora = $('#fechaSistemaP').val()+" " +hora(); 
					var varCreditoID = $('#referenciaGL').val();
					if(TipoImpresion !=ticket){
						window.open('ReversaDepGarantiaLiquida.htm?fechaSistemaP='+fechaHora+
								'&monto='+$('#montoGarantiaLiq').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
								'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
								'&varCreditoID='+$('#referenciaGL').val()+'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalSal').val()+
								'&diferencia='+$('#sumTotalEnt').val()+'&varFormaPago='+"Efectivo"+   
								'&numCli='+$('#numClienteGL').val()+'&nombreCli='+$('#nombreClienteGL').val()+'&cuentaAho='+$('#cuentaAhoIDGL').val()+
								'&tipoCuen='+$('#tipoCuentaGL').val()+'&tipoTransaccion='+$('#tipoTransaccion').val()+
								'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaGL').val()+'&productoCred='+''+
								'&tipoCuen='+$('#tipoCuentaGL').val()+'&grupo='+$('#grupoDesGL').val()+
								'&ciclo='+$('#cicloIDGL').val(), '_blank');
					}else{															
						imprimeTicketReversa();						
					}
					
				break;
				case catTipoTransaccionVen.comisionApertura: 
					var fechaHora = $('#fechaSistemaP').val()+" " +hora(); 
					var varCreditoID = $('#creditoIDAR').val();	 
					if(TipoImpresion !=ticket){
					window.open('ReversaComisionApertura.htm?fechaSistemaP='+fechaHora+
							'&monto='+$('#totalDepAR').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
							'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
							'&varCreditoID='+varCreditoID+'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalSal').val()+
							'&diferencia='+$('#sumTotalEnt').val()+'&varFormaPago='+"Efectivo"+    
							'&numCli='+$('#clienteIDAR').val()+'&nombreCli='+$('#nombreClienteAR').val()+'&cuentaAho='+$('#cuentaAhoIDAR').val()+
							'&tipoCuen='+$('#nomCuentaAR').val()+'&tipoTransaccion='+$('#tipoTransaccion').val()+
							'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaDesAR').val()+'&montoComision='+$('#comisionAR').val()+
							'&montoIva='+$('#ivaAR').val()+'&productoCred='+$('#desProdCreditoAR').val()+
							'&grupo='+$('#grupoDesAR').val()+'&ciclo='+$('#cicloIDAR').val(), '_blank');
					}else{															
						imprimeTicketReversa();						
					}
					
				break;
				
				
				case catTipoTransaccionVen.desembolsoCredito:
					var fechaHora = $('#fechaSistemaP').val()+" " +hora();
					var varCreditoID = $('#creditoIDDC').val();	
					var ante = $('#totalDesembolsoDC').asNumber();
					var porDesem = $('#montoPorDesemDC').asNumber()-$('#totalRetirarDC').asNumber();
					if(TipoImpresion !=ticket){
					window.open('ReversaDesembolsoCredito.htm?fechaSistemaP='+fechaHora+
							'&monto='+$('#totalRetirarDC').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
							'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
							'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
							'&diferencia='+$('#sumTotalSal').val()+'&varFormaPago='+"Efectivo"+
							'&numCli='+$('#clienteIDDC').val()+'&nombreCli='+$('#nombreClienteDC').val()+'&cuentaAho='+$('#cuentaAhoIDDC').val()+
							'&referen='+$('#creditoIDDC').val()+'&tipoCuen='+$('#nomCuentaDC').val()+'&tipoTransaccion='+$('#tipoTransaccion').val()+
							'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaDesDC').val()+'&montoComision='+$('#comisionDC').val()+
							'&montoIva='+$('#ivaDC').val()+'&productoCred='+$('#desProdCreditoDC').val()+
							'&varCreditoID='+varCreditoID+'&montoCred='+$('#montoCreDC').val()+'&monPorDes='+porDesem+
							'&montoDes='+$('#totalDesembolsoDC').val()+'&montoResAnt='+ante+
							'&grupo='+$('#grupoDesDC').val()+'&ciclo='+$('#cicloIDDC').val(), '_blank');
					}else{
						imprimeTicketReversa();		
					}
					break;											
				case catTipoTransaccionVen.cobroSeguroVida:					
					if(TipoImpresion !=ticket){
						window.open('TicketReversaVenSegVida.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
								'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
								$('#numeroTransaccion').val()+'&clienteIDSC='+$('#clienteIDSC').val()+'&nombreClienteSC='+$('#nombreClienteSC').val()+
								'&montoSeguroCobro='+$('#montoSeguroCobro').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion=8'+'&direccionInstitucion='+direccionInstitucion+
								'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+telefono+'&fechaSistema='+$('#fechaSistema').val()+
								'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+
								'&descripcionMoneda='+descrpcion, '_blank');				
					}else{						
						imprimeTicketReversa();						
					}
				break;
				
				case catTipoTransaccionVen.aplicaSeguroVida:										
					window.open('ReversaSegVidaSiniestro.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
							'&poliza='+$('#numeroPolizaS').val()+'&clienteIDSC='+$('#clienteIDS').val()+'&nombreClienteSC='+$('#nombreClienteS').val()+
							'&creditoIDS='+$('#creditoIDS').val()+'&fechaInicioSeguro='+$('#fechaInicioSeguro').val()+
							'&fechaVencimiento='+$('#fechaVencimiento').val()+
							'&beneficiarioSeguro='+$('#beneficiarioSeguro').val()+'&direccionBeneficiario='+$('#direccionBeneficiario').val()+
							'&desRelacionBeneficiario='+$('#desRelacionBeneficiario').val()+'&montoPoliza='+$('#montoPoliza').asNumber()+
							'&nombreSucursal='+$('#nombreSucursal').val()+'&nomCajero='+$('#nomCajero').val()+
							'&fechaSistema='+$('#fechaSistema').val()+ '&tipoTransaccion=9'+'&numeroSucursal='+sucursalID+'&desMonedaBase='+monedaBase+
							'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+
							'&descripcionMoneda='+descrpcion, '_blank');																
				break;								
			}		
	}
	
	
	//Clic a boton para imprimir ticket
	$('#impTicket').click(function() {
		var ticket='T';
		consultaDisponibleDenominacion();
		if($('#numeroMensaje').val() == 0 && $('#numeroTransaccion').asNumber()>0){
			switch($('#tipoTransaccion').val())
			{
				case catTipoTransaccionVen.abonoCuenta :
					reimprimeTickets(32, $('#numeroTransaccion').val(), 1);
					break;
				case catTipoTransaccionVen.cargoCuenta :
					reimprimeTickets(31, $('#numeroTransaccion').val(), 1);
					break;
				case catTipoTransaccionVen.garantiaLiq: 
					var fechaHora = $('#fechaSistemaP').val()+" " +hora(); 

					if(TipoImpresion !=ticket){
						var varCreditoID = $('#referenciaGL').val();	 
						$('#enlaceTicket').attr('href','ReversaDepGarantiaLiquida.htm?fechaSistemaP='+fechaHora+
								'&monto='+$('#montoGarantiaLiq').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
								'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
								'&varCreditoID='+varCreditoID+'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalSal').val()+
								'&diferencia='+$('#sumTotalEnt').val()+'&varFormaPago='+"Efectivo"+  
								'&numCli='+$('#numClienteGL').val()+'&nombreCli='+$('#nombreClienteGL').val()+'&cuentaAho='+$('#cuentaAhoIDGL').val()+
								'&tipoCuen='+$('#tipoCuentaGL').val()+'&tipoTransaccion='+$('#tipoTransaccion').val()+
								'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaGL').val()+'&productoCred='+''+
								'&tipoCuen='+$('#tipoCuentaGL').val()+'&grupo='+$('#grupoDesGL').val()+
								'&ciclo='+$('#cicloIDGL').val());
					}else{												
						imprimeTicketReversa();											
					}

				break;
				case catTipoTransaccionVen.comisionApertura: 
					var fechaHora = $('#fechaSistemaP').val()+" " +hora(); 
					var varCreditoID = $('#creditoIDAR').val();	 
					if(TipoImpresion !=ticket){
						$('#enlaceTicket').attr('href','ReversaComisionApertura.htm?fechaSistemaP='+fechaHora+
							'&monto='+$('#totalDepAR').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
							'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
							'&varCreditoID='+varCreditoID+'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalSal').val()+
							'&diferencia='+$('#sumTotalEnt').val()+'&varFormaPago='+"Efectivo"+    
							'&numCli='+$('#clienteIDAR').val()+'&nombreCli='+$('#nombreClienteAR').val()+'&cuentaAho='+$('#cuentaAhoIDAR').val()+
							'&tipoCuen='+$('#nomCuentaAR').val()+'&tipoTransaccion='+$('#tipoTransaccion').val()+
							'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaDesAR').val()+'&montoComision='+$('#comisionAR').val()+
							'&montoIva='+$('#ivaAR').val()+'&productoCred='+$('#desProdCreditoAR').val()+
							'&grupo='+$('#grupoDesAR').val()+'&ciclo='+$('#cicloIDAR').val());
					}else{															
						imprimeTicketReversa();						
					}
					
				break;
				
				case catTipoTransaccionVen.desembolsoCredito:
					var fechaHora = $('#fechaSistemaP').val()+" " +hora();
					var varCreditoID = $('#creditoIDDC').val();	
					var ante = $('#totalDesembolsoDC').asNumber()-$('#montoPorDesemDC').asNumber();
					var porDesem = $('#montoPorDesemDC').asNumber()-$('#totalRetirarDC').asNumber();
					
					if(TipoImpresion !=ticket){
						$('#enlaceTicket').attr('href','ReversaDesembolsoCredito.htm?fechaSistemaP='+fechaHora+
							'&monto='+$('#totalRetirarDC').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
							'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
							'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
							'&diferencia='+$('#sumTotalSal').val()+'&varFormaPago='+"Efectivo"+
							'&numCli='+$('#clienteIDDC').val()+'&nombreCli='+$('#nombreClienteDC').val()+'&cuentaAho='+$('#cuentaAhoIDDC').val()+
							'&referen='+$('#creditoIDDC').val()+'&tipoCuen='+$('#nomCuentaDC').val()+'&tipoTransaccion='+$('#tipoTransaccion').val()+
							'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaDesDC').val()+'&montoComision='+$('#comisionDC').val()+
							'&montoIva='+$('#ivaDC').val()+'&productoCred='+$('#desProdCreditoDC').val()+
							'&varCreditoID='+varCreditoID+'&montoCred='+$('#montoCreDC').val()+'&monPorDes='+porDesem+
							'&montoDes='+$('#totalDesembolsoDC').val()+'&montoResAnt='+ante+
							'&grupo='+$('#grupoDesDC').val()+'&ciclo='+$('#cicloIDDC').val());
					}else{
						imprimeTicketReversa();		
					}
					
				break;
				case catTipoTransaccionVen.cobroSeguroVida:
					if(TipoImpresion !=ticket){
						window.open('TicketReversaVenSegVida.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
								'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
								$('#numeroTransaccion').val()+'&clienteIDSC='+$('#clienteIDSC').val()+'&nombreClienteSC='+$('#nombreClienteSC').val()+
								'&montoSeguroCobro='+$('#montoSeguroCobro').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion=8'+'&direccionInstitucion='+direccionInstitucion+
								'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+telefono+'&fechaSistema='+$('#fechaSistema').val()+
								'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+
								'&descripcionMoneda='+descrpcion, '_blank');						
					}else{					
						agregaFormatoMoneda('formaGenerica');
						imprimeTicketReversa();
					}
				break;
				case catTipoTransaccionVen.aplicaSeguroVida:	
					var transaccionReporteSiniestro=9;
					$('#enlaceTicket').attr('href','ReversaSegVidaSiniestro.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
							'&poliza='+$('#numeroPolizaS').val()+'&clienteIDSC='+$('#clienteIDS').val()+'&nombreClienteSC='+$('#nombreClienteS').val()+
							'&creditoIDS='+$('#creditoIDS').val()+'&fechaInicioSeguro='+$('#fechaInicioSeguro').val()+'&fechaVencimiento='+$('#fechaVencimiento').val()+
							'&beneficiarioSeguro='+$('#beneficiarioSeguro').val()+'&direccionBeneficiario='+$('#direccionBeneficiario').val()+
							'&desRelacionBeneficiario='+$('#desRelacionBeneficiario').val()+'&montoPoliza='+$('#montoPoliza').asNumber()+
							'&nombreSucursal='+$('#nombreSucursal').val()+'&nomCajero='+$('#nomCajero').val()+
							'&fechaSistema='+$('#fechaSistema').val()+ '&tipoTransaccion=9'+'&numeroSucursal='+sucursalID+'&desMonedaBase='+monedaBase+
							'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+
							'&descripcionMoneda='+descrpcion, '_blank');																		
				break;
				
			}
		}
		else{
			$('#impTicket').hide();
			$('#numeroTransaccion').val("");
		}		
	});
	
	 
	


		function grabaFormaTransaccionVentanilla(event, idForma, idDivContenedor, idDivMensaje, inicializaforma, idCampoOrigen) {

		var jqForma = eval("'#" + idForma + "'");
		var jqContenedor = eval("'#" + idDivContenedor + "'");
		var jqMensaje = eval("'#" + idDivMensaje + "'");
		var url = $(jqForma).attr('action');
		var resultadoTransaccion = 0;

		quitaFormatoControles(idForma);
		//No descomentar la siguiente linea
		$(jqMensaje).html('<img src="images/barras.jpg" alt=""/>');
		$(jqContenedor).block({
		message : $(jqMensaje),
		css : {
		border : 'none',
		background : 'none'
		}
		});
		// Envio de la forma

		$.post(url, serializaForma(idForma), function(data) {
			if (data.length > 0) {
				$(jqMensaje).html(data);
				var exitoTransaccion = $('#numeroMensaje').val();
				var consecutivo = $('#consecutivo').asNumber();
				resultadoTransaccion = exitoTransaccion;

				parametroBean = consultaParametrosSession();
				$('#saldoMNSesionLabel').text(parametroBean.saldoEfecMN);
				$('#saldoMNSesionLabel').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
				});

				if (exitoTransaccion == 0 && inicializaforma == 'true' && consecutivo > 0) {
					agregaFormatoControles(idForma);

					var campo = eval("'#" + idCampoOrigen + "'");
					if ($('#consecutivo').val() != 0) {
						$(campo).val($('#consecutivo').val());
					}
					imprimirTicketVentanilla();
					$('#impTicket').show();
					actualizaFormatosMoneda('formaGenerica');
					$('#billetesMonedasEntrada').val("");
					$('#billetesMonedasSalida').val("");
					deshabilitaBoton('graba', 'submit');

				} else {
					if (exitoTransaccion == 0) {
						imprimirTicketVentanilla();
					}
					deshabilitaBoton('graba', 'submit');
					$('#impTicket').hide();
					actualizaFormatosMoneda('formaGenerica');
				}
				deshabilitaBoton('graba', 'submit');
				deshabilitaControl('pagoGLEfectivo');
				deshabilitaControl('pagoGLCargoCuenta');
				var campo = eval("'#" + idCampoOrigen + "'");
				if ($('#consecutivo').val() != 0) {
					$(campo).val($('#consecutivo').val());
				}
			}
		});
		return resultadoTransaccion;
	}
	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			tipoOperacion: 'required',

			numeroTransaccionCC :{  
				required: function() {
					return $('#tipoOperacion').val() == cargoCuenta; }
			},

			numeroTransaccionAC : {
				required: function() {
					return $('#tipoOperacion').val() == abonoCuenta; }
			},

			numeroTransaccionGL : {
				required: function() {
					return $('#tipoOperacion').val() == garantiaLiq; }
			}, 

			numeroTransaccionAR : {
				required: function() {
					return $('#tipoOperacion').val() == comAperCred; }
			},

			numeroTransaccionDC : {
				required: function() {
					return $('#tipoOperacion').val() == desemboCred; }
			},

			numeroTransaccionCSV :  {
				required: function() {
					return $('#tipoOperacion').val() == cobroSeguroVida; }
			},

			numeroTransaccionSV : {
				required: function() {
					return $('#tipoOperacion').val() == aplicaSeguroVida; }
			},
			
			cantEntraMil: {number: true},
			cantEntraQui: {number: true},
			cantEntraDos: {number: true},
			cantEntraCien: {number: true},
			cantEntraCin: {number: true},
			cantEntraVei: {number: true},
			cantEntraMon: {number: true},
						
			cantSalMil: {number: true},
			cantSalQui: {number: true},
			cantSalDos: {number: true},
			cantSalCien: {number: true},
			cantSalCin: {number: true},
			cantSalVei: {number: true},
			cantSalMon: {number: true},
			contrasenia:{required: true},
			nombreUsuario:	'required',

			claveUsuarioAut: 'required',
			contraseniaAut: 'required'
		},
		
		messages: {
			tipoOperacion: 'Especifique tipo de Operacion.',

			numeroTransaccionCC: 'Especifique Número de Transacción.',
			numeroTransaccionAC: 'Especifique Número de Transacción.',
			numeroTransaccionGL: 'Especifique Número de Transacción.',
			numeroTransaccionAR: 'Especifique Número de Transacción.',
			numeroTransaccionDC: 'Especifique Número de Transacción.',
			numeroTransaccionCSV: 'Especifique Número de Transacción.',
			numeroTransaccionSV: 'Especifique Número de Transacción.',
			
			cantEntraMil: {number: 'Solo números.'}, 
			cantEntraQui: {number: 'Solo números.'}, 
			cantEntraDos: {number: 'Solo números.'}, 
			cantEntraCien: {number: 'Solo números.'}, 
			cantEntraCin: {number: 'Solo números.'}, 
			cantEntraVei: {number: 'Solo números.'}, 
			cantEntraMon: {number: 'Solo números.'}, 
			
			cantSalMil: {number: 'Solo números.'}, 
			cantSalQui: {number: 'Solo números.'}, 
			cantSalDos: {number: 'Solo números.'}, 
			cantSalCien: {number: 'Solo números.'}, 
			cantSalCin: {number: 'Solo números.'}, 
			cantSalVei: {number: 'Solo números.'}, 
			cantSalMon: {number: 'Solo números.'}, 
			contrasenia:{required: 'Especifique su contraseña.'},
			nombreUsuario:'Especifique el nombre de Usuario.',

			claveUsuarioAut: 'Especifique Usuario.',
			contraseniaAut: 'Especifique Contraseña.'
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	function consultarParametrosBean() {
		var parametroBean = consultaParametrosSession();
		$('#fechaSistemaP').val(parametroBean.fechaSucursal);
		$('#nombreInstitucion').val(parametroBean.nombreInstitucion);
		$('#numeroSucursal').val(parametroBean.sucursal);
		$('#nombreSucursal').val(parametroBean.nombreSucursal);
		$('#numeroCaja').val(parametroBean.cajaID);
		$('#nomCajero').val(parametroBean.nombreUsuario);
	}
	
	// validar el limite de efectivo de la caja
	function consultaLimiteCaja() {
		parametroBean = consultaParametrosSession();
		var varMontoLimiteMN = parametroBean.limiteEfectivoMN; 
		var saldoEfectCaja = $('#saldoEfecMNSesion').asNumber(); 
		if(parametroBean.cajaID>0){
			if(parseFloat(varMontoLimiteMN) >= parseFloat(saldoEfectCaja)){
				bloquearCaja = "no";
			}else{
				bloquearCaja = "si";
				inicializarCampos();
				deshabilitaBoton('graba', 'submit');
				$('#impTicket').hide();
				mensajeSis("Para Poder Realizar una Nueva Operación es \n" +
						"Necesario Realizar una Transferencia de Efectivo.");
			}
		}
		else{
			bloquearCaja = "si";
			inicializarCampos();
			deshabilitaBoton('graba', 'submit');
		}
		return bloquearCaja;
	}

	function consultaTransaccionReversa(){
		var consultaTransaccion = 1;
		var reversaTransaccion = {
			'transaccionID'		: numTransaccion
		};
		if(numTransaccion != '' && !isNaN(numTransaccion)){
			reversasOperCajaServicios.consulta(consultaTransaccion, reversaTransaccion, { async: false, callback:function(transaccionReversa) {
				if(transaccionReversa !=null){
					existeTransaccion = 1;
				}else{
					existeTransaccion = 0;
				}}	
			});
		}
	}

	// ********************************************CARGO A CUENTA ************************************
	function consultaMovsCajaCargoCuenta(idControl){		
		
		var jqTransaccion  = eval("'#" + idControl + "'");
		var transaccion = $(jqTransaccion).val();	
		var consultaTransaccion= 1;
		var transaccioncajamovs = {
			'numeroMov'		:transaccion,
			'sucursal'		:$('#numeroSucursal').asNumber(),
			'cajaID'		:$('#numeroCaja').asNumber(),
			'fecha'			:$('#fechaSistema').val(),
			'tipoOperacion'	:catTipoOperacion.opeSalCargoCuenta
		};  
		
		setTimeout("$('#cajaLista').hide();", 200);
		if(transaccion != '' && !isNaN(transaccion)){
			ingresosOperacionesServicio.consulta(consultaTransaccion, transaccioncajamovs,function(transaccionCaja) {
		
						if(transaccionCaja!=null){	
							if(transaccionCaja.esEfectivo=='S'){
								$('#cuentaAhoIDCa').val(transaccionCaja.instrumento);	
								$('#montoCargar').val(transaccionCaja.montoEnFirme);
								consultaCtaAhoCargo(transaccionCaja.instrumento);
								$('#referenciaCa').focus();					  		

						  		inicializarEntradasSalidasEfectivo();
	  							consultaDisponibleDenominacion();  		
								consultarParametrosBean();
								$('#descripcionOper').val('CARGO A CUENTA');							
								$('#referenciaCa').val("");  
								$('#numeroTransaccion').val("");
								$('#numeroMensaje').val("1");
								$('#claveUsuarioAut').val("");  
								$('#contraseniaAut').val("");  
								$('#motivo').val("");
								$('#entradaSalida').show();
								$('#totales').show();

								totalEntradasSalidasDiferencia();

					  		}
						  	else{
					  			mensajeSis('Sólo se Permiten Operaciones en Efectivo.');
					  			inicializarCampos();
					  			$('#numeroTransaccionCC').focus();
						  	}
						}else{
							mensajeSis("Transacción de Retiro de Efectivo No existe.");
							$('#numeroTransaccionCC').focus();
							inicializarCampos();
							
						}
				});															
		}		
	}

	function consultaCtaAhoCargo(numCta) {
		var tipConCampos = 4;
		var CuentaAhoBeanCon = {
			'cuentaAhoID' : numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCta != '' && !isNaN(numCta)) {
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon, {
			async : false,
			callback : function(cuenta) {
				if (cuenta != null) {
					$('#tipoCuentaCa').val(cuenta.descripcionTipoCta);
					$('#cuentaAhoIDCa').val(cuenta.cuentaAhoID);
					$('#numClienteCa').val(cuenta.clienteID);
					esTab = "true";
					consultaClientePantallaCargo('numClienteCa');
					consultaSaldoCtaAhoCargo('cuentaAhoIDCa', cuenta.clienteID);

				} else {
					mensajeSis("No Existe la Cuenta de Ahorro.");
					$('#cuentaAhoIDCa').focus();
					inicializarCampos();
				}
			}
			});
		}
	}
	
	function consultaSaldoCtaAhoCargo(idControl,numCte) {
		var jqCta  = eval("'#" + idControl + "'");
		var numCta = $(jqCta).val();
		var tipConCampos= 5;
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta,
			'clienteID'		:numCte
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){	
							$('#saldoDisponCa').val(cuenta.saldoDispon);	
							$('#monedaCa').val(cuenta.descripcionMoneda);	
							$('#monedaIDCa').val(cuenta.monedaID);	
							
						}else{
							mensajeSis("No Existe la Cuenta de Ahorro o No Corresponde a ese "+safilocale+".");
							$('#cuentaAhoIDCa').focus();
							inicializarCampos();										
						}
				});															
		}
	}

	
	function consultaClientePantallaCargo(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conCliente = 5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente)) {
			clienteServicio.consulta(conCliente, numCliente, rfc, {
			async : false,
			callback : function(cliente) {
				if (cliente != null) {
					var tipo = (cliente.tipoPersona);
					$('#nombreClienteCa').val(cliente.nombreCompleto);
					if (tipo == "M") {
						$('#nombreClienteCa').val(cliente.razonSocial);
					}

				} else {
					mensajeSis("No Existe el " + safilocale + ".");
					$(jqCliente).focus();
				}
			}
			});
		}
	}
	
	//********************************************ABONO A CUENTA ************************************
	function consultaMovsCajaAbonoCuenta(idControl) {
		var jqTransaccion = eval("'#" + idControl + "'");
		var transaccion = $(jqTransaccion).val();
		var consultaTransaccion = 1;
		var transaccioncajamovs = {
		'numeroMov' : transaccion,
		'sucursal' : $('#numeroSucursal').asNumber(),
		'cajaID' : $('#numeroCaja').asNumber(),
		'fecha' : $('#fechaSistema').val(),
		'tipoOperacion' : catTipoOperacion.opeCajEntEfCta
		};

		setTimeout("$('#cajaLista').hide();", 200);

		if (transaccion != '' && !isNaN(transaccion)) {
			ingresosOperacionesServicio.consulta(consultaTransaccion, transaccioncajamovs, {
			async : false,
			callback : function(transaccionCaja) {
				if (transaccionCaja != null) {
					$('#cuentaAhoIDAb').val(transaccionCaja.instrumento);
					$('#montoAbonar').val(transaccionCaja.montoEnFirme);
					consultaCtaAhoAbono('cuentaAhoIDAb');
					$('#referenciaCa').focus();
					totalEntradasSalidasDiferencia();
				} else {
					mensajeSis("Operación de Abono a Cuenta No existe.");
					$('#numeroTransaccionAC').focus();
					inicializarCampos();
				}
			}
			});
		}
	}
	



	function consultaCtaAhoAbono(idControl) {
		var numCta = $('#cuentaAhoIDAb').val();
		var tipConCampos = 4;
		var CuentaAhoBeanCon = {
			'cuentaAhoID' : numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCta != '' && !isNaN(numCta)) {
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon, {
			async : false,
			callback : function(cuenta) {
				if (cuenta != null) {
					$('#tipoCuentaAb').val(cuenta.descripcionTipoCta);
					$('#cuentaAhoIDAb').val(cuenta.cuentaAhoID);
					$('#numClienteAb').val(cuenta.clienteID);
					esTab = true;
					consultaClientePantallaAbono('numClienteAb');
					consultaSaldoCtaAhoAbono('cuentaAhoIDAb', cuenta.clienteID);

				} else {
					mensajeSis("No Existe la Cuenta de Ahorro.");
					$('#cuentaAhoIDAb').focus();
					$('#cuentaAhoIDAb').select();
				}
			}
			});
		}
	}
	
	function consultaSaldoCtaAhoAbono(idControl,numCte) {
		var jqCta  = eval("'#" + idControl + "'");
		var numCta = $(jqCta).val();
		var tipConCampos= 5;
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta,
			'clienteID'		:numCte
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){	
							$('#saldoDisponAb').val(cuenta.saldoDispon);	
							$('#monedaAb').val(cuenta.descripcionMoneda);		
							$('#monedaIDAb').val(cuenta.monedaID);
						}else{
							mensajeSis("No Existe la Cuenta de Ahorro o No Corresponde a ese "+safilocale+".");
							$('#cuentaAhoIDAb').focus();
							$('#cuentaAhoIDAb').select();										
						}
				});															
		}
	}

	
	function consultaClientePantallaAbono(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente, numCliente, rfc, {
			async : false,
			callback : function(cliente) {
				if (cliente != null) {
					var tipo = (cliente.tipoPersona);
					
					$('#nombreClienteAb').val(cliente.nombreCompleto);
					
					if (tipo == "M") {
						$('#nombreClienteAb').val(cliente.razonSocial);
					}

				} else {
					mensajeSis("No Existe el " + safilocale + ".");
					$(jqCliente).focus();
				}
			}
			});
			}
	}
	
	//******************************************** DEPOSITO DE GARANTIA LIQUIDA ************************************
	function consultaMovsCajaGarantiaLiquida(idControl){		
		var jqTransaccion  = eval("'#" + idControl + "'");
		var transaccion = $(jqTransaccion).val();	
		var consultaTransaccion= 1;
		var transaccioncajamovs = {
			'numeroMov'	:transaccion,
			'sucursal'	:$('#numeroSucursal').asNumber(),
			'cajaID'	:$('#numeroCaja').asNumber(),
			'fecha'		:$('#fechaSistema').val(),
			'tipoOperacion':catTipoOperacion.opeCajEntGarLiq
		};
		
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(transaccion != '' && !isNaN(transaccion)){
			ingresosOperacionesServicio.consulta(consultaTransaccion, transaccioncajamovs,function(transaccionCaja) {
		
						if(transaccionCaja!=null){	
							$('#cuentaAhoIDGL').val(transaccionCaja.instrumento);	
							$('#montoGarantiaLiq').val(transaccionCaja.montoEnFirme); 							
							$('#referenciaGL').val(transaccionCaja.referenciaMov);
							consultaCreditoGL(transaccionCaja.referenciaMov,transaccion, transaccionCaja.montoEnFirme);
							$('#claveUsuarioAut').focus();
						}else{
							mensajeSis("La Operación de Garantía Líquida No Existe.");
							inicializarCampos();			
							$('#numeroTransaccionGL').focus();										
						}
				});															
		}		
	}
// Funcion que para saber si el pago de la garantia Liquida fue en efectivo o Cargo a Cuenta
	function consultaTipoOperacion(transaccion,monto, estatusCredito){
		var consultaTransaccion= 1;
		var transaccioncajamovs = {
			'numeroMov'	:transaccion,
			'sucursal'	:$('#numeroSucursal').asNumber(),
			'cajaID'	:$('#numeroCaja').asNumber(),
			'fecha'		:$('#fechaSistema').val(),
			'tipoOperacion':catTipoOperacion.opeEntXDepGLCargoCuenta
		};
		
		setTimeout("$('#cajaLista').hide();", 200);
		if(transaccion != '' && !isNaN(transaccion)){
			ingresosOperacionesServicio.consulta(consultaTransaccion, transaccioncajamovs,function(transaccionCaja) {		
						if(transaccionCaja!=null){	
							$('#pagoGLCargoCuenta').attr("checked",true);
							$('#pagoGLEfectivo').attr("checked",false);
							$('#entradaSalida').hide();
							$('#totales').hide();
						}else{
							$('#pagoGLCargoCuenta').attr("checked",false);
							$('#pagoGLEfectivo').attr("checked",true);
							$('#entradaSalida').show();
							$('#totales').show();													
						}
						
						if(estatusCredito =='I'){
							habilitaEntradasSalidasEfectivo(); 
							totalEntradasSalidasDiferencia();				
						}else{
							mensajeSis("El Crédito No se Encuentra Inactivo.");
							soloLecturaEntradasSalidasEfectivo();
							deshabilitaBoton('graba', 'submit');	
						}

				});															
		}		
	}
	//** funciones para la consulta de los datos por deposito de gl 
	function consultaCreditoGL(referencia,transaccionReversa,montoReversa){
		$('#tipoTransaccion').val(catTipoTransaccionVen.garantiaLiq); 
		var numCredito = $('#referenciaGL').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) ){
			var creditoBeanCon = { 
				'creditoID':referencia,
  				'fechaActual':$('#fechaSistema').val()
  			};						
   			creditosServicio.consulta(11,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
   				if(credito!=null){
   					esTab=true;	
   					   					
   					$('#numClienteGL').val(credito.clienteID);					
					$('#numClienteGL').val();					
					$('#numeroTransaccion').val("");
					$('#numeroMensaje').val("1");
					
					agregaFormatoMoneda('formaGenerica');
					//consultaCreditosClientes(credito.clienteID);
					consultaTipoOperacion(transaccionReversa,montoReversa,credito.estatus);
					consultaCtaAhoGarantiaLiquida(credito.cuentaID);
					consultaClientePantallaGarantiaLiq(credito.clienteID);				
					
   				}else{
   					inicializaForma('formaGenerica','numClienteGL');
   					consultaDisponibleDenominacion();
   					mensajeSis("El "+safilocale+" No tiene un Crédito Relacionado.");
   					inicializarCampos();
   					$('#numClienteGL').focus();
   				}
			});
		}
	}

	// funcion para consultar la descripcion del Tipo de Cuenta	
	function consultaCtaAhoGarantiaLiquida(numCta) {			
		var tipConCampos= 4;
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCta != '' && !isNaN(numCta)){
			
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){	
							$('#tipoCuentaGL').val(cuenta.descripcionTipoCta);
							esTab= "true";
							consultaSaldoCtaAhoGarantiaLiq(cuenta.cuentaAhoID,cuenta.clienteID);
																		
						}else{
							mensajeSis("No Existe la Cuenta de Ahorro.");
							$('#cuentaAhoIDGL').focus();
							$('#cuentaAhoIDGL').select();
							inicializarCampos();
						}
				});															
		}else{
			inicializarCampos();
		}
	}
	

	// funcion para consultar los saldos 
	function consultaSaldoCtaAhoGarantiaLiq(numCta,numCte) {
		var tipConCampos= 5;
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta,
			'clienteID'		:numCte
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){	
							$('#saldoDisponGL').val(cuenta.saldoDispon);
							$('#saldoBloqGL').val(cuenta.saldoBloq);	
							$('#monedaGL').val(cuenta.descripcionMoneda);		
							$('#monedaIDGL').val(cuenta.monedaID);
						}else{
							mensajeSis("No Existe la Cuenta de Ahorro o No Corresponde a ese "+safilocale+".");
							$('#cuentaAhoIDGL').focus();
							$('#cuentaAhoIDGL').select();										
						}
				});															
		}
	}
	
	
	
	//** funciones para consultar el grupo y monto sugerido de gl***
	function consultaGrupoMontoGL(valControl){ 
		var numCredito = valControl;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito)){
			var creditoBeanCon = { 
				'creditoID':numCredito
				};
   			
   			creditosServicio.consulta(12,creditoBeanCon,function(credito) {
   				if(credito!=null){
   					esTab=true;	
					$('#grupoIDGL').val(credito.grupoID);
					if(credito.grupoID>0){
	   					$('#cicloIDGL').val(credito.cicloGrupo);
						consultaGrupo(credito.grupoID, 'grupoIDGL', 'grupoDesGL','cicloIDGL');
						$('#tdGrupoGLlabel').show();
						$('#tdGrupoGLinput').show();
						$('#tdGrupoCicloGLlabel').show();
						$('#tdGrupoCicloGLinput').show();
					}else {
						$('#grupoDesGL').val("");
						$('#tdGrupoGLlabel').hide();
						$('#tdGrupoGLinput').hide();
						$('#tdGrupoCicloGLlabel').hide();
						$('#tdGrupoCicloGLinput').hide();
					}			
					
					$('#tipoTransaccion').val(catTipoTransaccionVen.garantiaLiq); 
					
   				}else{
   					inicializaForma('formaGenerica','creditoIDDC');
   					consultaDisponibleDenominacion();
   					inicializarCampos();
   				}
			});
		}else{
			deshabilitaBoton('graba', 'submit');
		}
	}
	
	// fruncion para consultar el nombre del Cliente o empresa
	function consultaClientePantallaGarantiaLiq(numCliente) {
		var conCliente =5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
					if(cliente!=null){		
							$('#nombreClienteGL').val(cliente.nombreCompleto);						
					}else{
						mensajeSis("No Existe el "+safilocale+".");
						$(jqCliente).focus();
					}    						
			});
		}
	}
	
	
	// funcion par inicializar los campos de gl
	function inicializarCamposGL(){
		$('#cuentaAhoIDGL').val("");
		$('#tipoCuentaGL').val("");
		$('#saldoDisponGL').val("");
		$('#saldoBloqGL').val("");
		$('#monedaIDGL').val("");
		
		$('#monedaGL').val("");
		$('#montoGarantiaLiq').val("");
		$('#grupoIDGL').val("");
		$('#cicloIDGL').val("");
		$('#grupoDesGL').val("");		
	}
	
	//************************************************** COMISION POR APERTURA  *****************************
	function consultaMovsCajaComisionApertura(idControl){
		var jqTransaccion  = eval("'#" + idControl + "'");
		var transaccion = $(jqTransaccion).val();	
		var consultaTransaccion= 1;
		var transaccioncajamovs = {
			'numeroMov'	:transaccion,
			'sucursal'	:$('#numeroSucursal').asNumber(),
			'cajaID'	:$('#numeroCaja').asNumber(),
			'fecha'		:$('#fechaSistema').val(),
			'tipoOperacion':catTipoOperacion.opeComisionAPCredito
		};
		
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(transaccion != '' && !isNaN(transaccion)){
			ingresosOperacionesServicio.consulta(consultaTransaccion, transaccioncajamovs,function(transaccionCaja) {
		
						if(transaccionCaja!=null){	
							$('#cuentaAhoIDAR').val(transaccionCaja.instrumento);	
							$('#totalDepAR').val(transaccionCaja.montoEnFirme); 							
							$('#creditoIDAR').val(transaccionCaja.referenciaMov);
							consultaCreditoComAp(transaccionCaja.referenciaMov);
							$('#claveUsuarioAut').focus();
							totalEntradasSalidasDiferencia();
						}else{
							mensajeSis("La Operación de Comisión por Apertura no Existe.");
							inicializarCampos();
							$('#numeroTransaccionAR').focus();
						}
				});															
		}
		
	}

	function consultaCreditoComAp(creditoID){		
		setTimeout("$('#cajaLista').hide();", 200);
		if(creditoID != '' && !isNaN(creditoID) ){
			var creditoBeanCon = { 
				'creditoID':creditoID,
  				'fechaActual':$('#fechaSistema').val()
  			};   			
   			creditosServicio.consulta(11,creditoBeanCon,function(credito) {
   				if(credito!=null){
   					esTab=true;	
					$('#creditoIDAR').val(credito.creditoID);
					$('#clienteIDAR').val(credito.clienteID);
					$('#productoCreditoIDAR').val(credito.producCreditoID);
					$('#cuentaAhoIDAR').val(credito.cuentaID);
					$('#montoCreAR').val(credito.montoCredito);
					$('#monedaIDAR').val(credito.monedaID);
					
					$('#montoComisionAR').val(credito.montoComision); 	//monto real comision
					$('#ivaMontoRealAR').val(credito.IVAComApertura);	//iva del monto real
					$('#totalPagadoDepAR').val(credito.comAperPagado);	//comision ya pagada																	
					
					var ivaSucur=Number(ivaSucursal);
					var comision=$('#totalDepAR').asNumber()/(1+ivaSucur);
					$('#comisionAR').val(comision);						//comision pagada a regresar
					$('#ivaAR').val(comision * ivaSucur);				//iva a pagado a regresar
										
					$('#claveUsuarioAut').focus();
					$('#claveUsuarioAut').select();
					$('#grupoIDAR').val(credito.grupoID);  					
					$('#formaCobAR').val(credito.forCobroComAper);  
										
					if(credito.forCobroComAper == 'A'){
						$('#tipoComisionAR').val("ANTICIPADO");
					}else{					
						mensajeSis("La Forma de Cobro de la Comisión por Apertura del Crédito No es Anticipado.");
						soloLecturaEntradasSalidasEfectivo();
						deshabilitaBoton('graba', 'submit');	
						
						if(credito.forCobroComAper == 'D'){
							$('#tipoComisionAR').val("DEDUCCIÓN");
						}else{
							if(credito.forCobroComAper == 'F'){
								$('#tipoComisionAR').val('FINANCIAMIENTO');
							}
						}
					}	
					
					if(credito.estatus== 'A'){		
						mensajeSis("El Crédito ya fue Autorizado.");
						soloLecturaEntradasSalidasEfectivo();
						deshabilitaBoton('graba', 'submit');	
					}else{
						habilitaEntradasSalidasEfectivo();
					}

					if(credito.grupoID > 0){
	   					$('#cicloIDAR').val(credito.cicloGrupo);
						consultaGrupo(credito.grupoID,'grupoIDAR','grupoDesAR','cicloIDAR');
						$('#tdGrupoARlabel').show();
						$('#tdGrupoARinput').show();
						$('#tdGrupoCicloARlabel').show();
						$('#tdGrupoCicloARinput').show();
					}else {
						$('#grupoDesAR').val("");
						$('#grupoIDAR').val("");
						$('#tdGrupoARlabel').hide();
						$('#tdGrupoARinput').hide(); 
						$('#tdGrupoCicloARlabel').hide(); 
						$('#tdGrupoCicloARinput').hide(); 
					}	
					
					consultaClienteComApDes(credito.clienteID, 'clienteIDAR','nombreClienteAR');
					consultaMonedaComAp(credito.monedaID);	
					consultaCtaComAp(credito.cuentaID,credito.clienteID);	
					consultaProdCred(credito.producCreditoID); 
					$('#tipoTransaccion').val(catTipoTransaccionVen.comisionApertura);
					$('#numeroTransaccion').val("");
					agregaFormatoMoneda('formaGenerica');
					
					
   				}else{
   					inicializaForma('formaGenerica','creditoIDAR');
   					consultaDisponibleDenominacion();
   					mensajeSis("No Existe el Crédito.");
   					$('#creditoIDAR').focus();
   					$('#creditoIDAR').select();	
   					inicializarCampos();
   				}
			});
		}
	}
	
	function consultaMonedaComAp(idControl) {
		var numMoneda = idControl;	 
		var conMoneda=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMoneda != '' && !isNaN(numMoneda)){
			monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
				if(moneda!=null){							
					$('#monedaDesAR').val(moneda.descripcion);										
				}else{
					mensajeSis("No Existe el Tipo de Moneda.");
					$('#monedaDesAR').val('');
					$(jqMoneda).focus();
				}
			});
		}
	}
	
	
	function consultaCtaComAp(idControl, clienteID) {
		var numCta =idControl;	 
        var conCta = 3;   
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':clienteID
        };
        setTimeout("$('#cajaLista').hide();", 200);
        
        if(numCta != '' && !isNaN(numCta)){
        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
        		if(cuenta!=null){ 
        			consultaTipoCtaComAp(cuenta.tipoCuentaID); 
        		}else{
        			mensajeSis("No Existe la Cuenta de Ahorro.");
        		}
        	});                                                                                                                        
        }
	}
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
					$('#desProdCreditoAR').val(prodCred.descripcion);							
				}else{
					$('#creditoIDAR').focus();
				}    						
			});
		}
	}

	function consultaTipoCtaComAp(idControl) {
		var numTipoCta = idControl;	
		var conTipoCta=2;
		var TipoCuentaBeanCon = {
  			'tipoCuentaID':numTipoCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoCta != '' && !isNaN(numTipoCta)){
			tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,function(tipoCuenta) {
				if(tipoCuenta!=null){			
					$('#nomCuentaAR').val(tipoCuenta.descripcion);							
				}else{
					$('#cuentaAhoIDAR').focus();
				}    						
			});
		}
	}
	//****************************** Para la multiplicacion de las cantidades por la denominacion**********************
	function cantidadPorDenominacionMil(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraMil').val(parseFloat(cantidad)*parseFloat(mil));	 
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
			crearListaBilletesMonedasSalida();
		}
	}
	function cantidadPorDenominacionQui(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraQui').val(parseFloat(cantidad)*parseFloat(quinientos));	
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
			crearListaBilletesMonedasSalida();
		}
	}
	function cantidadPorDenominacionDos(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraDos').val(parseFloat(cantidad)*parseFloat(doscientos));	
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
			crearListaBilletesMonedasSalida();
		}
	}
	function cantidadPorDenominacionCien(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraCien').val(parseFloat(cantidad)*parseFloat(cien));
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
			crearListaBilletesMonedasSalida();
		}
	}
	function cantidadPorDenominacionCin(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraCin').val(parseFloat(cantidad)*parseFloat(cincuenta));
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
			crearListaBilletesMonedasSalida();
		}
	}
	function cantidadPorDenominacionVei(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraVei').val(parseFloat(cantidad)*parseFloat(veinte));
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
			crearListaBilletesMonedasSalida();
		}
	}
	function cantidadPorDenominacionMon(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraMon').val(parseFloat(cantidad)*parseFloat(monedaValor));
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
			crearListaBilletesMonedasSalida();
		}
	}
	
	

	
	
	// Para la multiplicacion de las cantidades por la denominacion
	function cantidadPorDenominacionMilS(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoSalMil').val(parseFloat(cantidad)*parseFloat(mil));
			sumaTotalSalidasEfectivo();
			crearListaBilletesMonedasSalida();
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionQuiS(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoSalQui').val(parseFloat(cantidad)*parseFloat(quinientos));
			sumaTotalSalidasEfectivo();
			crearListaBilletesMonedasSalida();
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionDosS(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoSalDos').val(parseFloat(cantidad)*parseFloat(doscientos));
			sumaTotalSalidasEfectivo();		
			crearListaBilletesMonedasSalida();
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionCienS(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoSalCien').val(parseFloat(cantidad)*parseFloat(cien));			
			sumaTotalSalidasEfectivo();
			crearListaBilletesMonedasSalida();
			crearListaBilletesMonedasEntrada();
		}
	}
	
	function cantidadPorDenominacionCinS(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoSalCin').val(parseFloat(cantidad)*parseFloat(cincuenta));
			sumaTotalSalidasEfectivo();
			crearListaBilletesMonedasSalida();
			crearListaBilletesMonedasEntrada();
		}
	}

	function cantidadPorDenominacionVeiS(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoSalVei').val(parseFloat(cantidad)*parseFloat(veinte));
			sumaTotalSalidasEfectivo();
			crearListaBilletesMonedasSalida();
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionMonS(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoSalMon').val(parseFloat(cantidad)*parseFloat(monedaValor));
			sumaTotalSalidasEfectivo();
			crearListaBilletesMonedasSalida();
			crearListaBilletesMonedasEntrada();
		}
	}	
	
	//para llevar el total de entradas de efectivo
	function sumaTotalEntradasEfectivo() { 		
		esTab= true;
		setTimeout("$('#cajaLista').hide();", 200);
		var suma = parseFloat(0);
		$('input[name=montoEntrada]').each(function() {
			jqMontoEntrada = eval("'#" + this.id + "'");
			montoEntrada= $(jqMontoEntrada).asNumber(); 
			if(montoEntrada != '' && !isNaN(montoEntrada)){
				suma = parseFloat(suma) + parseFloat(montoEntrada);
				$(jqMontoEntrada).formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});		
			}
			else {
				$(jqMontoEntrada).val(0);
			}
		});
		
		$('#sumTotalEnt').val(suma);
		$('#sumTotalEnt').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});		
	}
	
	//para llevar el total de entradas de efectivo
	function sumaTotalSalidasEfectivo() { 
		esTab= true;
		setTimeout("$('#cajaLista').hide();", 200);
		var suma = parseFloat(0);
		$('input[name=montoSalida]').each(function() {
			jqMontoSalida= eval("'#" + this.id + "'");
			montoSalida= $(jqMontoSalida).asNumber(); 
			if(montoSalida != '' && !isNaN(montoSalida)){
				suma = parseFloat(suma) + parseFloat(montoSalida);
				
				$(jqMontoSalida).formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});		
			}
			else {
				$(jqMontoSalida).val(0);
			}
		});
		
		$('#sumTotalSal').val(suma);
		$('#sumTotalSal').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});		
	}
	
	//para llevar el total de entradas  ttt		
	function totalEntradasSalidasDiferencia() {
		consultarParametrosBean();
		controlQuitaFormatoMoneda('sumTotalSal');
		controlQuitaFormatoMoneda('sumTotalEnt');
		esTab= true;
		setTimeout("$('#cajaLista').hide();", 200);
		var sumaEntradas = parseFloat(0);
		var sumaSalidas = parseFloat(0);
		var diferencia = parseFloat(0);

		var sumaEntradasOperacion = parseFloat(0);
		var sumaSalidasOperacion	= parseFloat(0);

		var sumTotalSal= $('#sumTotalSal').asNumber(); 
		var sumTotalEnt= $('#sumTotalEnt').asNumber(); 
		var montoCargar= $('#montoCargar').asNumber(); 
		var montoAbonar= $('#montoAbonar').asNumber(); 
		var montoPagar= $('#montoPagar').asNumber();
		var montoGarLiq= $('#montoGarantiaLiq').asNumber();
		var montoApCre= $('#totalDepAR').asNumber();
		var montoDesCre= $('#totalRetirarDC').asNumber();
		var montoPoliza= $('#montoPoliza').asNumber();
		var montoSeguroCobrarC= $('#montoSeguroCobro').asNumber();
		
		sumaSalidas= parseFloat(sumTotalSal)+ parseFloat(montoCargar) +parseFloat(montoDesCre)+parseFloat(montoPoliza);
		
		sumaEntradas	= parseFloat(sumTotalEnt)+ parseFloat(montoPagar)+parseFloat(montoGarLiq)+parseFloat(montoApCre)+parseFloat(montoSeguroCobrarC)+ parseFloat(montoAbonar);		
		
		sumaSalidasOperacion = parseFloat(montoCargar) +parseFloat(montoDesCre)+
			parseFloat(montoPoliza);
		
		sumaEntradasOperacion	=  parseFloat(montoPagar)+ parseFloat(montoGarLiq) +
			parseFloat(montoApCre)+parseFloat(montoSeguroCobrarC) +parseFloat(montoAbonar);

		if(parseFloat(sumaEntradas)>=parseFloat(sumaSalidas)){
			diferencia = parseFloat(sumaEntradas)- parseFloat(sumaSalidas) ;
		}else{
			diferencia = parseFloat(sumaSalidas)- parseFloat(sumaEntradas) ;
		}
		
		$('#totalEntradas').val(sumaEntradas);
		$('#totalSalidas').val(sumaSalidas);
		$('#diferencia').val(diferencia);

		if($('#tipoTransaccion').val() == catTipoTransaccionVen.garantiaLiq && $('#pagoGLCargoCuenta').attr('checked') == true){
				diferencia=0;
		}

		if(diferencia == 0 && (sumaEntradasOperacion > 0 || sumaSalidasOperacion > 0)){
			if($('#tipoTransaccion').val() ==catTipoTransaccionVen.garantiaLiq){
				if($('#referenciaGL').val()==null || $('#referenciaGL').val()==""){
					deshabilitaBoton('graba', 'submit');

				}	
				else{
					habilitaBoton('graba', 'submit');
				}	
			}else{
				habilitaBoton('graba', 'submit');
			}
			
		}else{
			deshabilitaBoton('graba', 'submit');
		}
		
		
		actualizaFormatosMoneda('formaGenerica');
		$('#numeroTransaccion').val("");
		
	}
	//Función para inicializar Tipo de Operación al usar el SELECT: Tipo de Operación
	function inicializaTipoOperacion(){
		inicializarCampos();
		inicializarCamposGL();
		$('#cargoCuenta').hide();
		$('#abonoCuenta').hide();
		$('#garantiaLiq').hide();
		$('#comisionApertura').hide();
		$('#desembolsoCred').hide();
		$('#pagoSeguroVida').hide();
		$('#cobroSeguroVida').hide();
		$('#usuarioContrasenia').show();
		$('#entradaSalida').show();
		$('#totales').show();
	}

	// Función para inicializar la operación, cuando el campo transacción pierde el foco
	function inicializaOperacion(idControl){
		$('#impTicket').hide();
		$('#numeroTransaccion').val("");
		$('#numeroMensaje').val("1");
		$('#claveUsuarioAut').val("");  
		$('#contraseniaAut').val("");  
		$('#motivo').val("");
		inicializarEntradasSalidasEfectivo();
		consultaDisponibleDenominacion();  				
		consultarParametrosBean();
		
		var jqT  = eval("'#" + idControl + "'");
		numTransaccion = $(jqT).val();	
	}
		
	// funcion para inicializar valores de cantidad y Monto para
	// entradas y salidas de efectivo
	function inicializarEntradasSalidasEfectivo() {
		$('#cantEntraMil').val(0);
		$('#cantEntraQui').val(0);
		$('#cantEntraDos').val(0);
		$('#cantEntraCien').val(0);
		$('#cantEntraCin').val(0);
		$('#cantEntraVei').val(0);
		$('#cantEntraMon').val(0);
		
		$('#cantSalMil').val(0);
		$('#cantSalQui').val(0);
		$('#cantSalDos').val(0);
		$('#cantSalCien').val(0);
		$('#cantSalCin').val(0);
		$('#cantSalVei').val(0);
		$('#cantSalMon').val(0);

		$('#montoEntraMil').val(0);
		$('#montoEntraQui').val(0);
		$('#montoEntraDos').val(0);
		$('#montoEntraCien').val(0);
		$('#montoEntraCin').val(0);
		$('#montoEntraVei').val(0);
		$('#montoEntraMon').val(0);

		$('#montoSalMil').val(0);
		$('#montoSalQui').val(0);
		$('#montoSalDos').val(0);
		$('#montoSalCien').val(0);
		$('#montoSalCin').val(0);
		$('#montoSalVei').val(0);
		$('#montoSalMon').val(0);
		
		$('#disponSalMil').val(0);
		$('#disponSalQui').val(0);
		$('#disponSalDos').val(0);
		$('#disponSalCien').val(0);
		$('#disponSalCin').val(0);
		$('#disponSalVei').val(0);
		$('#disponSalMon').val(0);

		$('#sumTotalSal').val(0);
		$('#sumTotalEnt').val(0);
		$('#totalEntradas').val(0);
		$('#totalSalidas').val(0);
		$('#diferencia').val(0);

		$('#saldoCapVigent').val(0);  
		$('#saldoCapAtrasad').val(0);  
		$('#saldoCapVencido').val(0);
		$('#saldCapVenNoExi').val(0);    
		$('#totalCapital').val(0);  
		$('#saldoInterOrdin').val(0);
		$('#saldoInterAtras').val(0);
		$('#saldoInterAtras').val(0);
		$('#saldoInterVenc').val(0);
		$('#saldoInterProvi').val(0);
		$('#saldoIntNoConta').val(0);
		$('#totalInteres').val(0);
		$('#saldoIVAInteres').val(0);
		$('#saldoMoratorios').val(0);
		$('#saldoIVAMorator').val(0);
		$('#saldoComFaltPago').val(0);
		$('#saldoOtrasComis').val(0);
		$('#totalComisi').val(0);  
		$('#salIVAComFalPag').val(0);
		$('#saldoIVAComisi').val(0);
		$('#totalIVACom').val(0);
		$('#pagoExigible').val(0);
		$('#adeudoTotal').val(0);
		
		$('#denoEntraMon').val("Monedas");
		$('#denoSalMon').val("Monedas");		
	}	
	

	// Funcion para inicializar forma, cuando la transacción no existe
	function inicializarCampos(){
		// ------ RETIRO DE EFECTIVO ------ 
		$('#numeroTransaccionCC').val('');
		$('#cuentaAhoIDCa').val('');
		$('#tipoCuentaCa').val("");
		$('#numClienteCa').val('');
		$('#nombreClienteCa').val('');
		$('#monedaIDCa').val('');
		$('#monedaCa').val('');
		$('#saldoDisponCa').val('');
		$('#montoCargar').val('');
		$('#referenciaCa').val('');
		//
		$('#montoPagar').val('');
		$('#monedaDes').val('');
		$('#grupoID').val('');
		$('#cicloID').val('');
		$('#garantiaAdicionalPC').val('0.00');
		$('#gridIntegrantes').html('');
		$('#gridIntegrantes').hide();

		$('#nombreInstitucion').val('');
		$('#sumTotalEnt').val('');
		$('#sumTotalSal').val('');
		$('#tipoTransaccion').val('');
		$('#numeroTransaccion').val('');
		
		// ------ ABONO A CUENTA ------ 
		$('#numeroTransaccionAC').val('');
		$('#cuentaAhoIDAb').val('');
		$('#tipoCuentaAb').val('');
		$('#numClienteAb').val('');
		$('#nombreClienteAb').val('');
		$('#monedaIDAb').val('');
		$('#monedaAb').val('');
		$('#saldoDisponAb').val('');
		$('#montoAbonar').val('');
		$('#referenciaAb').val('');
		
		// ------ GARANTIA LIQUIDA ------
		$('#numeroTransaccionGL').val('');
		$('#numClienteGL').val('');
		$('#nombreClienteGL').val('');
		$('#referenciaGL').val('');
		$('#cuentaAhoIDGL').val('');
		$('#tipoCuentaGL').val('');
		$('#saldoDisponGL').val('');
		$('#saldoBloqGL').val('');
		$('#monedaIDGL').val('');
		$('#monedaGL').val('');	
		$('#montoGarantiaLiq').val('');
		$('#grupoIDGL').val('');
		$('#grupoDesGL').val('');
		
		// -----COMISION POR APERTURA ------
		$('#numeroTransaccionAR').val('');
		$('#creditoIDAR').val('');
		$('#clienteIDAR').val('');
		$('#nombreClienteAR').val('');
		$('#montoCreAR').val('');
		$('#productoCreditoIDAR').val('');
		$('#desProdCreditoAR').val('');
		$('#cuentaAhoIDAR').val('');
		$('#nomCuentaAR').val('');
		$('#monedaIDAR').val('');
		$('#monedaDesAR').val('');	
		$('#tipoComisionAR').val('');
		$('#formaCobAR').val('');
		$('#montoComisionAR').val('');	
		$('#ivaMontoRealAR').val('');
		$('#totalPagadoDepAR').val('');
		$('#totalDepAR').val('');
		$('#comisionAR').val('');
		$('#ivaAR').val('');
		$('#grupoIDAR').val('');
		$('#grupoDesAR').val('');
		$('#cicloIDAR').val('');
		//
		$('#comisionPendienteAR').val('');
		$('#ivaPendienteAR').val('');

		// ----- DESEMBOLSO DE CREDITO ------
		$('#numeroTransaccionDC').val('');
		$('#creditoIDDC').val('');
		$('#clienteIDDC').val('');
		$('#nombreClienteDC').val('');
		$('#montoCreDC').val('');
		$('#productoCreditoIDDC').val('');
		$('#desProdCreditoDC').val('');
		$('#cuentaAhoIDDC').val('');
		$('#nomCuentaDC').val('');
		$('#saldoDisponDC').val('');
		$('#monedaIDDC').val('');
		$('#monedaDesDC').val('');
		$('#tipoComisionDC').val('');
		$('#comisionDC').val('');
		$('#ivaDC').val('');		
		$('#totalDesembolsoDC').val('');
		$('#montoPorDesemDC').val('');
		$('#totalRetirarDC').val('');		
		$('#grupoIDDC').val('');
		$('#grupoDesDC').val('');
		$('#cicloIDDC').val('');
	
		// ----- COBRO COBERTURA DE RIESGO ------
		$('#numeroTransaccionCSV').val('');
		$('#creditoIDSC').val('');
		$('#clienteIDSC').val('');
		$('#nombreClienteSC').val('');
		$('#montoCreditoSC').val('');
		$('#productoCreditoSC').val('');
		$('#desProdCreditoSC').val('');
		$('#estatusCreditoSeguroC').val('');
		$('#cuentaClienteSC').val('');
		$('#descCuentaSeguroC').val('');
		$('#monedaSC').val('');
		$('#monedaDesSC').val('');
		$('#grupoIDSC').val('');
		$('#grupoDesSC').val('');
		$('#cicloIDSC').val('');
		$('#numeroPolizaSC').val('');
		$('#estatusSeguroC').val('');
		$('#fechaInicioSeguroC').val('');
		$('#fechaVencimientoC').val('');
		$('#beneficiarioSeguroC').val('');
		$('#relacionBeneficiarioC').val('');
		$('#desRelacionBeneficiarioC').val('');
		$('#direccionBeneficiarioC').val('');
		$('#montoPolizaC').val('');
		$('#montoSeguroVidaC').val('');
		$('#montoPagoSegurVidaC').val('');
		$('#montoPendienteCobro').val('');
		$('#montoSeguroCobro').val('');		


		// ----- APLICAR COBERTURA DE RIESGO ------
		$('#numeroTransaccionSV').val('');
		$('#creditoIDS').val('');
		$('#clienteIDS').val('');
		$('#nombreClienteS').val('');
		$('#montoCreditoS').val('');
		$('#productoCreditoS').val('');
		$('#desProdCreditoS').val('');
		$('#estatusCreditoSeguro').val('');
		$('#diasAtrasoCredito').val('');
		$('#cuentaClienteS').val('');
		$('#descCuentaSeguro').val('');
		$('#monedaS').val('');
		$('#monedaDesS').val('');
		$('#numeroPolizaS').val('');
		$('#estatusSeguro').val('');
		$('#fechaInicioSeguro').val('');
		$('#fechaVencimiento').val('');
		$('#beneficiarioSeguro').val('');
		$('#relacionBeneficiario').val('');
		$('#desRelacionBeneficiario').val('');
		$('#direccionBeneficiario').val('');
		$('#montoPoliza').val('');

		$('#grupoIDS').val('');
		$('#grupoDesS').val('');
		$('#cicloIDS').val('');
		
		//----- Seccion Usuario Autoriza -----
		$('#claveUsuarioAut').val('');
		$('#contraseniaAut').val('');
		$('#motivo').val('');		
		$('#descripcionOper').val('');

		//----- Totales ------
		$('#totalEntradas').val('0');
		$('#totalSalidas').val('0');
		$('#diferencia').val('0');
		
		consultarParametrosBean();
		inicializarEntradasSalidasEfectivo(); 
		consultaDisponibleDenominacion();
		deshabilitaBoton('graba', 'submit');
		$('#impTicket').hide();
	}	
	
	//deshabilitarEntradasSalidasEfectivo		
	function soloLecturaEntradasSalidasEfectivo() {
		$('#cantEntraMil').attr('readOnly',true);		
		$('#cantEntraQui').attr('readOnly',true);	
		$('#cantEntraDos').attr('readOnly',true);	
		$('#cantEntraCien').attr('readOnly',true);	
		$('#cantEntraCin').attr('readOnly',true);	
		$('#cantEntraVei').attr('readOnly',true);	
		$('#cantEntraMon').attr('readOnly',true);	
		$('#cantSalMil').attr('readOnly',true);	
		$('#cantSalQui').attr('readOnly',true);	
		$('#cantSalDos').attr('readOnly',true);	
		$('#cantSalCien').attr('readOnly',true);	
		$('#cantSalCin').attr('readOnly',true);	
		$('#cantSalVei').attr('readOnly',true);	
		$('#cantSalMon').attr('readOnly',true);	
		$('#claveUsuarioAut').attr('readOnly',true);	
		$('#contraseniaAut').attr('readOnly',true);	
		$('#motivo').attr('disabled',true);	
		
	}	
	function habilitaEntradasSalidasEfectivo() {
		$('#cantEntraMil').attr('readOnly',false);		
		$('#cantEntraQui').attr('readOnly',false);	
		$('#cantEntraDos').attr('readOnly',false);	
		$('#cantEntraCien').attr('readOnly',false);	
		$('#cantEntraCin').attr('readOnly',false);	
		$('#cantEntraVei').attr('readOnly',false);	
		$('#cantEntraMon').attr('readOnly',false);	
		$('#cantSalMil').attr('readOnly',false);	
		$('#cantSalQui').attr('readOnly',false);	
		$('#cantSalDos').attr('readOnly',false);	
		$('#cantSalCien').attr('readOnly',false);	
		$('#cantSalCin').attr('readOnly',false);	
		$('#cantSalVei').attr('readOnly',false);	
		$('#cantSalMon').attr('readOnly',false);
		$('#claveUsuarioAut').attr('readOnly',false);	
		$('#contraseniaAut').attr('readOnly',false);	
		$('#motivo').attr('disabled',false);	
	}	
	
	function inicializarTransaccion(){
		$('#numeroTransaccionCC').val('');
		$('#numeroTransaccionAC').val('');
		$('#numeroTransaccionGL').val('');
		$('#numeroTransaccionDC').val('');
		$('#numeroTransaccionCSV').val('');
		$('#numeroTransaccionSV').val('');
		$('#numeroTransaccionAR').val('');
	}

	// Consulta de grupos  PAGO CREDITO,COMISION POR APERTURA, DESEMBOLSO CREDITO, COBRO SEGURO DE VIDA
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

	// consulta el nombre de clienta para com apertura o desembolso y cobro del seguro de Vida
	function consultaClienteComApDes(idControl, clienteID, nombreCliente) {
		var numCliente = idControl;	
		var jqnumCte  = eval("'#" + clienteID + "'");
		var jqnomCte  = eval("'#" + nombreCliente + "'");

		var tipConPagoCred = 8;	 
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente) ){
			clienteServicio.consulta(tipConPagoCred,numCliente,function(cliente) {
				if(cliente!=null){	
					$(jqnumCte).val(cliente.numero);					
					$(jqnomCte).val(cliente.nombreCompleto);
				}else{
					mensajeSis("No Existe el "+safilocale+".");
					$(jqnomCte).focus();
					$(jqnomCte).select();	
				}    	 						
			});
		}
	}
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
					$('#desProdCreditoAR').val(prodCred.descripcion);							
				}else{
					$('#creditoIDAR').focus();
				}    						
			});
		}
	}
	
	//********************************** funciones para el DESEMBOLSO DE CREDITO**********************************************
	function consultaMovsCajaDesemCredito(idControl){		
		var jqTransaccion  = eval("'#" + idControl + "'");
		var transaccion = $(jqTransaccion).val();	
		var consultaTransaccion= 1;
		var transaccioncajamovs = {
			'numeroMov'	:transaccion,
			'sucursal'	:$('#numeroSucursal').asNumber(),
			'cajaID'	:$('#numeroCaja').asNumber(),
			'fecha'	:$('#fechaSistema').val(),
			'tipoOperacion':catTipoOperacion.opeDesembolsoCredito
		};
		
		setTimeout("$('#cajaLista').hide();", 200);

		if(transaccion != '' && !isNaN(transaccion)){
			ingresosOperacionesServicio.consulta(consultaTransaccion, transaccioncajamovs,function(transaccionCaja) {
		
						if(transaccionCaja!=null){	
							if(transaccionCaja.esEfectivo=='S'){
								$('#creditoIDDC').val(transaccionCaja.referenciaMov);							
								$('#cuentaAhoIDDC').val(transaccionCaja.instrumento);
								$('#totalRetirarDC').val(transaccionCaja.montoEnFirme);
								consultaCreditoDesCre(transaccionCaja.referenciaMov);
								$('#claveUsuarioAut').focus();
								totalEntradasSalidasDiferencia();
							}else{
					  			mensajeSis('Sólo se Permiten Operaciones en Efectivo.');
					  			inicializarCampos();
					  			$('#numeroTransaccionDC').focus();
						  	}
						}else{
							mensajeSis("Operación de Desembolso de Crédito No existe.");
							inicializarCampos();		
							$('#numeroTransaccionDC').focus();	
						}
				});															
		}		
	}
	
	
	
	function consultaCreditoDesCre(numCredito){
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito)){
			var creditoBeanCon = { 
				'creditoID':numCredito,
  				'fechaActual':$('#fechaSistema').val()
  			};
   			
   			creditosServicio.consulta(11,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
   				if(credito!=null){
   					esTab=true;	
					$('#creditoIDDC').val(credito.creditoID);
					$('#clienteIDDC').val(credito.clienteID);
					$('#productoCreditoIDDC').val(credito.producCreditoID);
					$('#cuentaAhoIDDC').val(credito.cuentaID);
					consultaCtaDesem(credito.cuentaID);
					$('#montoCreDC').val(credito.montoCredito);
					$('#monedaIDDC').val(credito.monedaID);
					$('#comisionDC').val(credito.montoComision);
					$('#ivaDC').val(credito.IVAComApertura);
					$('#totalDC').val(credito.totalComAper);
					$('#montoPorDesemDC').val(credito.montoPorDesemb);
					$('#totalDesembolsoDC').val(credito.montoDesemb);
					//$('#totalRetirarDC').val(credito.montoPorDesemb);
					if(credito.forCobroComAper == 'A'){
						$('#tipoComisionDC').val("ANTICIPADO");
					}else{
						if(credito.forCobroComAper == 'D'){
							$('#tipoComisionDC').val("DEDUCCIÓN");
						}else{
							if(credito.forCobroComAper == 'F'){
								$('#tipoComisionDC').val('FINANCIAMIENTO');
							}
						}
					}
					$('#grupoIDDC').val(credito.grupoID);
					if(credito.grupoID>0){
   						$('#cicloIDDC').val(credito.cicloGrupo);
						consultaGrupo(credito.grupoID, 'grupoIDDC', 'grupoDesDC', 'cicloIDDC');
						$('#tdGrupoDClabel').show();
						$('#tdGrupoDCinput').show();
						$('#tdGrupoCicloDClabel').show();
						$('#tdGrupoCicloDCinput').show();
						
					}else {
						$('#grupoDesDC').val("");
						$('#tdGrupoDClabel').hide();
						$('#tdGrupoDCinput').hide();
						$('#tdGrupoCicloDClabel').hide();
						$('#tdGrupoCicloDCinput').hide();
					}	
					
					consultaClienteComApDes(credito.clienteID, 'clienteIDDC','nombreClienteDC');
					consultaMonedaDesem(credito.monedaID);	
					consultaProdCredDesem(credito.producCreditoID);
					consultaCtaDesem('cuentaAhoIDDC'); 
					consultaSaldoCtaDesem('cuentaAhoIDDC', 'saldoDisponDC','totalRetirarDC', credito.montoPorDesemb); 
					agregaFormatoMoneda('formaGenerica');

					$('#tipoTransaccion').val(catTipoTransaccionVen.desembolsoCredito); 
					
   				}else{
   					inicializaForma('formaGenerica','creditoIDDC');
   					consultaDisponibleDenominacion();
   					$('#creditoIDDC').focus();
   					$('#creditoIDDC').select();	
   					inicializarCampos();
   				}
			});
		}else{
			inicializarCampos();
		}
	}
	// CONSULTA DE CUENTA PARA EL DESEMBOLSO
	function consultaCtaDesem(idControl) { 
		var jqnumCta  = eval("'#" + idControl + "'");
		var numCta = $(jqnumCta).val();	 
        var conCta = 3;   
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteIDDC').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);
        
        if(numCta != '' && !isNaN(numCta)){
        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
        		if(cuenta!=null){ 
        			$('#nomCuentaDC').val(cuenta.tipoCuentaID);
        			consultaTipoCtaDesem('nomCuentaDC'); 
        		}else{
        			mensajeSis("No Existe la Cuenta de Ahorro.");
        		}
        	});                                                                                                                        
        }
	}
	
	// CONSULTA DE TIPO DE CUENTA PARA EL DESEMBOLSO
	function consultaTipoCtaDesem(idControl) {
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
					$('#nomCuentaDC').val(tipoCuenta.descripcion);							
				}else{
					$(jqTipoCta).focus();
				}    						
			});
		}
	}
	
	// consulta de producto de credito para el desembolso
	function consultaProdCredDesem(idControl) {
		var numProdCre = idControl;	
		var conTipoCta=2;
		var ProdCredBeanCon = {
  			'producCreditoID':numProdCre
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProdCre != '' && !isNaN(numProdCre)){
			productosCreditoServicio.consulta(conTipoCta, ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){			
					$('#desProdCreditoDC').val(prodCred.descripcion);							
				}else{
					$('#creditoIDDC').focus();
				}    						
			});
		}
	}
	
	// consulta de la moneda para el desembolso
	function consultaMonedaDesem(idControl) {
		var numMoneda = idControl;	
		var conMoneda=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMoneda != '' && !isNaN(numMoneda)){
			monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
				if(moneda!=null){							
					$('#monedaDesDC').val(moneda.descripcion);										
				}else{
					mensajeSis("No Existe el Tipo de Moneda.");
					$('#monedaDesDC').val('');
					$('#creditoIDDC').focus();
				}
			});
		}
	}
	
	// valida el saldo disponible para el desembolso 
	function consultaSaldoCtaDesem(idControl, idsaldo,totalDesID, totalDes) { 
		var jqnumCta  = eval("'#" + idControl + "'");
		var jqsalCta  = eval("'#" + idsaldo + "'");
		var jqtotalDes  = eval("'#" + totalDesID + "'");
		var numCta = $(jqnumCta).val();	 
        var conCta = 5;   
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteIDDC').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);
        
        if(numCta != '' && !isNaN(numCta)){
        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) { 
        		if(cuenta!=null){
        			$(jqsalCta).val(cuenta.saldoDispon);
        			if (totalDes<=$(jqsalCta).asNumber() ){
        				$(jqsalCta).val(cuenta.saldoDispon);
        			}else{ 
        				$(jqsalCta).val(cuenta.saldoDispon);
        				//$(jqtotalDes).val(cuenta.saldoDispon);
        			}
        		}else{
        			mensajeSis("No Existe la Cuenta de Ahorro.");
        		}
        	});                                                                                                                        
        }
	}
	
	function crearListaBilletesMonedasEntrada(){	
		$('#billetesMonedasEntrada').val("");
		$('#billetesMonedasEntrada').val($('#billetesMonedasEntrada').val()+
		$('#denoEntraMilID').val()+"-"+
		$('#cantEntraMil').asNumber()+"-"+
		$('#montoEntraMil').asNumber()+","+
		$('#denoEntraQuiID').val()+"-"+
		$('#cantEntraQui').asNumber()+"-"+
		$('#montoEntraQui').asNumber()+","+
		$('#denoEntraDosID').val()+"-"+
		$('#cantEntraDos').asNumber()+"-"+
		$('#montoEntraDos').asNumber()+","+
		$('#denoEntraCienID').val()+"-"+
		$('#cantEntraCien').asNumber()+"-"+
		$('#montoEntraCien').asNumber()+","+
		$('#denoEntraCinID').val()+"-"+
		$('#cantEntraCin').asNumber()+"-"+
		$('#montoEntraCin').asNumber()+","+
		$('#denoEntraVeiID').val()+"-"+
		$('#cantEntraVei').asNumber()+"-"+
		$('#montoEntraVei').asNumber()+","+
		$('#denoEntraMonID').val()+"-"+
		$('#cantEntraMon').asNumber()+"-"+
		$('#montoEntraMon').asNumber());
	}

	function crearListaBilletesMonedasSalida(){	
		$('#billetesMonedasSalida').val("");
		$('#billetesMonedasSalida').val($('#billetesMonedasSalida').val()+
		$('#denoSalMilID').val()+"-"+
		$('#cantSalMil').asNumber()+"-"+
		$('#montoSalMil').asNumber()+","+
		$('#denoSalQuiID').val()+"-"+
		$('#cantSalQui').asNumber()+"-"+
		$('#montoSalQui').asNumber()+","+
		$('#denoSalDosID').val()+"-"+
		$('#cantSalDos').asNumber()+"-"+
		$('#montoSalDos').asNumber()+","+
		$('#denoSalCienID').val()+"-"+
		$('#cantSalCien').asNumber()+"-"+
		$('#montoSalCien').asNumber()+","+
		$('#denoSalCinID').val()+"-"+
		$('#cantSalCin').asNumber()+"-"+
		$('#montoSalCin').asNumber()+","+
		$('#denoSalVeiID').val()+"-"+
		$('#cantSalVei').asNumber()+"-"+
		$('#montoSalVei').asNumber()+","+
		$('#denoSalMonID').val()+"-"+
		$('#cantSalMon').asNumber()+"-"+
		$('#montoSalMon').asNumber());
	}
	
	function consultaDisponibleDenominacion() {	
		var bean = {
			'sucursalID':$('#numeroSucursal').val(),
			'cajaID':$('#numeroCaja').val(),
			'denominacionID':0,
			'monedaID':1
		};	
		ingresosOperacionesServicio.listaConsulta(1, bean,function(disponDenom){
			for (var i = 0; i < disponDenom.length; i++){
				switch(parseInt(disponDenom[i].denominacionID))
				{
				case 1:$('#disponSalMil').val(disponDenom[i].cantidadDenominacion);
				break;
				case 2:$('#disponSalQui').val(disponDenom[i].cantidadDenominacion);
				break;
				case 3:$('#disponSalDos').val(disponDenom[i].cantidadDenominacion);
				break;
				case 4:$('#disponSalCien').val(disponDenom[i].cantidadDenominacion);
				break;
				case 5:$('#disponSalCin').val(disponDenom[i].cantidadDenominacion);
				break;
				case 6:$('#disponSalVei').val(disponDenom[i].cantidadDenominacion);
				break;
				case 7:	$('#disponSalMon').val(disponDenom[i].cantidadDenominacion);
				break;
				}
			}
			$('#saldoEfecMNSesion').val(
			parseFloat($('#disponSalMil').asNumber()*1000)+
			parseFloat($('#disponSalQui').asNumber()*500)+
			parseFloat($('#disponSalDos').asNumber()*200)+
			parseFloat($('#disponSalCien').asNumber()*100)+
			parseFloat($('#disponSalCin').asNumber()*50)+
			parseFloat($('#disponSalVei').asNumber()*20)+
			parseFloat($('#disponSalMon').asNumber()*1));
			
			$('#saldoEfecMNSesion').formatCurrency({
				positiveFormat: '%n',  
				negativeFormat: '%n',
				roundToDecimalPlace: 2	
			});			
		});
	}

	

	// funcion para obtener la hora del sistema
	function hora(){
		 var Digital=new Date();
		 var hours=Digital.getHours();
		 var minutes=Digital.getMinutes();
		 var seconds=Digital.getSeconds();
		
		 if (minutes<=9)
		 minutes="0"+minutes;
		 if (seconds<=9)
		 seconds="0"+seconds;
		return  hours+":"+minutes+":"+seconds;
	 }

	//********************************** FUNCIONES PARA EL PAGO DEL SEGURO DE VIDA POR SINIESTRO**********************************************
	function consultaMovsCajaAplicaSeguro(idControl){		
		var jqTransaccion  = eval("'#" + idControl + "'");
		var transaccion = $(jqTransaccion).val();	
		var consultaTransaccion= 1;
		var transaccioncajamovs = {
			'numeroMov'		:transaccion,
			'sucursal'		:$('#numeroSucursal').asNumber(),
			'cajaID'		:$('#numeroCaja').asNumber(),
			'fecha'			:$('#fechaSistema').val(),
			'tipoOperacion'	:catTipoOperacion.opeSalAplicacionSegVida
		};  
		
		setTimeout("$('#cajaLista').hide();", 200);
		if(transaccion != '' && !isNaN(transaccion)){
			ingresosOperacionesServicio.consulta(consultaTransaccion, transaccioncajamovs,function(transaccionCaja) {
					if(transaccionCaja!=null){
						if(transaccionCaja.esEfectivo=='S'){
							$('#creditoIDS').val(transaccionCaja.referenciaMov);
							$('#numeroPolizaS').val(transaccionCaja.instrumento);
							$('#montoPoliza').val(transaccionCaja.montoEnFirme);
							consultaCreditoSeguro(transaccionCaja.referenciaMov);
							$('#claveUsuarioAut').focus();
							totalEntradasSalidasDiferencia();
						}else{
					  		mensajeSis('Sólo se Permiten Operaciones en Efectivo.');
					  		inicializarCampos();
					  		$('#numeroTransaccionSV').focus();
						}
					}else{
						mensajeSis("La operación para Aplicar Cobertura de Riesgo No Existe.");
						$('#numeroTransaccionSV').focus();
						inicializarCampos();	
					}
				});															
		}		
	}
	
	function consultaCreditoSeguro(credito){		
		var Autorizado='A';
		var Vigente='V';
		var Vencido='B';
		var numCredito = $('#creditoIDS').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCredito != '' && !isNaN(numCredito)){
			var creditoBeanCon = { 
				'creditoID':credito,
  				'fechaActual':$('#fechaSistema').val()
  			};   			
   			creditosServicio.consulta(15,creditoBeanCon,function(credito) {
   				if(credito!=null){     					
   					validaEstatusCreditoSeguro(credito.estatus,'estatusCreditoSeguro');   					
   					if ( (credito.estatus==Autorizado) ||  (credito.estatus == Vigente )||( credito.estatus ==Vencido)){
   						$('#creditoIDS').val(credito.creditoID);
   						$('#clienteIDS').val(credito.clienteID);
   						$('#productoCreditoS').val(credito.producCreditoID);
   						$('#cuentaClienteS').val(credito.cuentaID);					    
   						$('#montoCreditoS').val(credito.montoCredito);
   						$('#monedaS').val(credito.monedaID);								
   					
   						$('#grupoIDS').val(credito.grupoID);
   						$('#diasAtrasoCredito').val(credito.diasAtraso);
   						if(credito.grupoID > 0){
   	   						$('#cicloIDS').val(credito.cicloGrupo);
   							consultaGrupo(credito.grupoID, 'grupoIDS', 'grupoDesS', 'cicloIDS');   							
   							$('#trGrupo').show();   						             
   						}else {   					
   							$('#trGrupo').hide();
   						
   						}
   						   					
   						consultaClienteComApDes(credito.clienteID, 'clienteIDS','nombreClienteS');
   						consultaMonedaSeguro(credito.monedaID,'monedaS', 'monedaDesS');	
   						consultaProdCredito(credito.producCreditoID,'productoCreditoS', 'desProdCreditoS'); 
   						consultaCuenta(credito.cuentaID,'cuentaClienteS','descCuentaSeguro');    	
   						validaEstatusCreditoSeguro(credito.estatus,'estatusCreditoSeguro');  
   						consultaSeguro('creditoIDS');
   						
   						agregaFormatoMoneda('formaGenerica');   						
   						$('#tipoTransaccion').val(catTipoTransaccionVen.aplicaSeguroVida);    						
   						
					}else{
						mensajeSis("El Crédito se encuentra  " + $('#estatusCreditoSeguro').val() + ".");//???
						inicializarCampos();
						deshabilitaBoton('graba', 'submit');							
					}   					   					
   				}else{
   					inicializaForma('formaGenerica','creditoIDS');
   					consultaDisponibleDenominacion();
   					$('#creditoIDS').focus();
   					$('#creditoIDS').select();	
   					inicializarCampos();
   				}
			});
		}else{
			inicializarCampos();
		}
	}
	function consultaSeguro(controlID){
		var cobrado='C';
		var anticipado='A';
		var financiamiento='F';
		var deduccion='D';
		var solicitudCero='0';
		
		var numCredito = $('#creditoIDS').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito )){
			var creditoBeanCon = { 
				'seguroVidaID':solicitudCero,
				'solicitudCreditoID':solicitudCero,
				'creditoID'	  :$('#creditoIDS').val(),
				'cuentaAhoID':solicitudCero,
  				
  			};   			   	
			seguroVidaServicio.consulta(2,creditoBeanCon,function(seguro) {
   				if(seguro!=null){
   					$('#creditoIDS').val(seguro.creditoID);
   					$('#numeroPolizaS').val(seguro.seguroVidaID);
   					$('#clienteIDS').val(seguro.clienteID);
   					$('#fechaInicioSeguro').val(seguro.fechaInicio);
   					$('#fechaVencimiento').val(seguro.fechaVencimiento);
   					$('#estatusSeguro').val(seguro.estatus);   					
   					$('#beneficiarioSeguro').val(seguro.beneficiario);
   					$('#direccionBeneficiario').val(seguro.direccionBeneficiario);
   					$('#relacionBeneficiario').val(seguro.relacionBeneficiario);   					
   					$('#desRelacionBeneficiario').val(seguro.descriRelacionBeneficiario);   					
   					$('#montoPoliza').val(seguro.montoPoliza);
   					if(seguro.forCobroSegVida==anticipado){
   						$('#pagoAnticipadoS').attr("checked",true);
   						$('#pagoFinanciadoS').attr("checked",false);
   						$('#pagoDeduccionS').attr("checked",false);
					}else if(seguro.forCobroSegVida==financiamiento){
						$('#pagoAnticipadoS').attr("checked",false);
						$('#pagoFinanciadoS').attr("checked",true);
						$('#pagoDeduccionS').attr("checked",false);
					}else if(seguro.forCobroSegVida==deduccion){
						$('#pagoAnticipadoS').attr("checked",false);
						$('#pagoFinanciadoS').attr("checked",false);
						$('#pagoDeduccionS').attr("checked",true);
					}   					
   					if(seguro.estatus!=cobrado){
						mensajeSis("La póliza Ya fue Cobrada.");
						soloLecturaEntradasSalidasEfectivo();
						deshabilitaBoton('graba', 'submit');
					}   					 				   				
   					validaEstatusSeguro(seguro.estatus,'estatusSeguro');
   					totalEntradasSalidasDiferencia();
   					  					   					
   				}else{
   					mensajeSis("El Crédito No tiene una Póliza Cobertura de Riesgo Asociada.");
   					inicializaForma('formaGenerica','creditoIDS');
   					consultaDisponibleDenominacion();   					   					
   					$('#creditoIDS').focus();
   					inicializarCampos();
   				}
			});
		}
	}
	function validaEstatusSeguro(estatus, idCampo){		
		var  inactivo='I';
		var  vigente='V';
		var  cobrado='C';
		
		if(estatus==inactivo){
			$('#'+idCampo).val('INACTIVO');   	
		}else if(estatus==vigente){
			$('#'+idCampo).val('VIGENTE');   	
		}else if(estatus==cobrado){
			$('#'+idCampo).val('COBRADO');   	
		}		
	}
	
	function consultaMonedaSeguro(valorID, id,desMoneda){
		var numMoneda = valorID;	
		var conMoneda=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMoneda != '' && !isNaN(numMoneda)){
			monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
				if(moneda!=null){							
					$('#'+desMoneda).val(moneda.descripcion);										
				}else{
					$('#'+id).val('');
					$('#'+id).focus();
				}
			});
		}
	}
	
	function consultaProdCredito(valorID,id,desProducto) {
		var numProdCre = valorID;	
		var conTipoCta=2;
		var ProdCredBeanCon = {
  			'producCreditoID':numProdCre
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProdCre != '' && !isNaN(numProdCre)){
			productosCreditoServicio.consulta(conTipoCta, ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){			
					$('#'+desProducto).val(prodCred.descripcion);							
				}else{
					$('#'+id).focus();
				}    						
			});
		}
	}

	function validaEstatusCreditoSeguro(var_estatus, idCampo) {
		var estatusInactivo 	="I";		
		var estatusAutorizado 	="A";
		var estatusVigente		="V";
		var estatusPagado		="P";
		var estatusCancelada 	="C";		
		var estatusVencido		="B";
		var estatusCastigado 	="K";		
		
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
	}
	
	//consulta 4 CUENTASAHOCON 
	function consultaCuenta(valorID,idCampo,desCuenta){	
		var jqnumCta  = eval("'#" + idCampo + "'");
		var numCta = $(jqnumCta).val();	 
        var conCta = 4;   
       
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':valorID,
        		'clienteID':$('#clienteIDS').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);
        
        
        if(numCta != '' && !isNaN(numCta)){
        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
        		if(cuenta!=null){         			
        			$('#cuentaClienteS').val(cuenta.cuentaAhoID);
        			$('#'+desCuenta).val(cuenta.descripcionTipoCta);
        		}else{
        			mensajeSis("No Existe la Cuenta de Ahorro.");
        		}
        	});                                                                                                                        
        }
	}
	
	
	//********************************** FUNCIONES PARA EL COBRO DEL SEGURO DE VIDA**********************************************		
	function consultaMovsCaja(idControl){		
		var jqTransaccion  = eval("'#" + idControl + "'");
		var transaccion = $(jqTransaccion).val();	
		var consultaTransaccion= 1;
		var transaccioncajamovs = {
			'numeroMov'	:transaccion,
			'sucursal'	:$('#numeroSucursal').asNumber(),
			'cajaID'	:$('#numeroCaja').asNumber(),
			'fecha'	:$('#fechaSistema').val(),
			'tipoOperacion':catTipoOperacion.opeCajaEntCobroseguroVida
		};
		
		setTimeout("$('#cajaLista').hide();", 200);

		if(transaccion != '' && !isNaN(transaccion)){
			ingresosOperacionesServicio.consulta(consultaTransaccion, transaccioncajamovs,function(transaccionCaja) {
					if(transaccionCaja!=null){
						totalEntradasSalidasDiferencia();	
						$('#creditoIDSC').val(transaccionCaja.referenciaMov);	
						$('#montoSeguroCobro').val(transaccionCaja.montoEnFirme);
						consultaCreditoSeguroVidaCobro('creditoIDSC');
						$('#claveUsuarioAut').focus();
						
					}else{
						mensajeSis("La Operación de Cobro de Cobertura de Riesgo No Existe.");
						$('#numeroTransaccionCSV').focus();
						inicializarCampos();
					}
				});															
		}		
	}

function consultaCreditoSeguroVidaCobro(controlID){		
		var Inactivo='I';		
		var numCredito = $('#creditoIDSC').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCredito != '' && !isNaN(numCredito)){
			var creditoBeanCon = { 
				'creditoID':$('#creditoIDSC').val(),
  				'fechaActual':$('#fechaSistema').val()
  			};
   			
   			creditosServicio.consulta(11,creditoBeanCon,function(credito) {
   				if(credito!=null){     					
   					validaEstatusCreditoSeguro(credito.estatus,'estatusCreditoSeguroC');   					   				
   						$('#creditoIDSC').val(credito.creditoID);
   						$('#clienteIDSC').val(credito.clienteID);
   						$('#productoCreditoSC').val(credito.producCreditoID);
   						$('#cuentaClienteSC').val(credito.cuentaID);					    
   						$('#montoCreditoSC').val(credito.montoCredito);
   						$('#monedaSC').val(credito.monedaID);		
   						$('#monedaSC').val(credito.monedaID);	
   						$('#montoPagoSegurVidaC').val(credito.seguroVidaPagado);	
   						$('#montoSeguroVidaC').val(credito.montoSeguroVida);	
   						$('#grupoIDSC').val(credito.grupoID);
   						if(credito.grupoID>0){
   	   						$('#cicloIDSC').val(credito.cicloGrupo);
   							consultaGrupo(credito.grupoID, 'grupoIDSC', 'grupoDesSC', 'cicloIDSC');
   							$('#tdGrupoCreditoS').show();		 									   
   							$('#tdGrupoCreditoSInputC').show();
   							$('#tdGrupoCicloSC').show();		
   							$('#tdGrupoCicloSinputC').show();
   							$('#grupoDesSC').show();		
   							$('#lblCreditoid').show();
   							$('#grupoIDSC').show();
   						}else {   							
   							$('#tdGrupoCreditoSC').hide();
   							$('#tdGrupoCreditoSInputC').hide();
   							$('#tdGrupoCicloSC').hide();
   							$('#tdGrupoCicloSinputC').hide();
   							$('#grupoDesSC').hide();		
   							$('#lblCreditoid').hide();
   							$('#grupoIDSC').hide();
   						}	   		   				
   						consultaClienteComApDes(credito.clienteID, 'clienteIDSC','nombreClienteSC');
   						consultaMonedaSeguro(credito.monedaID,'monedaSC', 'monedaDesSC');	
   						consultaProdCredito(credito.producCreditoID,'productoCreditoSC', 'desProdCreditoSC');    					
   						consultaCuenta(credito.cuentaID,'cuentaClienteSC','descCuentaSeguroC');    	   					
   						consultaSeguroCobro('creditoIDSC');
   						
   						agregaFormatoMoneda('formaGenerica');   						
   						$('#tipoTransaccion').val(catTipoTransaccionVen.cobroSeguroVida);   
   						if ( (credito.estatus!=Inactivo)){
							mensajeSis("El Crédito Ya se encuentra Vigente.");
							soloLecturaEntradasSalidasEfectivo();
							deshabilitaBoton('graba', 'submit');													
   						}   					   					
   				}else{
   					inicializaForma('formaGenerica','creditoIDSC');
   					consultaDisponibleDenominacion();
   					$('#creditoIDSC').focus();
   					$('#creditoIDSC').select();	
   					inicializarCampos();
   				}
			});

		}else{
			inicializarCampos();		
		}
	}

function consultaSeguroCobro(controlID){
	var cobrado='C';
	var anticipado='A';
	var financiamiento='F';
	var deduccion='D';
	var Cero='0';
	
	var numCredito = $('#creditoIDSC').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numCredito != '' && !isNaN(numCredito )){
		var creditoBeanCon = { 
			'seguroVidaID':Cero,
			'solicitudCreditoID':Cero,
			'creditoID'	  :$('#creditoIDSC').val(),
			'cuentaAhoID':Cero,
			};   			   	
		seguroVidaServicio.consulta(2,creditoBeanCon,function(seguro) {
				if(seguro!=null){
					validaEstatusSeguro(seguro.estatus,'estatusSeguroC');
					$('#creditoIDSC').val(seguro.creditoID);
					$('#numeroPolizaSC').val(seguro.seguroVidaID);
					$('#clienteIDSC').val(seguro.clienteID);
					$('#cuentaClienteSC').val(seguro.cuentaAhoID);
					$('#fechaInicioSeguroC').val(seguro.fechaInicio);
					$('#fechaVencimientoC').val(seguro.fechaVencimiento); 					
					$('#beneficiarioSeguroC').val(seguro.beneficiario);
					$('#direccionBeneficiarioC').val(seguro.direccionBeneficiario);
					$('#relacionBeneficiarioC').val(seguro.relacionBeneficiario);   				
					$('#desRelacionBeneficiarioC').val(seguro.descriRelacionBeneficiario);   		
					$('#montoPolizaC').val(seguro.montoPoliza);					
					var totalPendienteCobro= $('#montoSeguroVidaC').asNumber()-$('#montoPagoSegurVidaC').asNumber();	
					$('#montoPendienteCobro').val(totalPendienteCobro);
					
					if(seguro.forCobroSegVida==anticipado ){
						$('#pagoAnticipadoSC').attr("checked",true);
						$('#pagoFinanciadoSC').attr("checked",false);
						$('#pagoDeduccionSC').attr("checked",false);
						
					}else if(seguro.forCobroSegVida==financiamiento){
						$('#pagoAnticipadoSC').attr("checked",false);
						$('#pagoFinanciadoSC').attr("checked",true);
						$('#pagoDeduccionSC').attr("checked",false);
						mensajeSis("La Forma de Pago de la Póliza No es Anticipado.");
						soloLecturaEntradasSalidasEfectivo();
						deshabilitaBoton('graba', 'submit');
						$('#montoSeguroCobro').val('');	
						
					}else if(seguro.forCobroSegVida==deduccion){
						$('#pagoAnticipadoSC').attr("checked",false);
						$('#pagoFinanciadoSC').attr("checked",false);
						$('#pagoDeduccionSC').attr("checked",true);
						mensajeSis("La Forma de Pago de la Póliza No es Anticipado.");
						soloLecturaEntradasSalidasEfectivo();
						deshabilitaBoton('graba', 'submit');
						$('#montoSeguroCobro').val('');	
					}
					
					if(seguro.estatus ==cobrado){
						mensajeSis("El monto de la Póliza Ya se ha Cobrado.");
						soloLecturaEntradasSalidasEfectivo();
						deshabilitaBoton('graba', 'submit');
						$('#montoSeguroCobro').attr('disabled',true);
					}
						
					var fechaSistema=$('#fechaSistema').val();
					if(seguro.fechaVencimiento <= fechaSistema){
						mensajeSis("La Fecha de Vencimiento de la Póliza Ya paso.");
						soloLecturaEntradasSalidasEfectivo();
						deshabilitaBoton('graba', 'submit');   	
						$('#montoSeguroCobro').attr('disabled',true);
					}  							
					$('#claveUsuarioAut').focus();									
					totalEntradasSalidasDiferencia();
					agregaFormatoMoneda('formaGenerica'); 
				}else{
					mensajeSis("El Crédito no tiene una Póliza Cobertura de Riesgo Asociada.");
					inicializaForma('formaGenerica','creditoIDSC');
					consultaDisponibleDenominacion();   					   					
					$('#creditoIDSC').focus();
					$('#creditoIDSC').select();	
					inicializarCampos();
				}
		});
	}
}

	//Consulta si la caja esta Actual esta abierta y si es CA cual es su el ID de su CP
	 function estaAbiertaCaja(sucursalID,cajaID,tipoCaja){
		 var CajasVentanillaBeanConCajSuc = {
		  			'cajaID': cajaID
				};
		 var conPrincipal = 3;
			cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanConCajSuc ,function(cajasVentanillaConCaja){
				if(cajasVentanillaConCaja != null)
				{
					
				if(cajasVentanillaConCaja.sucursalID != sucursalID){
					mensajeSis('No puede Realizar esta Operacion ya que la Sucursal del Cajero No Concuerda con la Sucursal Asignada a la Caja.');
					deshabilitaItems();
				}else{

					var consultaCajaEO = 7;
					var parametrosBeanVentanilla = {
							'sucursalID':sucursalID,
							'cajaID':cajaID
					};
					//estan es para consultar la propia caja si esta cerrada, no importa si es BG pues nunca esta cerrada
					cajasVentanillaServicio.consulta(consultaCajaEO, parametrosBeanVentanilla , function(cajaVentanilla){
						if(cajaVentanilla != null)
						{
							if(cajaVentanilla.estatusOpera == 'C'){
								deshabilitaItems();
								mensajeSis('La Caja se encuentra Cerrada. Apertura la Caja para Realizar Operaciones.');
							}else{
								habilitaItems();
								deshabilitaBoton('graba','submit');
							}	
						}
					});
				
				}
			}
		});
	 }

	 function deshabilitaItems(){
		$('#tipoOperacion').attr('disabled',true);
		$('#numCopias').attr('disabled',true);
		deshabilitaBoton('graba','submit');
		deshabilitaBoton('agregarEntEfec','submit');
		deshabilitaBoton('agregarSalEfec','submit');
		$('#institucionID').attr('disabled',true);
		$('#numCtaInstit').attr('disabled',true);
		$('#monedaID').attr('disabled',true);
		$('#referencia').attr('disabled',true);
		$('#cantEntraMil').attr('disabled',true);
		$('#cantEntraQui').attr('disabled',true);
		$('#cantEntraDos').attr('disabled',true);
		$('#cantEntraCien').attr('disabled',true);
		$('#cantEntraCin').attr('disabled',true);
		$('#cantEntraVei').attr('disabled',true);
		$('#cantEntraMon').attr('disabled',true);
		$('#cantSalMil').attr('disabled',true);
		$('#cantSalQui').attr('disabled',true);
		$('#cantSalDos').attr('disabled',true);
		$('#cantSalCien').attr('disabled',true);
		$('#cantSalCin').attr('disabled',true);
		$('#cantSalVei').attr('disabled',true);
		$('#cantSalMon').attr('disabled',true);
	 }
	 function habilitaItems(){
		$('#tipoOperacion').removeAttr('disabled');
		$('#numCopias').removeAttr('disabled');
		habilitaBoton('graba','submit');
		habilitaBoton('agregarEntEfec','submit');
		habilitaBoton('agregarSalEfec','submit');
		$('#cantEntraMil').removeAttr('disabled');
		$('#cantEntraQui').removeAttr('disabled');
		$('#cantEntraDos').removeAttr('disabled');
		$('#cantEntraCien').removeAttr('disabled');
		$('#cantEntraCin').removeAttr('disabled');
		$('#cantEntraVei').removeAttr('disabled');
		$('#cantEntraMon').removeAttr('disabled');
		$('#cantSalMil').removeAttr('disabled');
		$('#cantSalQui').removeAttr('disabled');
		$('#cantSalDos').removeAttr('disabled');
		$('#cantSalCien').removeAttr('disabled');
		$('#cantSalCin').removeAttr('disabled');
		$('#cantSalVei').removeAttr('disabled');
		$('#cantSalMon').removeAttr('disabled');
	 }
	
function imprimeTicketReversa(){	//oooo
		
		switch($('#tipoTransaccion').val()) {
			case catTipoTransaccionVen.garantiaLiq: 
				var formaPago='';
				if($('#pagoGLEfectivo').attr('checked')==true){
					formaPago= 'Efectivo' ;		
					}else{
						formaPago= 'Cargo a Cuenta' ;				
						}
			     var ticketReversaGarantiaLiqBean={
		            'folio' 	        :$('#numeroTransaccion').val(),
		            'tituloOperacion'   :' REVERSA DEP. GARANTIA LIQUIDA',
					'clienteID' 		:$('#numClienteGL').val(),
					'nombreCliente'     :$('#nombreClienteGL').val(),
		            'noCuenta'         	:$('#cuentaAhoIDGL').val(),
					'grupo'         	:$('#grupoDesGL').val(),
		            'ciclo'           	:$('#cicloIDGL').val(),
					'noCredito'         :$('#referenciaGL').val(),
					'montDep'           :$('#montoGarantiaLiq').val(),
		            'montRec'           :$('#sumTotalSal').val(),
					'cambio'            :$('#sumTotalEnt').val(),
		            'moneda'            :monedaBase,
		            'formaPago'			:formaPago
				};			     
				imprimeTicketReversaGarantiaLiq(ticketReversaGarantiaLiqBean);					
			break;

			case catTipoTransaccionVen.cobroSeguroVida: 
			   var  impresionCobroSeguroBean = {
					'folio'				:$('#numeroTransaccion,').val(),
					'clienteID' 		:$('#clienteIDSC').val(),
					'nombreCliente'		:$('#nombreClienteSC').val(),
					'efectivo'			:$('#montoSeguroCobro').val(),
					'tituloOperacion'	:'REVERSA COBRO COBERTURA DE RIESGO',	
				};	
				impTicketReversaCobroSeguroVida(impresionCobroSeguroBean);			      
			break;
			
			case catTipoTransaccionVen.desembolsoCredito: 								
				var impresionDesemCreditoBean={
				    'folio' 	        :$('#numeroTransaccion').val(),
					'tituloOperacion'	:'REVERSA DESEMBOLSO DE CREDITO',
				    'clienteID' 		:$('#clienteIDDC').val(),
				    'nombreCliente'     :$('#nombreClienteDC').val(),
			        'noCuenta'          :$('#cuentaAhoIDDC').val(),
			        'tipoCuenta'        :$('#nomCuentaDC').val(),
				    'credito'        	:$('#creditoIDDC').val(),
			        'moneda'            :monedaBase,
				    'grupo'             :$('#grupoDesDC').val(),
			        'montoCred'         :$('#montoCreDC').val(),
			        'monRecAnt'  		:$('#totalDesembolsoDC').val(),			 
			        'montRet'        	:$('#totalRetirarDC').val(),			  
			        'ciclo'          	:$('#cicloIDDC').val(),		
				};
			    imprimeTicketReversaDesemCredito(impresionDesemCreditoBean);			
			break;

			case catTipoTransaccionVen.comisionApertura: 
				var comXaperturaBean={
				 	'folio' 	        :$('#numeroTransaccion').val(),
					'tituloOperacion'	:'REVERSA COMISION POR APERTURA',
				    'clienteID' 		:$('#clienteIDAR').val(),
				    'nombreCliente'     :$('#nombreClienteAR').val(),
			        'noCuenta'          :$('#cuentaAhoIDAR').val(),				        
			        'tipoCuenta'        :$('#nomCuentaAR').val(),
				    'credito'        	:$('#creditoIDAR').val(),
				    'prodCredito'		:$('#desProdCreditoAR').val(),
				    
				    'monto'				:$('#totalDepAR').val(),
				    'montoRecibido'		:$('#sumTotalSal').val(),
				    'cambio'			:$('#sumTotalEnt').val(),					    
			        'moneda'            :monedaBase,
			        'grupo'		        :$('#grupoDesAR').val(),
			        'iva'				:$('#ivaAR').val(),
				    'comision'			:$('#comisionAR').val(),
				};
				imprimeTicketReversaComXapertura(comXaperturaBean);
			break;		
		}// switch
	}// funcion
	
function consultaOpcionesCaja() {
	var opcionesCaja = {
			'tipoCaja'	:tipoCajaSesion,
	};
	
	dwr.util.removeAllOptions('tipoOperacion'); 
	dwr.util.addOptions('tipoOperacion', {'0':'SELECCIONAR'});
	if(numeroCaja != '' && !isNaN(numeroCaja)){
		opcionesPorCajaServicio.listaCombo(2,opcionesCaja, function(opciones){
			if(opciones != null){								
		  		dwr.util.removeAllOptions('tipoOperacion'); 
		  		dwr.util.addOptions('tipoOperacion', {'0':'SELECCIONAR'});	  			  		
				dwr.util.addOptions('tipoOperacion', opciones, 'opcionCajaID', 'descripcion');  
			}else{
				dwr.util.removeAllOptions('tipoOperacion');
				dwr.util.addOptions('tipoOperacion', 'NO TIENE OPCIONES');
				deshabilitaBoton('graba', 'submit');
			}
		});
	}
}


});//cerrar


//funcion para validar cuando un campo de un grid toma el foco
function validaFocoInputMoneda(controlID){
	jqID = eval("'#" + controlID + "'");
	if($(jqID).asNumber()>0){
		$(jqID).select();
	}else{
		$(jqID).val("");
	}
}