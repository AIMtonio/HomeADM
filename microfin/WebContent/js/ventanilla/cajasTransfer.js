$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();
	var selectSucursal = null;
	var mil = parseFloat(1000);
	var quinientos = parseFloat(500);
	var doscientos = parseFloat(200);
	var cien = parseFloat(100);
	var cincuenta = parseFloat(50);
	var veinte = parseFloat(20);
	var monedaValor = parseFloat(1);
	var cont = 0;
	var descripcion = "";
	var sucursalSesionVar = 0; 
	var catTipoListaMoneda = {
			'principal': 3
	};
	var catTipoListaSucursal = {
		'combo': 2
	};
	var catTipoTransCajas = {
		'alta': 1
	};
	inicializaParametros();
	

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$(':text').focus(function() {	
	 	esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#sucursalDestino').change(function (){
		if(selectSucursal != null){
			$('#sucursalDestino').val(selectSucursal);
		}
	});
	
	$('#sucursalDestino').blur(function (){
		if(selectSucursal != null){
			$('#sucursalDestino').val(selectSucursal);
		}
	});
	$.validator.setDefaults({
	      submitHandler: function(event) {
	    	  if (cont == 0){
	    		mensajeSis('No Existen Salidas de Efectivo');
	    	  }else{
	    		  deshabilitaBoton('transferir','submit');
	    		  grabaFormaTransaccionCajas(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','cajaDestino','funcionExito','funcionError');
	    	  }
	      }
	});
	
	function grabaFormaTransaccionCajas(event, idForma, idDivContenedor, idDivMensaje,
			 inicializaforma, idCampoOrigen,funcionPostEjecucionExitosa,
				funcionPostEjecucionFallo) {
			consultaSesion();
			var jqForma = eval("'#" + idForma + "'");
			var jqContenedor = eval("'#" + idDivContenedor + "'");
			var jqMensaje = eval("'#" + idDivMensaje + "'");
			var url = $(jqForma).attr('action');
			var resultadoTransaccion = 0;	
			
			quitaFormatoControles(idForma);
			//No descomentar la siguiente linea
			//event.preventDefault();
			$(jqMensaje).html('<img src="images/barras.jpg" alt=""/>');   
			$(jqContenedor).block({
			message: $(jqMensaje),
			css: {border:		'none',
			background:	'none'}
			});
			// Envio de la forma
			
			$.post( url, serializaForma(idForma), function( data ) {
			if(data.length >0) {
			$(jqMensaje).html(data);
			var exitoTransaccion = $('#numeroMensaje').val();
			resultadoTransaccion = exitoTransaccion; 
			if (exitoTransaccion == 0){
				//inicializaForma(idForma, idCampoOrigen);
				$('#cuerpoMsg').val("Transferencia Realizada Exitosamente.");
				consultaDisponibleDenominacion();
				habilitaBoton('generar','submit');
				deshabilitaBoton('transferir','submit');
				generaReporte( $('#consecutivo').val());
				
				 var parametroBean = consultaParametrosSession();
					$('#saldoMNSesionLabel').text(parametroBean.saldoEfecMN);
					$('#saldoMNSesionLabel').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});		
			}
			var campo = eval("'#" + idCampoOrigen + "'");
				if($('#consecutivo').val() != 0){
				$(campo).val($('#consecutivo').val());
				}		
				//Ejecucion de las Funciones de CallBack(RetroLlamada)
				if (exitoTransaccion == 0 && funcionPostEjecucionExitosa != '' ){
					esTab=true;
					eval( funcionPostEjecucionExitosa + '();' );
				}else{
					eval( funcionPostEjecucionFallo + '();' );
				}
				//TODO la de fallo
			}
		});
		return resultadoTransaccion;
	}
	
	var hora = hora();
	$('#fechaSistemaP').val(parametros.fechaAplicacion + ' ' +hora);
	$('#sucursal').val(parametros.nombreSucursal);
	$('#sucursalOrigen').val(parametros.sucursal);
	sucursalSesionVar = parametros.sucursal;
	$('#cajaOrigen').val(parametros.cajaID);
	if (parametros.tipoCaja == 'CA'){
		descripcion = 'CAJA DE ATENCION AL PUBLICO';
	}else if (parametros.tipoCaja == 'CP'){
		descripcion = 'CAJA PRINCIPAL DE SUCURSAL';
	}else if (parametros.tipoCaja == 'BG'){
		descripcion = 'BOVEDA CENTRAL';
	}
	$('#desCaja').val(descripcion);
	$('#fecha').val(parametros.fechaSucursal);
	$('#monedaID').val(1);
	if($('#cajaOrigen').val() != '' && !isNaN($('#cajaOrigen').val())) {
		var conPrincipal = 3;
		var numCaja = $('#cajaOrigen').val();
		var CajasBeanCon = {
			'cajaID' : numCaja,
			'sucursalID' : parametros.sucursal
		};
		cajasVentanillaServicio.consulta(conPrincipal, CajasBeanCon ,function(cajasVentanilla){
			if(cajasVentanilla != null){
				$('#descripCajaOrigen').val(cajasVentanilla.descripcionCaja);	
			}
		});
	}
	
	$('#transferir').click(function(){
		quitaFormatoControles('formaGenerica');
		$('#tipoTransaccion').val(catTipoTransCajas.alta);
		var elementos = document.getElementsByName("cantSalida");
		for(var i=0; i < elementos.length; i++) {
			if (elementos[i].value != 0){
				cont++;
			}
		}
	});
		
	$('#cajaDestino').blur(function() {
		var cajaOrigen = $('#cajaOrigen').asNumber();
		if (this.value == cajaOrigen){
			mensajeSis("Debe seleccionar una caja diferente a la de Origen");
			$('#cajaDestino').focus();
			$('#cajaDestino').val('');
		}else{
			consultaCaja(this.id);
		}
	});
	
	$('#cajaDestino').bind('keyup',function(e) {
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "cajaID";
			camposLista[1] = "tipoCaja";
			camposLista[2] = "sucursalID";
			camposLista[3] = "sucursalOrigen";
			camposLista[4] = "cajaIDOrigen";
			parametrosLista[0] = $('#cajaDestino').val();
			parametrosLista[1] = $('#tipoCajaSesion').val();
			parametrosLista[2] = $('#sucursalDestino').val();
			parametrosLista[3] = parametros.sucursal;
			parametrosLista[4] = parametros.cajaID;
			
			lista('cajaDestino', '1', '5', camposLista, parametrosLista, 'listaCajaVentanilla.htm');
		}
	});
	
	$('#cantSalMil').blur(function() {
		if($('#cantSalMil').asNumber()>0 && $('#cantSalMil').asNumber()> $('#disponSalMil').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalMil').focus();
			$('#cantSalMil').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalMil').asNumber()<=0){
				$('#cantSalMil').val("0");
			}
			cantidadPorDenominacionMilS(this.id);
		}	
		//totalEntradasSalidasDiferencia();	
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
			cantidadPorDenominacionQuiS(this.id);
		}				
		//totalEntradasSalidasDiferencia();
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
			cantidadPorDenominacionDosS(this.id);
		}
		//totalEntradasSalidasDiferencia();
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
			cantidadPorDenominacionCienS(this.id);
		}
		//totalEntradasSalidasDiferencia();
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
			cantidadPorDenominacionCinS(this.id);
		}
		//totalEntradasSalidasDiferencia();
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
			cantidadPorDenominacionVeiS(this.id);
		}
		//totalEntradasSalidasDiferencia();
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
			cantidadPorDenominacionMonS(this.id);
		}
		//totalEntradasSalidasDiferencia();
	});
	
	
	
	$('#sucursalDestino').change(function() {
		if (parametros.tipoCaja == 'CA'){ 
			parametros = consultaParametrosSession();
			$('#sucursalDestino').val(parametros.sucursal);
			soloLecturaControl("sucursalDestino");
		}
	});
	
	$('#formaGenerica').validate({
		rules: {
			
			cajaDestino: {
				required: true
			},
			referencia :{
				required: true,
				maxlength: 150
			}
		},
		
		messages: {

			cajaDestino: {
				required: 'Especificar Caja Destino'
			},
			referencia :{
				required: 'Especificar Referencia',
				maxlength: 'Máximo 50 caracteres.'
			}
		}		
	});

	
	
 	function cargaSucursales(jqCtrl){
		dwr.util.removeAllOptions(jqCtrl);
		sucursalesServicio.listaCombo(catTipoListaSucursal.combo, function(sucursales){
			dwr.util.addOptions(jqCtrl, sucursales, 'sucursalID', 'nombreSucurs');
			$('#sucursalDestino').val($('#sucursalIDSesion').val());
			cargaMonedas();

		});
 	}
 	
 	function cargaMonedas(){
		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions( 'monedaID', {'0':'Todas'});
		monedasServicio.listaCombo(catTipoListaMoneda.principal, function(monedas){
			for (var i = 0; i < monedas.length; i++){
				$('#monedaID').append(new Option(monedas[i].descripcion, parseInt(monedas[i].monedaID), false, false));
			}
			$('#monedaID').val(1);
		});
	}
 	
	function consultaCaja(idControl){//pregunta tambien la accesibilidad extructural
		var jqCajaVentanilla = eval("'#" + idControl + "'");
		var numCajaID = $(jqCajaVentanilla).val();
		var conPrincipal = 1;		// es una consulta Con_CajasTransfer 
		var CajasVentanillaBeanCon = {
  			'cajaID': numCajaID
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCajaID != '' && !isNaN(numCajaID)){
			cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanCon ,function(cajasVentanilla){
				if(cajasVentanilla != null){
					conPrincipal = 6;
					CajasVentanillaBeanCon = {
				  		'cajaID': cajasVentanilla.cajaID,
				  		'sucursalID': parametros.sucursal, 
				  		'tipoCaja' : parametros.tipoCaja
					};
					
					cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanCon ,function(tipoCajas){
						if(tipoCajas != null){
							if (tipoCajas.estatus == 'A'){
								if(tipoCajas.estatusOpera == 'A'){
									
									if ( parametros.tipoCaja == 'CA'  ) {
										if(tipoCajas.tipoCaja == 'CAJA DE ATENCION AL PUBLICO'){
											if(tipoCajas.sucursalID == parametros.sucursal){
												$('#des'+idControl).val(tipoCajas.tipoCaja);
												$('#descripCajaDestino').val(tipoCajas.descripcionCaja);
												//habilitaBoton('transferir','submit');
												if (idControl == 'cajaDestino'){
													$('#sucursalDestino').val(tipoCajas.sucursalID);
												}	
											}
											else{
												mensajeSis("Caja Destino No Elegible Desde Caja Origen");
												$('#cajaDestino').focus();
												$('#cajaDestino').val("");
												$('#des'+idControl).val("");
												deshabilitaBoton('transferir','submit');
											}
										}else if(tipoCajas.tipoCaja == 'CAJA PRINCIPAL DE SUCURSAL'){
											if(tipoCajas.sucursalID == parametros.sucursal){
												$('#des'+idControl).val(tipoCajas.tipoCaja);
												$('#descripCajaDestino').val(tipoCajas.descripcionCaja);
												//habilitaBoton('transferir','submit');
												if (idControl == 'cajaDestino'){
													$('#sucursalDestino').val(tipoCajas.sucursalID);
												}		
											}
											else{
												mensajeSis("Caja Destino No Elegible Desde Caja Origen");
												$('#cajaDestino').focus();
												$('#des'+idControl).val("");
												deshabilitaBoton('transferir','submit');
											}
										}else{
											mensajeSis("Caja Destino No Elegible Desde Caja Origen");
											$('#cajaDestino').focus();
											$('#des'+idControl).val("");	
											deshabilitaBoton('transferir','submit');
										}
									}
									if( parametros.tipoCaja == 'CP' ){

										if(tipoCajas.tipoCaja == 'CAJA DE ATENCION AL PUBLICO'){
											if(tipoCajas.sucursalID == parametros.sucursal){
												$('#des'+idControl).val(tipoCajas.tipoCaja);
												$('#descripCajaDestino').val(tipoCajas.descripcionCaja);
												//habilitaBoton('transferir','submit');
												if (idControl == 'cajaDestino'){
													$('#sucursalDestino').val(tipoCajas.sucursalID);
												}		
											}
											else{
												mensajeSis("Caja Destino No Elegible Desde Caja Origen");
												$('#cajaDestino').focus();
												$('#des'+idControl).val("");
												deshabilitaBoton('transferir','submit');
											}
										}else if(tipoCajas.tipoCaja == 'CAJA PRINCIPAL DE SUCURSAL'){
											if(tipoCajas.sucursalID != parametros.sucursal){
												$('#des'+idControl).val(tipoCajas.tipoCaja);
												$('#descripCajaDestino').val(tipoCajas.descripcionCaja);
												//habilitaBoton('transferir','submit');
												if (idControl == 'cajaDestino'){
													$('#sucursalDestino').val(tipoCajas.sucursalID);
												}		
											}
											else{
												mensajeSis("Caja Destino No Elegible Desde Caja Origen");
												$('#cajaDestino').focus();
												$('#des'+idControl).val("");
												deshabilitaBoton('transferir','submit');
											}
										}else if(tipoCajas.tipoCaja == 'BOVEDA CENTRAL'){
											$('#des'+idControl).val(tipoCajas.tipoCaja);
											$('#descripCajaDestino').val(tipoCajas.descripcionCaja);
											//habilitaBoton('transferir','submit');
											if (idControl == 'cajaDestino'){
												$('#sucursalDestino').val(tipoCajas.sucursalID);
											}		
										}else{
											mensajeSis("Caja Destino No Elegible Desde Caja Origen");
											$('#cajaDestino').focus();
											$('#des'+idControl).val("");
											deshabilitaBoton('transferir','submit');
										}
									}
									if( parametros.tipoCaja == 'BG'){
											$('#des'+idControl).val(tipoCajas.tipoCaja);
											$('#descripCajaDestino').val(tipoCajas.descripcionCaja);
											//habilitaBoton('transferir','submit');
											if (idControl == 'cajaDestino'){
												$('#sucursalDestino').val(tipoCajas.sucursalID);
											}	
									}
									
								}else{
									mensajeSis('Caja Destino No Aperturada');
									$('#cajaDestino').focus();
									$('#cajaDestino').val('');
									$('#des'+idControl).val("");
									$('#descripCajaDestino').val('');
									deshabilitaBoton('transferir','submit');
								}
								
							}else{
								mensajeSis('Caja Destino No Activa');
								$('#cajaDestino').focus();
								$('#cajaDestino').val('');
								$('#des'+idControl).val("");
								$('#descripCajaDestino').val("");
								inicializarEntradasSalidasEfectivo();
								deshabilitaBoton('transferir','submit');
							}
						}else{
							mensajeSis('La Caja no Corresponde a la Sucursal.');
							$('#cajaDestino').focus();
							$('#cajaDestino').val('');
							$('#des'+idControl).val("");	
							$('#descripCajaDestino').val("");
							inicializarEntradasSalidasEfectivo();
							
							deshabilitaBoton('transferir','submit');
						}
					});
				}
				else{
					mensajeSis("La Caja No Existe.");
					$('#cajaDestino').focus();
					$('#cajaID').val("");
					$('#des'+idControl).val("");
					$('#descripCajaDestino').val("");
					deshabilitaBoton('transferir','submit');
				}
			});
		}
	}
 	
	function cantidadPorDenominacionMil(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraMil').val(parseFloat(cantidad)*parseFloat(mil));	 
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();//ok
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
		}
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
				$(jqMontoSalida).val(0.00);
				$(jqMontoSalida).formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});
			}
		});
		if(suma > 0){
			habilitaBoton('transferir','submit');
		}else{
			deshabilitaBoton('transferir','submit');
		}
		$('#cantidad').val(suma);
		$('#cantidad').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
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
	 
	function hora(){	
		 var Digital=new Date();
		 var hours=Digital.getHours();
		 var minutes=Digital.getMinutes();
		 var seconds=Digital.getSeconds();
		 if (minutes<=9)
		 minutes="0"+minutes;
		 if (seconds<=9)
		 seconds="0"+seconds;
		return  hours+":"+minutes;
	 }
	function generaReporte(numTransaccion){
		quitaFormatoControles('formaGenerica');
		var tipoReporte		= 1;
		$('#ligaPDF').attr('href','RepTicketCajasTransfer.htm?fechaSistemaP='+$('#fechaSistemaP').val()+
			'&nombreInstitucion='+parametros.nombreInstitucion+
			'&numeroSucursal='+parametros.sucursal+
			'&nombreSucursal='+parametros.nombreSucursal+
			'&varCaja='+parametros.cajaID+
			'&nomCajero='+parametros.nombreUsuario+
			'&numCopias=2&numTrans='+numTransaccion+
			'&monedaID=PESOS'+
			'&numSucDestino='+$('#sucursalDestino').val()+
			'&nomSucDestino='+$("#sucursalDestino option:selected").html()+
			'&cajaDestino='+$('#cajaDestino').val()+
			'&folioID='+numTransaccion+
			'&referencia='+$('#referencia').val()+
			'&tipoCaja='+$('#desCaja').val()+
			'&tipoReporte='+tipoReporte);
			$('#generar').click();
	}
	function inicializaParametros(){
		deshabilitaItems();
		agregaFormatoControles('formaGenerica');
		var parametros = consultaParametrosSession();
		if (parametros.tipoCaja == '' || parametros.tipoCaja == undefined){
			mensajeSis('El Usuario no tiene una Caja asignada.');

		}else{
			if (parametros.tipoCaja == 'CA'){
				selectSucursal = parametros.sucursal;
				cargaSucursales('sucursalDestino');
				consultaDisponibleDenominacion();	
				estaAbiertaCaja($('#sucursalIDSesion').val(),$('#cajaIDSesion').val(),parametros.tipoCaja);
			}else if (parametros.tipoCaja == 'CP' || parametros.tipoCaja == 'BG'){
				cargaSucursales('sucursalDestino');
				consultaDisponibleDenominacion();
				estaAbiertaCaja($('#sucursalIDSesion').val(),$('#cajaIDSesion').val(),parametros.tipoCaja);
			}
			else{
				mensajeSis('La caja No esta definida');
				
			}
		}
		$('#cajaDestino').focus();
	}
