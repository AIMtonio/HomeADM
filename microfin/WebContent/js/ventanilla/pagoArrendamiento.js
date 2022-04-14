var monedaVacia = "0.00";
$(document).ready(function() {	
	$('#buscarMiGralArrendamiento').click(function(){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "arrendaID";		
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#arrendamientoID').val();
		parametrosLista[1] = $('#numeroSucursal').val();

		listaCte('arrendamientoID', '2', '6', camposLista, parametrosLista, 'arrendamientosLista.htm');
	});
	
	$('#buscarMiSucArrendamiento').click(function(){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "arrendaID";		
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#arrendamientoID').val();
		parametrosLista[1] = $('#numeroSucursal').val();

		listaCte('arrendamientoID', '2', '5', camposLista, parametrosLista, 'arrendamientosLista.htm');
	});
// se validan los eventos cuando se selecciona el 
// total del adeudo 
	$('#totalArrendamiento').click(function(){
		if($('#exigibleArrendamiento').is(':checked')){   
			$('#exigibleArrendamiento').attr('checked',false);
		} 
		
		$('#labelPagoExigibleArrendamiento').hide();  
		$('#pagoExigibleArrendamiento').hide();
		$('#lblexigibleAlDiaArrendamiento').hide();
		$('#exigAlDiaArrendamiento').hide();
		
		$('#lblTotalAdArrendamiento').show();
		$('#adeuTotalArrendamiento').show();
			
		
		$('#totalArrendamiento').attr('checked',true);
	});
	
	$('#exigibleArrendamiento').click(function(){ 
		if($('#totalArrendamiento').is(':checked')){  
			$('#totalArrendamiento').attr('checked',false);
		}
		
		$('#labelPagoExigibleArrendamiento').show();  
		$('#pagoExigibleArrendamiento').show();
		$('#lblTotalAdArrendamiento').hide();
		$('#adeuTotalArrendamiento').hide();
		
		$('#lblexigibleAlDiaArrendamiento').show();
		$('#exigAlDiaArrendamiento').show();
		
		if($('#totalArrendamiento').is(':checked')){  
			$('#totalArrendamiento').attr('checked',false);
			$('#finiquitoArrendamiento').val('N');
		}
	
		$('#exigibleArrendamiento').focus();
	});
	
}); //fin document

function consultArrendamiento(controlID){
	/***** BLOQUEAR LA PANTALLA HASTA QUE TERMINE DE CONSULTAR ******/
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
		$('#contenedorForma').block({
			message: $('#mensaje'),
			css: {border:		'none',
				background:	'none'}
		});
	/***** FIN BLOQUEAR LA PANTALLA HASTA QUE TERMINE DE CONSULTAR ***/
	setTimeout("$('#cajaLista').hide();", 200);
	var arrendamiento = $('#arrendamientoID').asNumber();
	if(arrendamiento != '' && !isNaN(arrendamiento)){
		var arrendamientoBeanCon = {
				'arrendaID':$('#arrendamientoID').val(),
  				'fechaActual':$('#fechaSistema').val()
		};
		$('#totalArrendamiento').attr('checked',false);  
		$('#exigibleArrendamiento').attr('checked',true);
		arrendamientoServicio.consulta(3,arrendamientoBeanCon,function(arrendamiento) {
			if(arrendamiento!=null){
				listaPersBloqBean = consultaListaPersBloq(arrendamiento.clienteID, esCliente, 0, 0);
				consultaSPL = consultaPermiteOperaSPL(arrendamiento.clienteID,'LPB',esCliente);
			
				if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
					esTab=true;	
					dwr.util.setValues(arrendamiento);
					// si la proxima fecha de pago es un valor vacio entonces el boton de adelantar pago no se activa
					if(arrendamiento.fechaProxPago == '1900-01-01'){
						$('#fecProxPagoArrendamiento').val("");
					}
					$('#clienteArrendamientoID').val(arrendamiento.clienteID);
					$('#nomCteArrendamiento').val(arrendamiento.nombreCliente);
					$('#monedaArrendamientoID').val(arrendamiento.monedaID);
					$('#monedaArrendamiento').val(arrendamiento.monedaDescri);
					$('#diasFaltaPagoArrendamiento').val(arrendamiento.diasFaltaPago);
					$('#fecProxPagoArrendamiento').val(arrendamiento.fechaProxPago);
					$('#prodArrendamientoID').val(arrendamiento.productoArrendaID);
					$('#descriProdArrendamiento').val(arrendamiento.nombreProducto);
					$('#tasaFijaArrendamiento').val(arrendamiento.tasaFijaAnual);
					$('#statusArrendamiento').val(arrendamiento.estatus);
					
					consultaAmortizacion();
					$('#impTicket').hide();
				}else{
					inicializaForma('formaGenerica','arrendamientoID');
					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
					$('#arrendamientoID').val('');
	   				$('#arrendamientoID').focus();
	   				$('#arrendamientoID').select();	
	   				inicializarCamposArrendamiento();
				}
   			}else{
   				inicializaForma('formaGenerica','arrendamientoID');
   				mensajeSis("No Existe el Arrendamiento.");
				$('#arrendamientoID').val('');
   				$('#arrendamientoID').focus();
   				$('#arrendamientoID').select();	
   				inicializarCamposArrendamiento();
   			}
		});				
	}
	$("#contenedorForma").unblock();
}
function consultaAmortizacion(){
	var arrendaAmortiBean = {
			'arrendaID':$('#arrendamientoID').val()
	};
	var estatus = $('#statusArrendamiento').val();

	if( estatus == "PAGADO"){
		mensajeSis("El arrendamiento ya se encuentra Pagado.");
		$('#arrendamientoID').val('');
		$('#arrendamientoID').focus();
		$('#arrendamientoID').select();	
		inicializarCamposArrendamiento();
	}else{
		arrendaAmortiServicio.consulta(2,arrendaAmortiBean,function(amoArrenda) {
			if(amoArrenda!=null){
				$('#exigAlDiaArrendamiento').val(amoArrenda.totalExigible);
				$('#saldoCapVigentArrendamiento').val(amoArrenda.saldoCapVigent);
				$('#saldoInterVigArrendamiento').val(amoArrenda.saldoInteresVigente);
				$('#salIVACapArrendamiento').val(amoArrenda.montoIVACapital);
				$('#salIVAIntereArrendamiento').val(amoArrenda.montoIVAInteres);
				$('#saldoComFaltPagoArrendamiento').val(amoArrenda.saldComFaltPago);
				$('#salIVAComFalPagArrendamiento').val(amoArrenda.montoIVAComFalPag);
				$('#salCapAtrasadArrendamiento').val(amoArrenda.saldoCapAtrasad);
				$('#saldoInterAtrasArrendamiento').val(amoArrenda.saldoInteresAtras);
				$('#saldoMorArrendamiento').val(amoArrenda.saldoMoratorios);
				$('#saldoOtrasComisArrendamiento').val(amoArrenda.saldoOtrasComis);
				$('#saldoIVAComisiArrendamiento').val(amoArrenda.montoIVAComisi);
				$('#salCapVenArrendamiento').val(amoArrenda.saldoCapVencido);
				$('#salInterVencArrendamiento').val(amoArrenda.saldoInteresVen);
				$('#salIVAMorArrendamiento').val(amoArrenda.montoIVAMora);
				$('#salSegInComisArrendamiento').val(amoArrenda.saldoSeguro);
				$('#salIVASegInComisArrendamiento').val(amoArrenda.montoIVASeguro);
				$('#totalCapitalArrendamiento').val(amoArrenda.totalCapital);
				$('#totalInteresArrendamiento').val(amoArrenda.totalInteres);
				$('#totalComisiArrendamiento').val(amoArrenda.totalComision);
				$('#totalIVAComArrendamiento').val(amoArrenda.totalIvaComisi);
				$('#salSegVidaComisArrendamiento').val(amoArrenda.saldoSeguroVida);
				$('#salIVASegVidaComisArrendamiento').val(amoArrenda.montoIVASeguroVida);
			
				var valExigible=amoArrenda.totalExigible;
			
				if(valExigible == monedaVacia){
					mensajeSis("No hay pago del dia.");
					$('#arrendamientoID').val('');
					$('#arrendamientoID').focus();
					deshabilitaBoton('graba', 'submit');
				}
			}
		});
	}
}

