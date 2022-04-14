var opcionMenuRegBean ;
var menuDesCredito		    = {};
var menuPeriodicidad 		= {};
var menuPlazo		 		= {};
var menuTipoCredito			= {};
var menuTipoGaran		    = {};
var menuTipoPres			= {};
var enteroCero          	= 0;

var catRegulatorioD0842 = { 
			'Excel'			: 4,		
			'Csv'			: 5,		
		};

var lisMenuRegulatorio = { 
			'Busqueda'			: 1,		
			'Combo'				: 2,
			'clasificaConta'	: 6,
			'tipoTasa'			: 7,
			'tasaRefen'			: 8,
			'opeDifTasa'		: 9,
			'tipodispCred'		: 10,
			'periodoPagos'		: 11,
			'tipoGarantia'		: 13,

		};

var catMenuRegulatorio = { 
			'Instituciones'			: 1,
			'DestinoCredito'		: 10,		
			'Periodicidad'			: 11,		
			'PlazoCortLarg'		    : 12,		
			'TipoCredito'			: 13,		
			'TipoPrestamista'		: 15,
		};
var catTipoTransaccion = {
		'agrega' : '2',
		'modifica' : '3',
		'elimina'	: '4'

	};

$(document).ready(function() {

	parametros = consultaParametrosSession();
	esTab = false;
	
	deshabilitaBoton('agrega');
	deshabilitaBoton('modifica');
	deshabilitaBoton('elimina');
	agregaFormatoControles('formaGenerica');
	llenaComboAnios(parametroBean.fechaAplicacion);

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
	    	 
	    	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','identificadorID','funcionExito','funcionError');		  
	    	 
	      }
	});	

	//------------ Validaciones de Controles -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			anio: {
				required: true
			},

			mes: {
				required: true
			},
			identificadorID: {
				required: true,
				numeroPositivo : true,
			},
			numeroIden: {
				required: true,
				numeroPositivo : true,
			},
			tipoPrestamista: {
				required: true
			},	
			paisEntidadExtranjera: {
				required: true,
				numeroPositivo : true,
			},
			numeroCuenta: {
				required: true,
				numerosLetras :true
			},
			numeroContrato: {
				required: true,
				numerosLetras :true
			},	
			clasificaCortLarg: {
				required: true
			},	
			fechaContra: {
				required: true,
				date: true
			},
			fechaVencim: {
				required: true,
				date: true
			},	
			plazo: {
				required: true,
				numeroPositivo : true,
			},	
			periodo: {
				required: true
			},	
			montoRecibido: {
				required: true
			},	
			montoInicialPrestamo: {
				required: true
			},
			tipoTasa: {
				required: true
			},	
			valTasaOriginal: {
				required: true
			},	
			valTasaInt: {
				required: true
			},	
			tasaIntReferencia: {
				required: true,
				numeroPositivo : true,
			},	
			diferenciaTasaRef: {
				required: true
			},	
			operaDifTasaRefe: {
				required: true
			},	
			frecRevisionTasa: {
				required: true,
				numeroPositivo : true,
			},	
			tipoMoneda: {
				required: true
			},	
			porcentajeComision: {
				required: true
			},	
			importeComision: {
				required: true
			},	
			periodoPago: {
				required: true
			},	
			tipoDisposicionCredito: {
				required: true
			},
			destino: {
				required: true
			},	
			clasificaConta: {
				required: true
			},	
			saldoInicio: {
				required: true
			},	
			pagosRealizados: {
				required: true
			},	
			comisionPagada: {
				required: true
			},
			interesesPagados: {
				required: true
			},	
			interesesDevengados: {
				required: true
			},	
			saldoCierre: {
				required: true
			},	
			porcentajeLinRevolvente: {
				required: true
			},
			fechaUltPago: {
				required: true,
				date: true
			},	
			pagoAnticipado: {
				required: true
			},
			montoUltimoPago: {
				required: true
			},	
			fechaPagoInmediato: {
				required: true,
				date: true
			},	
			montoPagoInmediato: {
				required: true
			},	
			tipoGarantia: {
				required: true
			}
		},		
		messages: {
			anio: {
				required: 'Especifique el Año del periodo'
			},
			mes: {
				required: 'Especifique el Mes del periodo'
			},
			identificadorID: {
				required: 'Especifique Número de Registro',
				numeroPositivo : "Sólo números",
			},
			numeroIden: {
				required: 'Especifique el Otorgante',
				numeroPositivo : "Sólo números",
			},
			tipoPrestamista: {
				required: 'Especifique Tipo de Prestamista'
			},	
			paisEntidadExtranjera: {
				required: 'Especifique País Entidad Financiera',
				numeroPositivo : "Sólo números",
			},
			numeroCuenta: {
				required: 'Especifique Número de Cuenta',
				numerosLetras: 'Ingrese un Número de Cuenta Válido'
			},
			numeroContrato: {
				required: 'Especifique Número de Contrato',
				numerosLetras: 'Ingrese un Número de Contrato Válido'
			},	
			clasificaCortLarg: {
				required: 'Especifique Clasificación del Plazo'
			},	
			fechaContra: {
				required: 'Especifique Fecha de Contratación',
				date: 'Especifique Formato de Fecha Válido',
			},
			fechaVencim: {
				required: 'Especifique Fecha de Vencimiento',
				date: 'Especifique Formato de Fecha Válido',
			},	
			plazo: {
				required: 'Especifique Plazo de Vencimiento',
				numeroPositivo : "Sólo números",
			},	
			periodo: {
				required: 'Especifique Periodicidad de Pagos'
			},	
			montoRecibido: {
				required: 'Especifique Monto Inicial Origen'
			},	
			montoInicialPrestamo: {
				required: 'Especifique Monto Inicial Monedad Nacional'
			},
			tipoTasa: {
				required: 'Especifique Tipo de Tasa'
			},	
			valTasaOriginal: {
				required: 'Especifique Valor de la Tasa Original'
			},	
			valTasaInt: {
				required: 'Especifique Interés Aplicable de la Tasa'
			},	
			tasaIntReferencia: {
				required: 'Especifique Tasa de Referencia',
				numeroPositivo : "Sólo números",
			},	
			diferenciaTasaRef: {
				required: 'Especifique Ajuste de Tasa de Referencia'
			},	
			operaDifTasaRefe: {
				required: 'Especifique Operación Diferencial de Tasa de Referencia'
			},	
			frecRevisionTasa: {
				required: 'Especifique Frecuencia de Revision de la Tasa',
				numeroPositivo : "Sólo números",
			},	
			tipoMoneda: {
				required: 'Especifique Tipo de Moneda'
			},	
			porcentajeComision: {
				required: 'Especifique Porcentaje de Comisión'
			},	
			importeComision: {
				required: 'Especifique Importe de Comisión'
			},	
			periodoPago: {
				required: 'Especifique Periodicidad de Comisión'
			},	
			tipoDisposicionCredito: {
				required: 'Especifique Tipo Disposición Crédito'
			},
			destino: {
				required: 'Especifique Tipo Destino Crédito'
			},	
			clasificaConta: {
				required: 'Especifique Clasificación Contable'
			},	
			saldoInicio: {
				required: 'Especifique Saldo Inicio'
			},	
			pagosRealizados: {
				required: 'Especifique Monto Pagos Realizados'
			},	
			comisionPagada: {
				required: 'Especifique Comisión Pagada'
			},
			interesesPagados: {
				required: 'Especifique Interéses Pagados'
			},	
			interesesDevengados: {
				required: 'Especifique Interéses Devengados No Pagados'
			},	
			saldoCierre: {
				required: 'Especifique Saldo Cierre'
			},
			porcentajeLinRevolvente: {
				required: 'Especifique Porcentaje Línea Revolvente'
			},
			fechaUltPago: {
				required: 'Especifique Fecha Último Pago',
				date: 'Especifique Formato de Fecha Válido'
			},	
			pagoAnticipado: {
				required: 'Especifique Pago Anticipado'
			},
			montoUltimoPago: {
				required: 'Especifique Monto Último Pago'
			},	
			fechaPagoInmediato: {
				required: 'Especifique Fecha Siguiente Pago',
				date: 'Especifique Formato de Fecha Válido'
			},	
			montoPagoInmediato: {
				required: 'Especifique Monto Siguiente Pago'
			},	
			tipoGarantia: {
				required: 'Especifique Tipo de Garantía'
			}	
		}		
	});


	cargarMenus(); 
	consultaRegistroRegulatorioD0842();
	
	$( '#tabs' ).tabs({
		ajaxOptions: {
			error: function( xhr, status, index, anchor ) {
				$( anchor.hash ).html("Couldn't load this tab. We'll try to fix this as soon as possible. " +
					"If this wouldn't be a demo." );
			}
		}
    });	

    $('#tabs ul li a').click(function(){
		if(this.id == 'reporteD0842'){
			$('#_reporte').show();
			
			$('#capturaInfo').hide();
			$('#reporte').show();
			setTimeout(function() {
				$('#excel').click();
			}, 10);
			$('#anio').focus();
			

			limpiarCombos();
			deshabilitaBoton('agrega');
			deshabilitaBoton('modifica');
			deshabilitaBoton('elimina');

		}
		if(this.id == 'registroD0842'){
			$('#capturaInfo').show();
			$('#reporte').hide();
			$('#identificadorID').focus().select();
			inicializaForma('formaGenerica', 'anio');
			limpiarCombos();
			deshabilitaBoton('agrega');
			deshabilitaBoton('modifica');
			deshabilitaBoton('elimina');
			
		}
		}	
	);

	$('#reporteD0842').click();

	$('#paisEntidadExtranjera').bind('keyup',function(e) { 
		lista('paisEntidadExtranjera', '1', '1', 'nombre', $('#paisEntidadExtranjera').val(),'listaPaises.htm');
	});

	
	$('#paisEntidadExtranjera').blur(function() {
		if(esTab){

			consultaPais(this.id);
		}
	});

	$('#identificadorID').bind('keyup',function(e) { 
		var parametros = ['descripcion','anio','mes'];
		var regulatorioD0842Bean = [$('#identificadorID').val(),$('#anio').val(),$('#mes').val()];
		lista('identificadorID', '1', '2',parametros,regulatorioD0842Bean,'registrosReg0842Lista.htm');
	});

	$('#numeroIden').bind('keyup',function(e) { 
		var parametros = ['descripcion','menuID'];
		var opcionMenuReg = [$('#numeroIden').val(),1];
		lista('numeroIden', '2', '1',parametros,opcionMenuReg,'opcionesMenuRegLista.htm');
	});

	$('#tasaIntReferencia').bind('keyup',function(e) { 
		var parametros = ['descripcion','menuID'];
		var opcionMenuReg = [$('#tasaIntReferencia').val(),1];
		lista('tasaIntReferencia', '2', '8',parametros,opcionMenuReg,'opcionesMenuRegLista.htm');
	});

	$('#tasaIntReferencia').blur(function() {
		if(esTab){
			consultaTasaReferencia(this.id);
		}
	});

	$('#numeroIden').blur(function() {
		if(esTab){
			consultaEntidad(this.id);
		}
	});


	$('#identificadorID').blur(function() {
		if(esTab){
			validaRegistro(this.id);
		}
	});
	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.agrega);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.modifica);
	});

	$('#elimina').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.elimina);
	});

	$('#generar').click(function(){

		if($('#excel').is(':checked')){
			generaReporte(catRegulatorioD0842.Excel);
			}
		if($('#csv').is(':checked')){
			generaReporte(catRegulatorioD0842.Csv);
		}		
	});

	$('#fechaContra').change(function(){
		var Xfecha= $('#fechaContra').val();
		var Yfecha= $('#fechaVencim').val();
		var fechaSis= parametroBean.fechaSucursal;
		
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaContra').val(fechaSis);
			if( mayor(Xfecha, fechaSis)){
				mensajeSis("La Fecha de Contratación no Puede ser Mayor a la Fecha del Sistema");
				$('#fechaContra').val(fechaSis);
				$('#fechaContra').focus();
			}else{
				if (Yfecha !='') {
					if( mayor(Xfecha, Yfecha)){
					mensajeSis("La Fecha de Contratación no Puede ser Mayor a la Fecha de Vencimiento")	;
					$('#fechaContra').val(Yfecha);
					$('#fechaContra').focus();
				}else{
					$('#fechaContra').focus();						
				}
				}
				
			}
		}else{
			$('#fechaContra').val(Yfecha);
			$('#fechaContra').focus();
		}
		if(esTab==false){
			this.focus();
		}
	});	

	$('#fechaVencim').change(function(){
		var Xfecha= $('#fechaVencim').val();
		var Yfecha= $('#fechaContra').val();
		var fechaSis= parametroBean.fechaSucursal;
		
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaVencim').val(fechaSis);
				if( mayor(Yfecha, Xfecha)){
					mensajeSis("La Fecha de Vencimiento no Puede ser Menor a la Fecha de Contratación")	;
					$('#fechaVencim').val(Yfecha);
					$('#fechaVencim').focus();
				}else{
					$('#fechaVencim').focus();						
				}
		}else{
			$('#fechaVencim').val(fechaSis);
			$('#fechaVencim').focus();
		}
		if(esTab==false){
			this.focus();
		}
	});		


	$('#fechaUltPago').change(function(){
		var Xfecha= $('#fechaUltPago').val();
		var Yfecha= $('#fechaPagoInmediato').val();
		var fechaSis= parametroBean.fechaSucursal;
		
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaUltPago').val(fechaSis);
			if( mayor(Xfecha, fechaSis)){
				mensajeSis("La Fecha del Último Pago no Puede ser Mayor a la Fecha del Sistema ");
				$('#fechaUltPago').val(fechaSis);
				$('#fechaUltPago').focus();
			}else{
				if (Yfecha !='') {
					if( mayor(Xfecha, Yfecha)){
					mensajeSis("La Fecha del Último Pago no Puede ser Mayor a la Fecha del Siguiente Pago")	;
					$('#fechaUltPago').val(Yfecha);
					$('#fechaUltPago').focus();
				}else{
					$('#fechaUltPago').focus();						
				}
				}
				
			}
		}else{
			$('#fechaUltPago').val(Yfecha);
			$('#fechaUltPago').focus();
		}
		if(esTab==false){
			this.focus();
		}
	});	

	$('#fechaPagoInmediato').change(function(){
		var Xfecha= $('#fechaPagoInmediato').val();
		var Yfecha= $('#fechaUltPago').val();
		var fechaSis= parametroBean.fechaSucursal;
		
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaPagoInmediato').val(fechaSis);
				if( mayor(Yfecha, Xfecha)){
					mensajeSis("La Fecha del Siguiente Pago no Puede ser Menor a la  Fecha del Último Pago")	;
					$('#fechaPagoInmediato').val(Yfecha);
					$('#fechaPagoInmediato').focus();
				}else{
					$('#fechaPagoInmediato').focus();						
				}
				}
		else{
			$('#fechaPagoInmediato').val(fechaSis);
			$('#fechaPagoInmediato').focus();
		}
		if(esTab==false){
			this.focus();
		}
	});	

	$('#fechaValuacionGaran').change(function(){
		var Xfecha= $('#fechaValuacionGaran').val();
		var fechaSis= parametroBean.fechaSucursal;
		
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaValuacionGaran').val(fechaSis);
			if( mayor(Xfecha, fechaSis)){
				mensajeSis("La Fecha del Último Pago no Puede ser Mayor a la Fecha del Sistema ");
				$('#fechaValuacionGaran').val(fechaSis);
				$('#fechaValuacionGaran').focus();
			}
		}else{
			$('#fechaUltPago').val(Yfecha);
			$('#fechaUltPago').focus();
		}
		if(esTab==false){
			this.focus();
		}
	});	

	$("#clasificaConta").change(function(){
		validaClasificasion(this.id);
	});
	$("#clasificaCortLarg").change(function(){
		asignaPlazo();
	});

	$('#excel').click();
});// cerrar