//	Consulta si la caja esta Actual esta abierta y si es CA cual es su el ID de su CP
	 function estaAbiertaCaja(sucursalID,cajaID,tipoCaja){
		 var CajasVentanillaBeanConCajSuc = {
		  			'cajaID': cajaID
				};
		 var conPrincipal = 3;
			cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanConCajSuc ,function(cajasVentanillaConCaja){
				if(cajasVentanillaConCaja != null)
				{
				if(cajasVentanillaConCaja.sucursalID != sucursalID){
					mensajeSis('No puede realizar esta operacion ya que la sucursal del cajero no concuerda con la sucursal asignada a la caja.');
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
								mensajeSis('La caja se encuentra Cerrada. Apertura la Caja para Realizar Operaciones.');
							}else{
								habilitaItems();
							}	
						}
					});
				
				}
			}
				$('#cajaDestino').focus();
		});
	 }

	 function deshabilitaItems(){
		$('#sucursalDestino').attr('disabled','true');
		$('#cajaDestino').attr('disabled','true');
		$('#referencia').attr('disabled','true');
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
		$('#cajaDestino').focus();
		deshabilitaBoton('transferir','submit');
	 }
	 function habilitaItems(){
		$('#sucursalDestino').removeAttr('disabled');
		$('#cajaDestino').removeAttr('disabled');
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
		$('#cajaDestino').focus();
		//habilitaBoton('transferir','submit');
	 }
	 function inicializarEntradasSalidasEfectivo() {
		$('#cantSalMil').val(0);
		$('#cantSalQui').val(0);
		$('#cantSalDos').val(0);
		$('#cantSalCien').val(0);
		$('#cantSalCin').val(0);
		$('#cantSalVei').val(0);
		$('#cantSalMon').val(0);

		$('#montoSalMil').val(0.00);
		$('#montoSalQui').val(0.00);
		$('#montoSalDos').val(0.00);
		$('#montoSalCien').val(0.00);
		$('#montoSalCin').val(0.00);
		$('#montoSalVei').val(0.00);
		$('#montoSalMon').val(0.00);
		
		$('#cantidad').val(0);
		$('#billetesMonedasSalida').val("");
	 }	
});


