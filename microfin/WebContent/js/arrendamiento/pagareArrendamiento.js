// DECLARACION DE VARIABLES
var parametroBean = consultaParametrosSession();
var arrendamientoID = 0;
$(document).ready(function() {
	esTab = false;		
	// Definicion de Constantes y Enums
	var catTipoConsultaArrendamiento = {
			'arrendamientoPorID' 	 : 2,
			'estatusImpresionPagare' : 5
	};
	
	var catTipoListaArrendamiento = {
			'arrendamiento' : 3
	};
	
	var catTipoListaAmortizaciones = {
			'amortizaciones' : 1
	};
	
	var catTipoTransaciones = {
			'tipoActualizacion' : 2,
			'actualizaEstatus' 	: 4
	};
	
	var catTipoReporte = {
			'contratoPagare' : 1,
			'caratulaContratoPagare': 2,
			'pagare': 3
	};
	
	// ------------ Manejo de Eventos -----------------------------------------
	// INICIALIZAR EL FORMULARIO
	inicializaForma('formaGenerica', 'arrendaID');
	inicializaFormulario();
	$('#tipoListaAmorti').val(catTipoListaAmortizaciones.amortizaciones);
	$('#arrendaID').focus();
	
	// EVENTOS
	$(':text').focus(function() {
		esTab = false;
	});
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	//Mostrar la lista de pagaré de arrendamiento
	$('#arrendaID').bind('keyup',function(e) {
		if (this.value.length >= 2) {
            var camposLista = new Array();
            var parametrosLista = new Array();
            camposLista[0] = "arrendaID";
            parametrosLista[0] = $('#arrendaID').val();
            lista('arrendaID', '2', catTipoListaArrendamiento.arrendamiento,camposLista, parametrosLista, 'listaArrendamientos.htm');
        }
		
	});
	
	// realizar la consulta al seleccionar un numero de arrendamiento
	$('#arrendaID').blur(function() {
		if(!isNaN($('#arrendaID').val()) && esTab) {
			consultaArrendamiento(this.id);
			$('#tipoActualizacion').val(catTipoTransaciones.tipoActualizacion);
			$('#tipoTransaccion').val(catTipoTransaciones.actualizaEstatus);
		}
	});
	
	// impresion del contrato
	$('#imprimirContrato').click(function() {
		imprimirReporte(catTipoReporte.contratoPagare);
	});
	
	// impresion de la caratula del contrato
	$('#imprimirAnexo').click(function() {
		imprimirReporte(catTipoReporte.caratulaContratoPagare);
	});
	
	// Actualizacion del estatus al imprimir el pagare
	$.validator.setDefaults({
		submitHandler: function(event) {		
			var arrendamientoID = $('#arrendaID').val();	   
		    var arrendamientosBean = {
				'arrendaID': arrendamientoID
			};
		    if (arrendamientoID != '' && !isNaN(arrendamientoID)) {
		    	arrendamientoServicio.consulta(catTipoConsultaArrendamiento.estatusImpresionPagare, arrendamientosBean,function(arrendamiento) {
		    		if (arrendamiento!=null){
		    			if (arrendamiento.pagareImpreso == 'N'){
		    				grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','arrendaID');
		    				imprimirReporte(catTipoReporte.pagare);
		    			}else{
		    				imprimirReporte(catTipoReporte.pagare);
		    			}
		    		}else{
		    			imprimirReporte(catTipoReporte.pagare);
		    		}
		    	});
		    }
		}
	});
	
	$('#formaGenerica').validate({
		rules: {
			arrendaID: 'required',			
		},
		messages: {
			arrendaID: 'Especifique número de arrendamiento',
		}		
	});
	// ------------ Metodos -------------------------------------
	/**
	 * Metodo para realizar la consulta por ID de arrendamiento
	 */
	function consultaArrendamiento(idControl) {
	    var jqArrenda = eval("'#" + idControl + "'");
	    var arrendamientoID = $(jqArrenda).val();	   
	    var arrendamientosBean = {
			'arrendaID': arrendamientoID
		};
	    
	    setTimeout("$('#cajaLista').hide();", 200);	  
	    if (arrendamientoID != '' && !isNaN(arrendamientoID)) {
			// se realiza consulta al servicio
	    	arrendamientoServicio.consulta(catTipoConsultaArrendamiento.arrendamientoPorID, arrendamientosBean,function(arrendamiento) {
	    		if (arrendamiento!=null){
	    			limpiarCampos();
	    			limpTablaAmorti();
	    			arrendamientoID = arrendamiento.arrendaID;
	    			// se llena los campos
	    			$('#clienteID').val(arrendamiento.clienteID);
	    			$('#nombreCliente').val((arrendamiento.nombreCliente).toUpperCase());	
	    			$('#productoArrendaID').val(arrendamiento.productoArrendaID);
	    			$('#productoArrenda').val((arrendamiento.productoArrendaDescri).toUpperCase());
	    			$('#estatus').val((arrendamiento.estatus).toUpperCase());
	    			$('#tipoArrenda').val((arrendamiento.tipoArrenda).toUpperCase());
	    			// Condiciones
	    			$('#montoArrenda').val(arrendamiento.montoArrenda);
	    			$('#porcEnganche').val(arrendamiento.porcEnganche+'%');	
	    			$('#montoEnganche').val(arrendamiento.montoEnganche);
	    			$('#seguroArrendaID').val((arrendamiento.seguroDescri).toUpperCase());
	    			$('#montoSeguroAnual').val(arrendamiento.montoSeguroAnual);
	    			$('#tipoPagoSeguro').val((arrendamiento.tipoPagoSeguro).toUpperCase());
	    			$('#montoSeguroVidaAnual').val(arrendamiento.montoSeguroVidaAnual);
	    			$('#tipoPagoSeguroVida').val((arrendamiento.tipoPagoSeguroVida).toUpperCase());
	    			//$('#seguroVidaAnualID').val((arrendamiento.seguroVidaDescri).toUpperCase());
	    			$('#montoFinanciado').val(arrendamiento.montoFinanciado);
	    			$('#diaPagoProd').val((arrendamiento.diaPagoProd).toUpperCase());
	    			$('#montoResidual').val(arrendamiento.montoResidual);
	    			$('#fechaApertura').val(arrendamiento.fechaApertura);
	    			$('#fechaPrimerVen').val(arrendamiento.fechaPrimerVen);
	    			$('#fechaUltimoVen').val(arrendamiento.fechaUltimoVen);
	    			$('#frecuenciaPlazo').val((arrendamiento.frecuenciaPlazo).toUpperCase());
	    			$('#plazo').val(arrendamiento.plazo);
	    			$('#tasaFijaAnual').val(arrendamiento.tasaFijaAnual);
	    			$('#montoCuota').val(arrendamiento.montoCuota);
	    			if (arrendamiento.fechaInhabil == 'S') {
	    				$('#fechaInhabilS').attr("checked",true);
	    				$('#fechaInhabilA').attr("checked",false);
	    			} else {
	    				$('#fechaInhabilA').attr("checked",true);
	    				$('#fechaInhabilS').attr("checked",false);
	    			}
	    			// Pago inicial
	    			$('#montoEnganchePagoI').val(arrendamiento.montoEnganche);
	    			$('#ivaEnganche').val(arrendamiento.ivaEnganche);
					$('#montoComApe').val(arrendamiento.montoComApe);
	    			$('#ivaComApe').val(arrendamiento.ivaComApe);
	    			$('#cantRentaDepo').val(arrendamiento.cantRentaDepo);
	    			$('#montoDeposito').val(arrendamiento.montoDeposito);
	    			$('#ivaDeposito').val(arrendamiento.ivaDeposito);
	    			$('#otroGastos').val(arrendamiento.otroGastos);
	    			$('#montoSeguro').val(arrendamiento.montoSeguroAnual);
	    			$('#montoSeguroVida').val(arrendamiento.montoSeguroVidaAnual);
	    			$('#concRentaAnticipada').val(arrendamiento.concRentaAnticipada);
	    			$('#concIvaRentaAnticipada').val(arrendamiento.concIvaRentaAnticipada);
	    			$('#concRentasAdelantadas').val(arrendamiento.concRentasAdelantadas);
	    			$('#concIvaRentasAdelantadas').val(arrendamiento.concIvaRentasAdelantadas);
	    			$('#totalPagoInicial').val(arrendamiento.totalPagoInicial);
	    			// se muestran las amortizaciones
	    			listaAmortizaciones(arrendamientoID);
	    			agregaFormatoControles('formaGenerica');
	    		}else{
	    			alert("No se encontró información del Arrendamiento seleccionado.");
	    			inicializaFormulario();
	    			$("#arrendaID").focus();
	    		}
	        });
	    }
	}// fin del metodo: consultaArrendamiento
	
	/**
	 * Lista de mortizaciones por ArrendamientoID
	 */
	function listaAmortizaciones(arrendamientoID){
		var numeroError = 0;
		var mensajeTransaccion = "";
		var params = {};
		params['tipoLista'] = catTipoListaAmortizaciones.amortizaciones;
		params['arrendaID'] = arrendamientoID;						
		$.post("amortizacionesGrid.htm",params,function(data) {
			if(data.length >0 && data != null) { 
				$('#contenedorAmortizaciones').html(data); 
				
				if ( $("#numeroErrorList").length ) {
					numeroError = $('#numeroErrorList').asNumber();  
					mensajeTransaccion = $('#mensajeErrorList').val();
				}
				
				if(numeroError==0){
					$('#contenedorAmortizaciones').show();
					$('#contenedorBotonesImp').show();
					$('#imprimirPagare').focus();
					if ($('#siguiente').is(':visible') && $('#anterior').is(':visible')==false){
						$('#filaTotales').hide();	
					}
					if ($('#siguiente').is(':visible')==false && $('#anterior').is(':visible')==false){
						$('#filaTotales').show();	
					}		
					agregaFormatoControles('contenedorAmortizaciones');
				}else{
					limpTablaAmorti();
					limpDetalleGrid();
					mensajeSisError(numeroError,mensajeTransaccion);
				}				
			}
		}); 
	} //fin metodo: amortizaciones 
		
	/**
	 * Metodo para imprimir reporte
	 */
	function imprimirReporte(tipoReporte){
		var clienteID = $('#clienteID').val();
		var fechaSis  = parametroBean.fechaAplicacion;
		var arrendamientoID = $('#arrendaID').val();
		var institucionID = parametroBean.numeroInstitucion;
		var numCtaInstitucion = parametroBean.cuentaInstitucion;
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var rutaImgReportes = parametroBean.rutaImgReportes;
		// opciones de impresion de reporte
		switch(tipoReporte){
			case catTipoReporte.contratoPagare:
				window.open('Contrato.htm?institucionID='+institucionID+
						'&numCtaInstit='+numCtaInstitucion+
						'&tipoTransaccion='+catTipoReporte.contratoPagare+
						'&arrendamientoID='+arrendamientoID+
						'&clienteID='+clienteID+
						'&nombreInstitucion='+nombreInstitucion+
						'&rutaImgReportes='+rutaImgReportes+						
						'&fechaSistema='+fechaSis, '_blank');
				break;
			case catTipoReporte.caratulaContratoPagare:
				window.open('AnexosContrato.htm?institucionID='+institucionID+
						'&numCtaInstit='+numCtaInstitucion+
						'&tipoTransaccion='+catTipoReporte.caratulaContratoPagare+
						'&arrendamientoID='+arrendamientoID+
						'&clienteID='+clienteID+
						'&nombreInstitucion='+nombreInstitucion+
						'&rutaImgReportes='+rutaImgReportes+
						'&fechaSistema='+fechaSis, '_blank');
				break;
			case catTipoReporte.pagare:
				window.open('PagareTasaFija.htm?tipoTransaccion='+catTipoReporte.pagare+
						'&arrendamientoID='+arrendamientoID+
						'&clienteID='+clienteID+
						'&institucionID='+institucionID+
						'&numCtaInstit='+numCtaInstitucion+
						'&nombreInstitucion='+nombreInstitucion+
						'&rutaImgReportes='+rutaImgReportes+
						'&fechaSistema='+fechaSis, '_blank');
				break;
		}
	}// fin del metodo: imprimirReporte
		
});// fin del Document

