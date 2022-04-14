$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();
	var catTipoTransCajas = {
		'alta': 1,
		'recepcion' :2
	};
	var catTipoListaFolios ={
		'combo' : 1
	};
	var mil = parseFloat(1000);
	var quinientos = parseFloat(500);
	var doscientos = parseFloat(200);
	var cien = parseFloat(100);
	var cincuenta = parseFloat(50);
	var veinte = parseFloat(20);
	var monedaValor = parseFloat(1);
	var cont=0;
	
	
	inicializaParametros();
	$('#foliosRecepcion').focus();

	//------------ Metodos y Manejo de Eventos -----------------------------------------
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
	    	  clicBtnAceptar(event);
	      }
	});
	
	$('#formaGenerica').validate({
		rules: {
			
			cajaDestino: {
				required: true
			},
			cajaOrigen: {
				required: true
			}
		},
		
		messages: {

			cajaDestino: {
				required: 'Especificar Caja Destino'
			},
			cajaOrigen: {
				required: 'Especificar Caja Origen'
			}
		}		
	});
	$('#aceptar').click(function(){
		
		
	});
	
	function clicBtnAceptar(event){
		$('#tipoTransaccion').val(catTipoTransCajas.recepcion);
		$('#sucursalID').val(parametros.sucursal);
		$('#cajaID').val(parametros.cajaID);
		$('#fecha').val(parametros.fechaSucursal);
		$('#monedaID').val(1);
		deshabilitaBoton('aceptar','submit');
		var elementos = document.getElementsByName("cantEntrada");
		for(var i=0; i < elementos.length; i++) {
			if (elementos[i].value != 0){
				cont++;
			}
		}
		if (cont == 0){
			mensajeSis('Seleccione un Folio para Recepción');
		}else{
			grabaFormaTransaccionRecepcion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','foliosRecepcion');
		}
	}
	