function cargarMenus(){

	// Combo Destino del Crédito
	dwr.util.removeAllOptions('destino'); 
  	dwr.util.addOptions('destino', {'':'SELECCIONAR'}); 
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.DestinoCredito,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean10) {
		    menuDesCredito = opcionesMenuRegBean10;
		    dwr.util.addOptions('destino',opcionesMenuRegBean10,  'codigoOpcion', 'descripcion');
			});
	//Combo la Periodicidad de la comision
  	dwr.util.removeAllOptions('periodoPago'); 
  	dwr.util.addOptions('periodoPago', {'':'SELECCIONAR'}); 
  	opcionMenuRegBean = {
						'menuID' : 0,
						'descripcion': ''
						};
  	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.periodoPagos,opcionMenuRegBean,function(opcionMenuReg) {
		     dwr.util.addOptions('periodoPago',opcionMenuReg,  'codigoOpcion', 'descripcion');
			});
	//Combo la Periodicidad del Crédito
	dwr.util.removeAllOptions('periodo'); 
  	dwr.util.addOptions('periodo', {'':'SELECCIONAR'}); 
  	opcionMenuRegBean = {
						'menuID' : 0,
						'descripcion': ''
						};
  	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.periodoPagos,opcionMenuRegBean,function(opcionMenuReg) {
		     dwr.util.addOptions('periodo',opcionMenuReg,  'codigoOpcion', 'descripcion');
			});

	//Combo Tipo de Plazo
	dwr.util.removeAllOptions('clasificaCortLarg'); 
  	dwr.util.addOptions('clasificaCortLarg', {'':'SELECCIONAR'}); 
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.PlazoCortLarg,
						'descripcion': ''
						};

	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean12) {
		      menuPlazo = opcionesMenuRegBean12;
		      dwr.util.addOptions('clasificaCortLarg',opcionesMenuRegBean12,  'codigoOpcion', 'descripcion');

			});

	//Combo Tipo de Garantía
	dwr.util.removeAllOptions('tipoGarantia'); 
  	dwr.util.addOptions('tipoGarantia', {'':'SELECCIONAR'}); 
	opcionMenuRegBean = {
						'menuID' : 0,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.tipoGarantia,opcionMenuRegBean,function(opcionMenuReg) {
		     dwr.util.addOptions('tipoGarantia',opcionMenuReg,  'codigoOpcion', 'descripcion');
			});

	//Combo Tipo de Prestamista
	dwr.util.removeAllOptions('tipoPrestamista'); 
  	dwr.util.addOptions('tipoPrestamista', {'':'SELECCIONAR'}); 
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.TipoPrestamista,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean15) {
		     menuTipoPres = opcionesMenuRegBean15;
		     dwr.util.addOptions('tipoPrestamista',opcionesMenuRegBean15,  'codigoOpcion', 'descripcion');
			});
	// combo de clasificacion contable
	dwr.util.removeAllOptions('clasificaConta'); 
  		dwr.util.addOptions('clasificaConta', {'':'SELECCIONAR'}); 
  		opcionMenuRegBean = {
						'menuID' : 0,
						'descripcion': ''
						};
  		opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.clasificaConta,opcionMenuRegBean,function(opcionMenuReg) {
		     dwr.util.addOptions('clasificaConta',opcionMenuReg,  'codigoOpcion', 'descripcion');
			});
  	// combo para tipo de tasa
	dwr.util.removeAllOptions('tipoTasa'); 
  		dwr.util.addOptions('tipoTasa', {'':'SELECCIONAR'}); 
  		opcionMenuRegBean = {
						'menuID' : 0,
						'descripcion': ''
						};
  		opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.tipoTasa,opcionMenuRegBean,function(opcionMenuReg) {
		     dwr.util.addOptions('tipoTasa',opcionMenuReg,  'codigoOpcion', 'descripcion');
			});
  	// combo para operacion diferencial de tasa
	dwr.util.removeAllOptions('operaDifTasaRefe'); 
  		dwr.util.addOptions('operaDifTasaRefe', {'':'SELECCIONAR'}); 
  		opcionMenuRegBean = {
						'menuID' : 0,
						'descripcion': ''
						};
  		opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.opeDifTasa,opcionMenuRegBean,function(opcionMenuReg) {
		     dwr.util.addOptions('operaDifTasaRefe',opcionMenuReg,  'codigoOpcion', 'descripcion');
			});
  		// combo para tipo disposicion de credito
	dwr.util.removeAllOptions('tipoDisposicionCredito'); 
  		dwr.util.addOptions('tipoDisposicionCredito', {'':'SELECCIONAR'}); 
  		opcionMenuRegBean = {
						'menuID' : 0,
						'descripcion': ''
						};
  		opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.tipodispCred,opcionMenuRegBean,function(opcionMenuReg) {
		     dwr.util.addOptions('tipoDisposicionCredito',opcionMenuReg,  'codigoOpcion', 'descripcion');
			});
  	//Combo para tipo MOnedas

  	dwr.util.removeAllOptions('tipoMoneda');
  		
  		dwr.util.addOptions('tipoMoneda', {"0":'SELECCIONAR'}); 
	
		monedasServicio.listaCombo(3, function(monedas){
		dwr.util.addOptions('tipoMoneda', monedas, 'monedaID', 'descripcion');
		});

}


