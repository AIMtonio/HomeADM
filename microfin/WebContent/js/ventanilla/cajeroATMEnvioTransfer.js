var cont = 0;
var Poliza=0;
var Transaccion=0;
$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();
	var mil = parseFloat(1000);
	var quinientos = parseFloat(500);
	var doscientos = parseFloat(200);
	var cien = parseFloat(100);
	var cincuenta = parseFloat(50);
	var veinte = parseFloat(20);
	var monedaValor = parseFloat(1);
	consultaSaldosCaja();

	consultaUsuario(parametros.gerenteSucursal,'gerenteSucursal');
	
	var catTipoTransTransfer = {
			'envioTransfer' : 1
	};	
	var catTipoListaMoneda = {
			'principal': 3
	};
	var EstatusInactivo	= 'I';
	var EstatusActivo	='A';
	var EstatusCajero	='';
	inicializaParametros();
	consultaParametrosSesion();
	$('#impPoliza').hide();	
	$('#cajeroDestinoID').focus();
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$(':text').focus(function() {	
	 	esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	deshabilitaBoton('enviar', 'submit');
	$.validator.setDefaults({
	      submitHandler: function(event) {
	   		  if ($('#cantidad').asNumber() == 0){
	    		mensajeSis('Especificar Salidas de Efectivo.');
	    	  }else{
	    		  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','polizaID',
	    				  'exitoEnvioEfectivoCajero','falloEnvioEfectivoCAjero');
	    	  }
	      }
	});
	
	

	$('#cajeroDestinoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();	
		
		camposLista[0] = "cajeroID";
		camposLista[1] = "nombreCompleto";		  
		parametrosLista[0] = 0;
		parametrosLista[1] = $('#cajeroDestinoID').val();		  
		lista('cajeroDestinoID', '1', '2', camposLista,parametrosLista, 'listaCajerosATM.htm');	       
	});		
	$('#cajeroDestinoID').blur(function() {   	
  		consultaCajeroATM(this.id);  		  		
   	});

  	$('#referencia').blur(function() {   	
  		$('#cantSalMil').focus();  		
   	});
  	
  	$('#enviar').click(function(){
		quitaFormatoControles('formaGenerica');
		$('#tipoTransaccion').val(catTipoTransTransfer.envioTransfer);
		var elementos = document.getElementsByName("cantSalida");  //???
		for(var i=0; i < elementos.length; i++) {
			if (elementos[i].value != 0){
				cont++;
			}
		}
	});

  	$('#impPoliza').click(function(){
		var fecha = parametros.fechaSucursal;	
		window.open('RepPoliza.htm?polizaID='+Poliza+'&fechaInicial='+fecha+
				'&fechaFinal='+fecha+'&nombreUsuario='+parametroBean.nombreUsuario);

	});	
  	$('#comprobante').click(function(){
		window.open('ticketTransfATM.htm?nombreInstitucion='+parametroBean.nombreInstitucion+'&sucursal='+parametroBean.nombreSucursal+
				'&numeroSucursal='+parametroBean.sucursal+'&usuarioID='+parametroBean.numeroUsuario+'&nombreUsuario='+parametroBean.nombreUsuario
				+'&monto='+ $('#cantidad').asNumber()+'&cajeroID='+ $('#cajeroDestinoID').val()
				+'&fechaSucursal='+ parametroBean.fechaSucursal+ '&simboloMonedaBase='+ parametroBean.simboloMonedaBase+
				'&descripcionMoneda='+ parametroBean.desCortaMonedaBase+'&numeroMonedaBase='+ parametroBean.numeroMonedaBase+
				'&referencia='+ $('#referencia').val()+'&nombreMoneda='+ parametroBean.nombreMonedaBase+'&numeroCaja='+ parametroBean.cajaID
				+'&numeroTransaccion='+ Transaccion+'&gerenteSucursal='+ $('#gerenteSucursal').val()+'&ubicacion='+ $('#ubicacion').val()
				+'&usuarioIDATM='+ $('#usuarioID').val()+'&nombreUsuarioATM='+ $('#nombreUsuario').val()
				+'&sucursalATM='+ $('#sucursalCajero').val()+'&desSucursalATM='+ $('#desSucursal').val());
	});
  	

  	
	
	// Entrada de efectivo ------------------------------------

	$('#cantSalMil').blur(function() {
		if($('#cantSalMil').asNumber()>0 && $('#cantSalMil').asNumber()> $('#disponSalMil').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalMil').focus();
			$('#cantSalMil').select();
			$('#cantSalMil').val("0");
			deshabilitaBoton('enviar', 'submit');
		}else{
			if($('#cantSalMil').asNumber()<= 0){
				$('#cantSalMil').val("0");
			}
			cantidadPorDenominacion(this.id,'montoSalMil',mil);
		}	
	});
	$('#cantSalQui').blur(function() {
		if($('#cantSalQui').asNumber()>0 && $('#cantSalQui').asNumber()> $('#disponSalQui').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalQui').focus();
			$('#cantSalQui').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalQui').asNumber()<=0){
				$('#cantSalQui').val("0");
			}
			cantidadPorDenominacion(this.id,'montoSalQui',quinientos);
		}				

	});
	$('#cantSalDos').blur(function() {
		if($('#cantSalDos').asNumber()>0 && $('#cantSalDos').asNumber()> $('#disponSalDos').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalDos').focus();
			$('#cantSalDos').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalDos').asNumber()<=0){
				$('#cantSalDos').val("0");
			}
			cantidadPorDenominacion(this.id,'montoSalDos',doscientos);
		}

	});
	$('#cantSalCien').blur(function() {
		if($('#cantSalCien').asNumber()>0 && $('#cantSalCien').asNumber()> $('#disponSalCien').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalCien').focus();
			$('#cantSalCien').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalCien').asNumber()<=0){
				$('#cantSalCien').val("0");
			}
			cantidadPorDenominacion(this.id,'montoSalCien',cien);
		}		
	});
	$('#cantSalCin').blur(function() {
		if($('#cantSalCin').asNumber()>0 && $('#cantSalCin').asNumber()> $('#disponSalCin').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalCin').focus();
			$('#cantSalCin').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalCin').asNumber()<=0){
				$('#cantSalCin').val("0");
			}
			cantidadPorDenominacion(this.id,'montoSalCin',cincuenta);
		}
		
	});
	$('#cantSalVei').blur(function() {
		if($('#cantSalVei').asNumber()>0 && $('#cantSalVei').asNumber()> $('#disponSalVei').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalVei').focus();
			$('#cantSalVei').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalVei').asNumber()<=0){
				$('#cantSalVei').val("0");
			}
			cantidadPorDenominacion(this.id,'montoSalVei',veinte);
		}
	});
	
	$('#cantSalMon').blur(function() {
		if($('#cantSalMon').asNumber()>0 && $('#cantSalMon').asNumber()> $('#disponSalMon').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalMon').focus();
			$('#cantSalMon').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalMon').asNumber()<=0){
				$('#cantSalMon').val("0");
			}
			cantidadPorDenominacion(this.id,'montoSalMon',monedaValor);
		}

	});
	//Fin entrada de efectivo-------------------------------------------------------------	
	