function grabaFormaTransaccionRecepcion(event, idForma, idDivContenedor, idDivMensaje,
										 inicializaforma, idCampoOrigen) {
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
				if (exitoTransaccion == 0 && inicializaforma == 'true' ){
					inicializaForma(idForma, idCampoOrigen);
					consultaSaldosCaja();
					cargaFolios('foliosRecepcion');
					deshabilitaBoton('aceptar','submit');
					var elementos = document.getElementsByName("cantEntrada");
					for(var i=0; i < elementos.length; i++) {
						if (elementos[i].value != 0){
							cont++;
						}
					}
					
					
					limpiaCamposDenominaciones();
					 var parametroBean = consultaParametrosSession();
						$('#saldoMNSesionLabel').text(parametroBean.saldoEfecMN);
						$('#saldoMNSesionLabel').formatCurrency({
							positiveFormat: '%n', 
							roundToDecimalPlace: 2	
						});		
				}
				habilitaBoton('aceptar','submit');
				var campo = eval("'#" + idCampoOrigen + "'");
				if($('#consecutivo').val() != 0){
					$(campo).val($('#consecutivo').val());
				}		
			}
	});
	return resultadoTransaccion;
}	
	
	
	
	
	$('#foliosRecepcion').change(function(){
		var elementos = document.getElementsByName("cantEntrada");
		for(var i=0; i < elementos.length; i++) {
			elementos[i].value = 0;
		}
		var monto = document.getElementsByName("montoEntrada");
		for(var i=0; i < monto.length; i++) {
			monto[i].value = 0;
		}
		consultaEntradaDenominacion(this.value);
		$('#cajaOrigenVal').val($('#foliosRecepcion option:selected').text());
	});

	//**** pierden el foco las cantidades de entrada de efectivo
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
	
	function cantidadPorDenominacionMil(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraMil').val(parseFloat(cantidad)*parseFloat(mil));	 
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
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
	//para llevar el total de entradas de efectivo.
	function sumaTotalEntradasEfectivo() { 
		
		esTab= true;
		setTimeout("$('#cajaLista').hide();", 200);
		var suma = parseFloat(0);
		$('input[name=montoEntrada]').each(function() {
			jqMontoEntrada = eval("'#" + this.id + "'");
			montoEntrada= $(jqMontoEntrada).asNumber(); 
			if(montoEntrada != '' && !isNaN(montoEntrada) && esTab){
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
	
	//para llevar el total de entradas
	function totalEntradasSalidasDiferencia() {
		consultarParametrosBean();
		controlQuitaFormatoMoneda('sumTotalSal');
		controlQuitaFormatoMoneda('sumTotalEnt');
		esTab= true;
		setTimeout("$('#cajaLista').hide();", 200);
		var sumaEntradas = parseFloat(0);
		var sumaSalidas = parseFloat(0);
		var diferencia = parseFloat(0);
		var sumTotalSal= $('#sumTotalSal').asNumber(); 
		var sumTotalEnt= $('#sumTotalEnt').asNumber(); 
		var montoCargar= $('#montoCargar').asNumber(); 
		var montoAbonar= $('#montoAbonar').asNumber(); 
		var montoPagar= $('#montoPagar').asNumber();
		var montoGarLiq= $('#montoGarantiaLiq').asNumber();
		
		
		sumaEntradas= parseFloat(sumTotalEnt)+ parseFloat(montoCargar) ;
		
		if(parseFloat(sumaEntradas)>=parseFloat(sumaSalidas)){
			diferencia = parseFloat(sumaEntradas)- parseFloat(sumaSalidas) ;
		}else{
			diferencia = parseFloat(sumaSalidas)- parseFloat(sumaEntradas) ;
		}
		
		$('#totalEntradas').val(sumaEntradas);
		$('#totalSalidas').val(sumaSalidas);
		$('#diferencia').val(diferencia);
		actualizaFormatosMoneda('formaGenerica');
	}
	
	//------------ Validaciones de Controles -------------------------------------
	function consultarParametrosBean() {
		var parametroBean = consultaParametrosSession();
		rutaArchivos = parametroBean.rutaArchivos;
		$('#fechaSistemaP').val(parametroBean.fechaSucursal);
		$('#nombreInstitucion').val(parametroBean.nombreInstitucion);
		$('#numeroSucursal').val(parametroBean.sucursal);
		$('#nombreSucursal').val(parametroBean.nombreSucursal);
		$('#numeroCaja').val(parametroBean.cajaID);
		$('#nomCajero').val(parametroBean.nombreUsuario);
	}
	
 	function cargaFolios(jqCtrl){
 		var CajasTransferBean = {
 			'sucursalOrigen' : parametros.sucursal,
 			'cajaDestino'	 : parametros.cajaID
 		};
		dwr.util.removeAllOptions(jqCtrl);
		dwr.util.addOptions( jqCtrl, {'0':'Selecciona'});
		cajasTransferServicio.listaCombo(catTipoListaFolios.combo, CajasTransferBean, function(folios){
			dwr.util.addOptions(jqCtrl, folios, 'cajasTransferID', 'detalleFolios');
		});
 	}
 	
 	function consultaEntradaDenominacion(folio) {	
		var bean = {
				'cajasTransferID' : folio
			};	
		cajasTransferServicio.listaConsulta(1, bean, function(disponDenom){
			if (disponDenom != null){
				for (var i = 0; i < disponDenom.length; i++){
					switch(parseInt(disponDenom[i].denominacionID))
					{	
					case 1:$('#cantEntraMil').val(disponDenom[i].cantidad);
							cantidadPorDenominacionMil('cantEntraMil');
							totalEntradasSalidasDiferencia();
					break;
					case 2:$('#cantEntraQui').val(disponDenom[i].cantidad);
							cantidadPorDenominacionQui('cantEntraQui');
							totalEntradasSalidasDiferencia();
					break;
					case 3:$('#cantEntraDos').val(disponDenom[i].cantidad);
							cantidadPorDenominacionDos('cantEntraDos');
							totalEntradasSalidasDiferencia();
					break;
					case 4:$('#cantEntraCien').val(disponDenom[i].cantidad);
							cantidadPorDenominacionCien('cantEntraCien');
							totalEntradasSalidasDiferencia();
					break;
					case 5:$('#cantEntraCin').val(disponDenom[i].cantidad);
							cantidadPorDenominacionCin('cantEntraCin');
							totalEntradasSalidasDiferencia();
					break;
					case 6:$('#cantEntraVei').val(disponDenom[i].cantidad);
							cantidadPorDenominacionVei('cantEntraVei');
							totalEntradasSalidasDiferencia();
					break;
					case 7:$('#cantEntraMon').val(disponDenom[i].cantidad);
							cantidadPorDenominacionMon('cantEntraMon');
							totalEntradasSalidasDiferencia();
					break;
					}
	
					$('#polizaID').val(disponDenom[i].polizaID);
				}
				habilitaBoton('aceptar','submit');
			}else{
				deshabilitaBoton('aceptar','submit');	
			}
		});
	}
	
	function consultaSaldosCaja(){
		var numConsulta = 2;
		var beanCaja = {
				'cajaID'		: parametros.cajaID
		};
		cajasVentanillaServicio.consulta(numConsulta, beanCaja, function(saldo){
			if (saldo !=null){
				$('#saldoEfecMNSesion').val(saldo.saldoEfecMN);
				$('#saldoEfecMNSesion').formatCurrency({
					positiveFormat: '%n',
					negativeFormat: '%n',
					roundToDecimalPlace: 2
				});		
			}
		});
	}
////inicializa parametros
	function inicializaParametros(){
		var parametros = consultaParametrosSession();
		if (parametros.tipoCaja == '' || parametros.tipoCaja == undefined){
			mensajeSis('El Usuario no tiene una Caja asignada.');
			deshabilitaItems();
		}else if (parametros.tipoCaja == 'CA' || parametros.tipoCaja == 'CP' || parametros.tipoCaja == 'BG'){
			estaAbiertaCaja($('#sucursalIDSesion').val(),$('#cajaIDSesion').val(),parametros.tipoCaja);
		}else{
			mensajeSis('El tipo de caja no esta definido correctamente');
			deshabilitaItems();
		}
	 }


	//Consulta si la caja esta Actual esta abierta 
	 function estaAbiertaCaja(sucursalID,cajaID,tipoCaja){
		 var CajasVentanillaBeanConCajSuc = {
		  			'cajaID': cajaID
				};
		 var conPrincipal = 3;
			cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanConCajSuc ,function(cajasVentanillaConCaja){
				if(cajasVentanillaConCaja != null)
				{
				if(cajasVentanillaConCaja.sucursalID != sucursalID){
					mensajeSis('No puede realizar esta operación ya que la sucursal del cajero no concuerda con la sucursal asignada a la caja.');
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
								agregaFormatoControles('formaGenerica');
								cargaFolios('foliosRecepcion');
								deshabilitaBoton('aceptar','submit');
								$('#saldoEfecMNSesion').formatCurrency({
												positiveFormat: '%n',
												negativeFormat: '%n',
												roundToDecimalPlace: 2
											});	
								
								habilitaItems();
							}	
						}
					});
				
				}
			}
		});
	 }
	 
	 function deshabilitaItems(){
		limpiaGridEntrada();
		$('#foliosRecepcion').attr('disabled',true);
		deshabilitaBoton('aceptar','submit');
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
		$('#foliosRecepcion').removeAttr('disabled');
		habilitaBoton('aceptar','submit');
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
	 function limpiaGridEntrada(){
		var extencion = '';
		for (var i = 1; i < 8; i++){
			var diponible = 0;
			var monto = parseFloat(0);
			var deno=0;
			switch(i)
			{
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
			var jqMonto = eval("'#montoEntra" + extencion + "'");
			var jqDisponible = eval("'#cantEntra" + extencion + "'");
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
});




function limpiaCamposDenominaciones(){
	
	$('#cantEntraMil').val('0');
	$('#cantEntraQui').val('0');
	$('#cantEntraDos').val('0');
	$('#cantEntraCien').val('0');
	$('#cantEntraCin').val('0');
	$('#cantEntraVei').val('0');
	
	$('#montoEntraMil').val('0.00');
	$('#montoEntraQui').val('0.00');
	$('#montoEntraDos').val('0.00');
	$('#montoEntraCien').val('0.00');
	$('#montoEntraCin').val('0.00');
	$('#montoEntraVei').val('0.00');
	$('#montoEntraMon').val('0.00');
	$('#sumTotalEnt').val('0.00');
	
}