// -- FUNCIONES ---------------------- 

function llenaComboAnios(fechaActual){
	   var anioActual 	= fechaActual.substring(0, 4);
	   var mesActual 	= parseInt(fechaActual.substring(5, 7));
	   var numOption 	= 4;
	  
	   for(var i=0; i<numOption; i++){
		   $("#anio").append('<option value="'+anioActual+'">' + anioActual + '</option>');
		   anioActual = parseInt(anioActual) - 1;
	   }
	   
	   $("#mes option[value="+ mesActual +"]").attr("selected",true);
}


$('#mes').change(function (){
	   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
	   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
	   var anioSeleccionado = $('#anio').val();
	   inicializaForma('formaGenerica', 'mes');
	   limpiarCombos();
	   deshabilitaBoton('agrega');
	   deshabilitaBoton('modifica');
	   deshabilitaBoton('elimina');
	   
	   if((parseInt(this.value) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
		   mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
		   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
		   consultaRegistroRegulatorioD0842();
		   this.focus();

	   }else{

		   consultaRegistroRegulatorioD0842();
	   }
});

$('#anio').change(function (){
	   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
	   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
	   var anioSeleccionado = $('#anio').val();
	   var mesSeleccionado 	= $('#mes').val();
	   inicializaForma('formaGenerica', 'mes');
	   limpiarCombos();
	   deshabilitaBoton('agrega');
	   deshabilitaBoton('modifica');
	    deshabilitaBoton('elimina');
	   
	   if((parseInt(mesSeleccionado) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
		   mensajeSis("El Año Indicado es Incorrecto.");
		   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
		   consultaRegistroRegulatorioD0842();
		   this.focus();
	   }else{
		   consultaRegistroRegulatorioD0842();
	   }
});



function consultaRegistroRegulatorioD0842(){	
	var anio 	= $('#anio').val();
	var mes  	= $('#mes').val();
	var params 	= {};
	params['tipoLista'] = 1;
	params['anio'] 		= anio;
	params['mes']		= mes;
}
//consulta  validaRegistro
 function validaRegistro(idControl) {

 	var jqRegistro = eval("'#" + idControl + "'");
	var numRegistro = $(jqRegistro).val();
	setTimeout("$('#cajaLista').hide();", 200);	
	var RegulatorioBeanCon = {
				'anio':$('#anio').val(),
				'mes':$('#mes').val(),
				'identificadorID':$('#identificadorID').val()
			};
 	if(isNaN(numRegistro) ){
 		mensajeSis('Sólo Números');
 		$('#identificadorID').focus();
 		$('#identificadorID').val('');
 		inicializaForma('formaGenerica', 'identificadorID');
 		limpiarCombos();
 	}else{
 		if(numRegistro =='0' ){
			habilitaBoton('agrega');
			deshabilitaBoton('modifica');
			deshabilitaBoton('elimina');
			inicializaForma('formaGenerica', 'identificadorID');
			limpiarCombos();
 		}else if(numRegistro !=''){
 			regulatorioD0842Servicio.consulta(1,RegulatorioBeanCon,{ async: false, callback:function(regulatorio0842){
 				
						if(regulatorio0842!=null){	
							dwr.util.setValues(regulatorio0842);
							consultaPais(regulatorio0842.paisEntidadExtranjera);
							consultaEntidad(regulatorio0842.numeroIden);	
							consultaTasaReferencia(regulatorio0842.tasaIntReferencia);
							if(regulatorio0842.tipoGarantia==0){
								deshabilitaControl('montoGarantia');
								deshabilitaControl('fechaValuacionGaran');
							}else{
								habilitaControl('montoGarantia');
								habilitaControl('fechaValuacionGaran');
							}
							deshabilitaBoton('agrega');
 							habilitaBoton('modifica');	
 							habilitaBoton('elimina');	
 							agregaFormatoControles('formaGenerica');																	
						}else{
							mensajeSis("No Existe el Número de Registro Para el Periodo Seleccionado"); 
							$('#identificadorID').val('');
							$('#identificadorID').focus();
							inicializaForma('formaGenerica', 'identificadorID');
							limpiarCombos();

						}   
					} 						
				});
 		}
	}
	}
 //consulta Pais 
 function consultaPais(idControl) {
		var numPais = $('#paisEntidadExtranjera').val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais) && esTab) {
			paisesServicio.consultaPaises(conPais, numPais,function(pais) {
				if (pais != null) {
					$('#nomPais').val(pais.nombre);
				}
				else {
					mensajeSis("No Existe el País");
					$('#'+idControl).focus();
					$('#paisEntidadExtranjera').val('');
					$('#nomPais').val('');
				}
			});
		}else{
			if(isNaN(numPais) ){
				mensajeSis("No Existe el País");
				$('#paisEntidadExtranjera').val('');
				$('#nomPais').val('');
				$('#paisEntidadExtranjera').focus();
				
			}
		}
	

	}