//-----------------Validacion de la Forma--------------
	$('#formaGenerica').validate({
		rules: {
			
			cantidad : {
				required: true
			},
			referencia : {
				required: true
				,
				maxlength : 50
			},
			cajeroOrigenID : {
				required: true,
			},
			usuarioID : {
				required: true
			}
			
			
		},
		
		messages: {
			
			cantidad : {
				required: 'Especifique Cantidad a Transferir'
			},
			referencia : {
				required: 'Especifique la Referencia'
					,
				maxlength: 'Maximo de 50 caracteres.'
			},
			cajeroOrigenID : {
				required: 'Caja Origen requerido',
			},
			usuarioID : {
				required: 'Usurio Origen requerido',
			}
		}
	});
//---------------------funciones-------------------
	
	function consultaCajeroATM(control) {			
		var jqCajeroDestino  = eval("'#" +control + "'");
		var cajero = $(jqCajeroDestino).val();	
		limpiaFormEnvioTransferATM();
										
		var catCajerosBean = { 
				'cajeroID':cajero	  				
		};						
		 if(cajero != '' && esTab == true){
			catCajerosATMServicio.consulta(1,catCajerosBean,function(cajeroATM) {
				if(cajeroATM != null){
					dwr.util.setValues(cajeroATM);
					$('#ubicacion').val(cajeroATM.ubicacion);
					$('#sucursalCajero').val(cajeroATM.sucursalID);	
					consultaUsuario(cajeroATM.usuarioID,'nombreUsuario');
					consultaSucursal('sucursalCajero', 'desSucursal');
					consultaParametrosSesion();
					
					EstatusCajero	=cajeroATM.estatus;
					$('#impPoliza').hide();
					$('#comprobante').hide();
					$('#polizaID').val('');
					if(cajeroATM.estatus == EstatusInactivo){						
						mensajeSis("El Cajero se encuentra Inactivo");
					}else{
						$('#monedaID').focus();
					}
				}else{								
					mensajeSis("El Cajero no existe");
					deshabilitaBoton('enviar', 'submit');				
					inicializaForma('formaGenerica','cajeroDestinoID' );		
				}
			});
		 }
	}
	
	function consultaSucursal(idControl, descSucursal) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();	
		var conSucursal=1;
		setTimeout("$('#cajaLista').hide();", 200);		 
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
				if(sucursal!=null){							
					$('#'+descSucursal).val(sucursal.nombreSucurs);
				}else{
					mensajeSis("No Existe la Sucursal"); 
					$(jqSucursal).val("");
					$(jqSucursal).focus();
					$('#'+descSucursal).val("");
				}    						
			});
		}
	}	
	
	function consultaUsuario(usuarioID, nombreUsuario){
		var conForanea = 2;
		var usuarioBean = {
			'usuarioID' : usuarioID
		};
		if(usuarioID != '' && !isNaN(usuarioID)){
			usuarioServicio.consulta(conForanea, usuarioBean, function(usuario){
				if (usuario != null){					
					$('#'+nombreUsuario).val(usuario.nombreCompleto);					
				}else{
					mensajeSis('No Existe el Usuario');					
					$('#'+nombreUsuario).val('');					
				}
			});
		}
	}
  	function cargaMonedas(){
		monedasServicio.listaCombo(catTipoListaMoneda.principal, function(monedas){
			dwr.util.removeAllOptions('monedaID');
			for (var i = 0; i < monedas.length; i++){
				$('#monedaID').append(new Option(monedas[i].descripcion, parseInt(monedas[i].monedaID), false, false));
			}
			$('#monedaID').val(1);
		});
	}

	// Para la multiplicacion de las cantidades por la denominacion
	function cantidadPorDenominacion(idControl, idMonto, denominacion) {
		var jqCant  = eval("'#" + idControl + "'");
		var jqCajitaMonto = eval("'#" + idMonto + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$(jqCajitaMonto).val(parseFloat(cantidad)*parseFloat(denominacion));
			sumaTotalSalidasEfectivo();
			crearListaBilletesMonedasSalida();
		}
	}
	
	//para llevar el total de las Salidas de efectivo
	function sumaTotalSalidasEfectivo() { 
		esTab= true;
		setTimeout("$('#cajaLista').hide();", 200);
		var suma = parseFloat(0);
		$('input[name=montoSalida]').each(function() {
			var jqMontoSalida= eval("'#" + this.id + "'");
			var montoSalida= $(jqMontoSalida).asNumber(); 
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
		
		$('#cantidad').val(suma);
		if ($('#cantidad').asNumber() > 0  && $('#cajeroDestinoID').val() != '' && EstatusCajero == EstatusActivo ){
			habilitaBoton('enviar', 'submit');
			
		}else {
			deshabilitaBoton('enviar', 'submit');
		}
		$('#impPoliza').hide();
		$('#comprobante').hide();
		$('#polizaID').val('');			
		$('#cantidad').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});		
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
	
	
	 function inicializaParametros(){
		deshabilitaItems();
		limpiaForm('formaGenerica');
		agregaFormatoControles('formaGenerica');
		var parametros = consultaParametrosSession();
		if (parametros.tipoCaja == '' || parametros.tipoCaja == undefined){
			mensajeSis('El Usuario no tiene una Caja asignada.');
		}else if (parametros.tipoCaja == 'CA' || parametros.tipoCaja == 'CP' || parametros.tipoCaja == 'BG'){
			estaAbiertaCaja(parametros.sucursal,parametros.cajaID,parametros.tipoCaja);			
		}else{
			mensajeSis('La caja no esta definida correctamente');
		}			
	} 
		
	function estaAbiertaCaja(sucursalID,cajaID,tipoCaja){
		var CajasVentanillaBeanConCajSuc = {
		  			'cajaID': cajaID
				};
		var conPrincipal = 3;
		cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanConCajSuc ,function(cajasVentanillaConCaja){
			if(cajasVentanillaConCaja != null){
				if(cajasVentanillaConCaja.sucursalID != sucursalID){
					mensajeSis('No puede realizar esta operacion ya que la sucursal del cajero no concuerda con la sucursal asignada a la caja.');
					deshabilitaBoton('enviar','submit');
				}else{
					var consultaCajaEO = 7;
					var parametrosBeanVentanilla = {
							'sucursalID':sucursalID,
							'cajaID':cajaID
					};
					//estan es para consultar la propia caja si esta cerrada, no importa si es BG pues nunca esta cerrada
					cajasVentanillaServicio.consulta(consultaCajaEO, parametrosBeanVentanilla , function(cajaVentanilla){
						if(cajaVentanilla != null){
							if(cajaVentanilla.estatusOpera == 'C'){
								deshabilitaItems();
								mensajeSis('La caja se encuentra Cerrada. Apertura la Caja para Realizar Operaciones.');
							}else{
								habilitaItems();
								cargaMonedas();
								consultaDisponibleDenominacion();
							}	
						}
					});
				
				}
			}
			
		});
	 }
	 function deshabilitaItems(){
		 	deshabilitaBoton('enviar','submit');			 	
		 	$('#monedaID').attr('disabled',true);
		 	$('#referencia').attr('disabled',true);
		 	limpiaGridSalida();
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
	 	//habilitaBoton('enviar','submit');			 	
	 	$('#monedaID').removeAttr('disabled');
	 	$('#referencia').removeAttr('disabled');
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
			  
	  function limpiaGridSalida(){
	 		var extencion = '';
	 		for (var i = 1; i < 8; i++){
	 				var diponible = 0;
	 				var monto = parseFloat(0);
	 				var deno=0;
	 				switch(i){
		 				case 1:	deno = 1000;
		 						extencion='Mil';
		 				break;
		 				case 2:	deno = 500;
		 						extencion='Qui';
		 				break;
		 				case 3:	deno = 200;
		 						extencion='Dos';
		 				break;
		 				case 4:	deno = 100;
		 						extencion='Cien';
		 				break;
		 				case 5:	deno = 50;
		 						extencion='Cin';
		 				break;
		 				case 6:deno = 20;
		 				extencion='Vei';
		 				break;
		 				case 7:deno = 1;
		 				extencion='Mon';
		 				break;
	 				}
	 				var jqMonto = eval("'#montoSal" + extencion + "'");
	 				var jqDisponible = eval("'#disponSal" + extencion + "'");
	 				monto = parseFloat(Number(diponible)*deno);
	 				$(jqDisponible).val(diponible);
	 				$(jqMonto).val(monto);
	 		}	
	 		$('#cantidad').val(0);
	 		$('#cantidad').formatCurrency({
	 			positiveFormat: '%n', 
	 			roundToDecimalPlace: 2	
	 		});	
	  }
	
	  function consultaParametrosSesion(){
		  	$('#sucursalID').val(parametros.sucursal);
			$('#descSucursal').val(parametros.nombreSucursal);
			$('#cajeroOrigenID').val(parametros.cajaID);
			$('#descCaja').val(parametros.tipoCajaDes);
			$('#fecha').val(parametros.fechaSucursal);
	  }

		
});