// inicializa el formulario
function inicializaFormulario(){
	ocultaCamposPantalla();
	camposDefaultPantalla();
	agregaFormatoControles('formaGenerica');
}

//campos en pantalla por default
function camposDefaultPantalla(){
	arrendamientoID = 0;
	$('#clienteID').val('');
	$('#nombreCliente').val('');
	$('#productoArrendaID').val('');
	$('#productoArrenda').val('');
	$('#estatus').val('');
	$('#tipoArrenda').val('');
	//condiciones
	$('#montoArrenda').val('0.0');
	$('#porcEnganche').val('0%');
	$('#montoEnganche').val('0.0');
	$('#seguroArrendaID').val('');
	$('#montoSeguroAnual').val('0.0');
	$('#tipoPagoSeguro').val('');
	$('#montoSeguroVidaAnual').val('0.0');
	$('#tipoPagoSeguroVida').val('');
	$('#montoFinanciado').val('0.0');
	$('#diaPagoProd').val('');
	$('#montoResidual').val('0.0');
	$('#fechaApertura').val(parametroBean.fechaAplicacion);
	$('#fechaPrimerVen').val(parametroBean.fechaAplicacion);
	$('#fechaUltimoVen').val(parametroBean.fechaAplicacion);
	$('#frecuenciaPlazo').val('');
	$('#plazo').val('0');
	$('#tasaFijaAnual').val('0.0');
	$('#montoCuota').val('0.0');
	$('#fechaInhabilS').attr("checked",true);
	$('#fechaInhabilA').attr("checked",false);
	//pago inicial
	$('#montoEnganchePagoI').val('0.0');
	$('#ivaEnganche').val('0.0');
	$('#ivaComApe').val('0.0');
	$('#montoComApe').val('0.0');
	$('#cantRentaDepo').val('0');
	$('#montoDeposito').val('0.0');
	$('#ivaDeposito').val('0.0');
	$('#otroGastos').val('0.0');
	$('#montoSeguro').val('0.0');
	$('#montoSeguroVida').val('0.0');
	$('#concRentaAnticipada').val('0.0');
	$('#concIvaRentaAnticipada').val('0.0');
	$('#concRentasAdelantadas').val('0.0');
	$('#concIvaRentasAdelantadas').val('0.0');
	$('#totalPagoInicial').val('0.0');
	// tabla amortizaciones
	$('#contenedorAmortizaciones').html('');
}