function consultaEntidad(idControl){

	var jqEntidad = eval("'#" + idControl + "'");
	var numEntidad = $('#numeroIden').val();
	setTimeout("$('#cajaLista').hide();", 200);

	var opcionMenuRegBean = {
			'menuID' 		: catMenuRegulatorio.Instituciones,
			'codigoOpcion' 	: numEntidad
	};
	tipoConEntidad = 3;
	if (!isNaN(numEntidad)  && numEntidad != '') {
		opcionesMenuRegServicio.consulta(tipoConEntidad,opcionMenuRegBean,function(entidad) {
				if (entidad != null) {
					
					$('#nomOtorgante').val(entidad.descripcion);
					$('#numeroIden').val(entidad.codigoOpcion);
				} else {
						mensajeSis("No Existe la Entidad Financiera.");
						$('#numeroIden').val('');
						$('#nomOtorgante').val('');
						$(jqEntidad).focus();
				}
			});
	} else{
		$('#numeroIden').val('');
		$('#nomOtorgante').val('');
	}
}

function consultaTasaReferencia(idControl){
	setTimeout("$('#cajaLista').hide();", 200);
	var tasaReferencia = $('#tasaIntReferencia').val();
	var opcionMenuRegBean = {
			'codigoOpcion' 	: tasaReferencia
	};

	if (!isNaN(tasaReferencia)  && tasaReferencia != '') {
		opcionesMenuRegServicio.consulta(8,opcionMenuRegBean,function(tasaReferen) {
				if (tasaReferen != null) {
					
					$('#desTasaRef').val(tasaReferen.descripcion);
					$('#tasaIntReferencia').val(tasaReferen.codigoOpcion);
				} else {
						mensajeSis("No Existe la Tasa de Referencia.");
						$('#tasaIntReferencia').val('');
						$('#desTasaRef').val('');
						$('#tasaIntReferencia').focus();
				}
			});
	} else{
		$('#tasaIntReferencia').val('');
		$('#desTasaRef').val('');
	}
}
function validarTasa(controlID, valor){
	var re = /,/g;
	var cantidad= valor;
	var secciones = cantidad.toString().split(".");
	var nuevacantidad = secciones[0].replace(re, '');
	var longitudCantidad = nuevacantidad.length;
	var valorMaximo = 10;
	if (!/^[0-9]*(\.[0-9]+)?$/.test(nuevacantidad)){
	mensajeSis("Número inválido");
	    $('#'+controlID).focus();
	    $('#'+controlID).val('0.0');
	}  
	if(longitudCantidad > valorMaximo){
		mensajeSis("Porcentaje Incorrecto");
		$('#'+controlID).focus();
		    $('#'+controlID).val('0.0');
	}
}