function consultaSaldosCaja(){
	var numConsulta = 2;
	var beanCaja = {
			'cajaID'		: parametros.cajaID
	};
	cajasVentanillaServicio.consulta(numConsulta, beanCaja, function(saldo){
		if (saldo !=null){
			parametroBean = consultaParametrosSession();
			$('#saldoMNSesionLabel').text(parametroBean.saldoEfecMN);
			$('#saldoMNSesionLabel').formatCurrency({
				positiveFormat: '%n', 
				roundToDecimalPlace: 2	
			});			
			
			$('#saldoEfecMNSesion').val(saldo.saldoEfecMN);
			$('#saldoEfecMNSesion').formatCurrency({
				positiveFormat: '%n',
				negativeFormat: '%n',
				roundToDecimalPlace: 2
			});		
		}
	});
}	 

function consultaDisponibleDenominacion() {
	var bean = {
			'sucursalID': parametros.sucursal,
			'cajaID': parametros.cajaID,
			'denominacionID':0,
			'monedaID':1
	};	
	ingresosOperacionesServicio.listaConsulta(1, bean,function(disponDenom){
		for (var i = 0; i < disponDenom.length; i++){
			switch(parseInt(disponDenom[i].denominacionID))
			{
			case 1:$('#disponSalMil').val(parseInt(disponDenom[i].cantidadDenominacion));
			break;
			case 2:$('#disponSalQui').val(parseInt(disponDenom[i].cantidadDenominacion));
			break;
			case 3:$('#disponSalDos').val(parseInt(disponDenom[i].cantidadDenominacion));
			break;
			case 4:$('#disponSalCien').val(parseInt(disponDenom[i].cantidadDenominacion));
			break;
			case 5:$('#disponSalCin').val(parseInt(disponDenom[i].cantidadDenominacion));
			break;
			case 6:$('#disponSalVei').val(parseInt(disponDenom[i].cantidadDenominacion));
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



function exitoEnvioEfectivoCajero() {
	 consultaDisponibleDenominacion();
	 actualizaSaldoCaja();
	 deshabilitaBoton('enviar','submit');
	// limpiaFormEnvioTransferATM();	
	$('#monedaID').val(1);		  	
	$('#impPoliza').show();	
	$('#comprobante').show();
	 cont = 0;
	var arreglo = $('#polizaID').val().split(','); 	
	 Poliza= arreglo[0];
	 Transaccion=arreglo[1];
}

function falloEnvioEfectivoCAjero(){
	$('#impPoliza').hide();
	$('#comprobante').hide();
	
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

function actualizaSaldoCaja(){	
	parametroBean = consultaParametrosSession();
	$('#saldoMNSesionLabel').text(parametroBean.saldoEfecMN);
	$('#saldoMNSesionLabel').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});		
}

function limpiaFormEnvioTransferATM(){
	$('#usuarioID').val('');
	$('#nombreUsuario').val('');
	$('#sucursalCajero').val('');
	$('#desSucursal').val('');
	$('#ubicacion').val('');
	$('#sucursalID').val('');
	$('#descSucursal').val('');
	$('#cajeroOrigenID').val('');
	$('#descCaja').val('');
	//monedaID
	$('#referencia').val('');
	 $("input[name='cantSalida']").val(0.00);
	 $("input[name='montoSalida']").val(0.00);
	 $('#cantidad').val(0);	
	 $('#billetesMonedasEntrada').val('');
	 $('#billetesMonedasSalida').val('');
}

//Función solo Enteros sin Puntos ni Caracteres Especiales
function validaSoloNumero(e,elemento){//Recibe al evento 
	var key;
	if(window.event){//Internet Explorer ,Chromium,Chrome
		key = e.keyCode; 
	}else if(e.which){//Firefox , Opera Netscape
			key = e.which;
	}
	
	 if (key > 31 && (key < 48 || key > 57)) //se valida, si son números los deja 
	    return false;
	 return true;
}