//limpiar tabla de amortizaciones
function limpTablaAmorti(){
	$('#contenedorAmortizaciones').html('');
	$('#contenedorAmortizaciones').hide();
	$('#contenedorBotonesImp').hide();
}

//limpiar Detalle del Grid
function limpDetalleGrid(){
	$('#miTabla').find(':input').each( 
		function(){	    		
			var child = $(this);
			child.val('');
		}
	);
}

//oculta los campos en pantalla
function ocultaCamposPantalla(){
	$('#contenedorAmortizaciones').hide();
	$('#contenedorBotonesImp').hide();
}

function limpiarCampos(){
	arrendamientoID = 0;
	$('#clienteID').val('');
	$('#nombreCliente').val('');
	$('#productoArrendaID').val('');
	$('#productoArrenda').val('');
	$('#estatus').val('');
	$('#tipoArrenda').val('');
	//condiciones
	$('#montoArrenda').val('');
	$('#porcEnganche').val('');
	$('#montoEnganche').val('');
	$('#seguroArrendaID').val('');
	$('#montoSeguroAnual').val('');
	$('#tipoPagoSeguro').val('');
	$('#montoSeguroVidaAnual').val('');
	$('#tipoPagoSeguroVida').val('');
	$('#montoFinanciado').val('');
	$('#diaPagoProd').val('');
	$('#montoResidual').val('');
	$('#fechaApertura').val('');
	$('#fechaPrimerVen').val('');
	$('#fechaUltimoVen').val('');
	$('#frecuenciaPlazo').val('');
	$('#plazo').val('');
	$('#tasaFijaAnual').val('');
	$('#montoCuota').val('');
	$('#fechaInhabilS').attr("checked",true);
	$('#fechaInhabilA').attr("checked",false);
	//pago inicial
	$('#montoEnganchePagoI').val('');
	$('#ivaEnganche').val('');
	$('#ivaComApe').val('');
	$('#montoComApe').val('');
	$('#cantRentaDepo').val('');
	$('#montoDeposito').val('');
	$('#ivaDeposito').val('');
	$('#otroGastos').val('');
	$('#montoSeguro').val('');
	$('#montoSeguroVida').val('');
	$('#totalPagoInicial').val('');
	limpDetalleGrid();
}