function validaClasificasion(campo){
	var plazo= $('#clasificaCortLarg').val();

	if(plazo == '' || plazo == null){
		mensajeSis("Seleccione una Clasificación del Plazo");
		$('#clasificaCortLarg').focus();
		$('#clasificaConta').val('');
	}

}
function asignaPlazo(){
	var plazo= $('#clasificaCortLarg').val();
	dwr.util.removeAllOptions('clasificaConta'); 
  		dwr.util.addOptions('clasificaConta', {'':'SELECCIONAR'}); 
  		opcionMenuRegBean = {
						'plazo' 	: plazo
						};
  		opcionesMenuRegServicio.listaCombo(12,opcionMenuRegBean,function(opcionMenuReg) {
		     dwr.util.addOptions('clasificaConta',opcionMenuReg,  'codigoOpcion', 'descripcion');
			});
}

function generaReporte(tipoReporte){
		   var anio = $('#anio').val();
		   var mes = $('#mes').val();
		   var url='';

		   url = 'reporteRegulatorioD0842.htm?tipoReporte=' + tipoReporte + '&anio='+anio+ '&mes=' + mes;
		   window.open(url);
		   
	   };


function soloNum(campo,idcampo){
	if (!/^([0-9])*$/.test(campo.value)){
    	mensajeSis("Solo Números");
   	    $('#'+idcampo).focus();
  	    $('#'+idcampo).val('');
    }   
  }