function funcionExito(){
	inicializaEntradaSalidaEfectivo();
	$('#cajaDestino').val('');
	$('#descajaDestino').val('');
	$('#descripCajaDestino').val('');
	$('#referencia').val('');
	$('#cajaDestino').focus();
	//habilitaBoton('transferir','submit');
}

function funcionError(){
	inicializaEntradaSalidaEfectivo();
	$('#cajaDestino').val('');
	$('#descajaDestino').val('');
	$('#descripCajaDestino').val('');
	$('#referencia').val('');
	//habilitaBoton('transferir','submit');
}


function inicializaEntradaSalidaEfectivo() {
	$('#cantSalMil').val(0);
	$('#cantSalQui').val(0);
	$('#cantSalDos').val(0);
	$('#cantSalCien').val(0);
	$('#cantSalCin').val(0);
	$('#cantSalVei').val(0);
	$('#cantSalMon').val(0);
	$('#montoSalMil').val(0.00);
	$('#montoSalQui').val(0.00);
	$('#montoSalDos').val(0.00);
	$('#montoSalCien').val(0.00);
	$('#montoSalCin').val(0.00);
	$('#montoSalVei').val(0.00);
	$('#montoSalMon').val(0.00);
	$('#cantidad').val(0);
	$('#billetesMonedasSalida').val("");
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