function inicializarCamposArrendamiento(){
	$('#monedaArrendamiento').val('');
	$('#fecProxPagoArrendamiento').val('');
	$('#prodArrendamientoID').val('');
	$('#descriProdArrendamiento').val('');
	$('#montoPagarArrendamiento').val('');
	$('#totalArrendamiento').attr('checked', false);
    $('#exigibleArrendamiento').attr('checked', true);
	$('#formaPagoEfectivo').attr('checked', true);
}
	
function imprimeTicketPagoArrendamiento(arrendamiento,fechaPago, transaccion) {	
	var beanDetallePagArrenda = {
			'arrendaID':arrendamiento,
			'fechaPago':fechaPago,
			'transaccion':transaccion
		};
	arrendamientoServicio.consultaDetallePagoArrenda(1,beanDetallePagArrenda,{ async: false, callback:	function(detallePago){		
		if(detallePago != null){
			var imprimeTicketPagoArrendamientoBean={	
					'folio' 	        : $('#numeroTransaccion').val(),
					'tituloOperacion'   : 'COMPROBANTE DE PAGO DE ARRENDAMIENTO',
					'clienteID' 		: detallePago.clienteID,  
					'arrendaID' 		: arrendamiento,          
					'nombreCliente'     : detallePago.nombreCompleto,
					'producto'			: $('#prodArrendamientoID').val(),
					'nombreproducto'	: $('#descriProdArrendamiento').val(),
					'fechaPago'			: $('#fechaSistemaP').val(),
					'montoPago'			: detallePago.montoTotal,
					'proxFechaPago'     : detallePago.fechaProxPago,
					'montoProximoPago'  : detallePago.montoProxPago,
					'moneda'			: $('#monedaArrendamiento').val(),  
					'comisionFalPag'	: detallePago.montoComFaltPag,      
					'ivaComFalPag'		: detallePago.montoIVAComFaltPag,
					'otrascomision'		: detallePago.montoOtrasComis,   
					'ivaOtrasCom'		: detallePago.montoIVAOtrasComis,
					'moratorios'		: detallePago.montoIntMora,   
					'ivaMora'			: detallePago.montoIVAMora,   
					'montoSeguroInmob'	: detallePago.montoSegInmob,     
					'ivaSeguroInmob'	: detallePago.montoIVASegInmob,  
					'montoSeguroVida'	: detallePago.montoSegVida,      				
					'ivaSeguroVida'		: detallePago.montoIVASegVida,    
					'interes' 			: detallePago.interes,             
					'ivaInteres'		: detallePago.montoIVAIntere,      
					'capital'			: detallePago.capital,     
					'ivaCapital'		: detallePago.montoIVACap, 
					'total' 		 	: detallePago.montoTotal,                        
					'cambio'			: $('#sumTotalSal').val(),  
					'montoRecibido' 	: $('#sumTotalEnt').val() , 
					'formaPago'			: 'EFECTIVO',			
				};	
			imprimeTicketArrendamiento(imprimeTicketPagoArrendamientoBean);
		}
			
	}

	});													
		
}