function soloLetrasYNum(campo,idcampo){
	 if (!/^([a-zA-Z0-9])*$/.test(campo.value)){
    	mensajeSis("Solo caracteres alfanuméricos");
   	    $('#'+idcampo).focus();
  	    $('#'+idcampo).val('');
    }
      
  }

  function ocultaCaja(campo){
	setTimeout("$('#cajaLista').hide();", 200);
  }
   
function soloCantidad(campo,idcampo){
	var re = /,/g;
	var cantidad= campo.value;
	var secciones = cantidad.toString().split(".");
	var nuevacantidad = secciones[0].replace(re, '');
	var longitudCantidad = nuevacantidad.length;
	var valorMaximo = 19;
	if (!/^[0-9]*(\.[0-9]+)?$/.test(nuevacantidad)){
	mensajeSis("Número inválido");
	    $('#'+idcampo).focus();
	    $('#'+idcampo).val('0.0');
	}  
	if(longitudCantidad > valorMaximo){
		mensajeSis("La Cantidad Ingresada es Mayor al Valor Permitido");
		$('#'+idcampo).focus();
		    $('#'+idcampo).val('0.0');
	}
}

function valGarantia(campo){
	var valorGarantia = campo;
	if(valorGarantia==0){
		deshabilitaControl('montoGarantia');
		deshabilitaControl('fechaValuacionGaran');
		$('#montoGarantia').val('0.0');
		$('#fechaValuacionGaran').val('');
	}else{
		habilitaControl('montoGarantia');
		habilitaControl('fechaValuacionGaran');
		$('#montoGarantia').val('');
		$('#fechaValuacionGaran').val('');
	}

}


function limpiarCombos(){
	$('#tipoPrestamista').val('');
	$('#clasificaConta').val('');
	$('#periodo').val('');
	$('#tipoTasa').val('');
	$('#operaDifTasaRefe').val('');
	$('#tipoMoneda').val('');
	$('#tipoDisposicionCredito').val('');
	$('#periodoPago').val('');
	$('#destino').val('');
	$('#clasificaCortLarg').val('');
	$('#pagoAnticipado').val('');
	$('#tipoGarantia').val('');
}
function funcionExito(){
	inicializaForma('formaGenerica', 'identificadorID');	
	deshabilitaBoton('agrega');
	habilitaBoton('modifica');
	habilitaBoton('elimina');
	limpiarCombos();

}
 
 function funcionError(){
	agregaFormatoControles('formaGenerica');
 }
// --------------- funcion para validar la fecha --------------------------
function esFechaValida(fecha,idfecha) {
	if (fecha != undefined && fecha != "") {
		
		var mes = fecha.substring(5, 7) * 1;
		var dia = fecha.substring(8, 10) * 1;
		var anio = fecha.substring(0, 4) * 1;

		switch (mes) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			numDias = 31;
			break;
		case 4:
		case 6:
		case 9:
		case 11:
			numDias = 30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)) {
				numDias = 29;
			} else {
				numDias = 28;
			}
			;
			break;
		default:
			mensajeSis("Formato de Fecha no Valido (aaaa-mm-dd)");
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
		return false;
		}
		if (dia > numDias || dia == 0) {
			mensajeSis("Formato de Fecha no Valido (aaaa-mm-dd)");
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
			return false;
		}
		return true;
	}
}

// Valida si fecha > fecha2: true else false
	function mayor(fecha, fecha2){ 
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);



		if (xAnio > yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes > yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia > yDia){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}else{
				return false ;
			}
		} 
	}

function comprobarSiBisisesto(anio) {
	if ((anio % 100 != enteroCero) && ((anio % 4 == enteroCero) || (anio % 400 == enteroCero))) {
		return true;
	} else {
		return false;
	}
}
