$(document).ready(function() {
	
	esTab = false;
	
	var tipoTransaccion = {
		'procesar'    : 1,
		'generar'	  : 2
	};
	
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			var numTransaccion = $('#tipoTransaccion').val();
			if(numTransaccion == tipoTransaccion.procesar){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'generar','funcionExitoProcesar', 'funcionErrorProcesar'); 
			}else{
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'generar','funcionExitoGenerar', 'funcionErrorGenerar'); 
			}
    	}
     });
	
	var parametroBean = consultaParametrosSession();	
	$('#fechaSistema').val(parametroBean.fechaAplicacion);

	$('#adjuntar').focus();
	$('#procesar').hide();
	$('#generar').hide();
	
	/**
	 * METODOS  Y MANEJO DE EVENTOS
	 */
	
	agregaFormatoControles('formaGenerica');	
	
	/**
	 * Pone tap falso cuando toma el foco input text
	 */
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	/**
	 * Pone tab en verdadero cuando se presiona tab
	 */
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	
	/**
	 * Adjuntar Archivos para Procesar Domiciliación de Pagos
	 */
	$('#adjuntar').click(function() {
		subirArchivos();
	});
	
	/**
	 * Procesa Domiciliación de Pagos
	 */
	$('#procesar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.procesar);
	});

	/**
	 * Generar Layout Domiciliacion de Pagos
	 */
	$('#generar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.generar);
	});
	
	
	/**
	 * VALIDACIONES DE LA FORMA
	 */
	$('#formaGenerica').validate({			
		rules: {

		},		
		messages: {

		}		
	});
	
	});// fin document.ready
	
	/**
	 * Consulta para el grid de Domiciliación de Pagos
	 */
	function consultaDomiciliacionProcesar(){
	  var params = {};
	  params['tipoLista'] = 1;
		$.post("procesaDomiciliacionPagosGrid.htm", params, function(data){		
			if(data.length >0) {
				$('#gridProcesaDomiciliacionPagos').html(data);
				$('#gridProcesaDomiciliacionPagos').show();
				$('#procesar').show();
				$('#procesar').focus();
				$('#generar').show();
				agregaMonedaFormat();
				habilitaBoton('procesar');
				deshabilitaBoton('generar');

			}else{
				$('#gridProcesaDomiciliacionPagos').html("");
				$('#gridProcesaDomiciliacionPagos').show();
				$('#procesar').hide();
				$('#generar').hide();
			}
		});
	}

	/**
	 * Función para Subir Archivos para leer el Layout para Procesar Domiciliación de Pagos
	 */
	function subirArchivos() {
	    var url = "archivoDomiciliacionPagos.htm";
	    var leftPosition = (screen.width) ? (screen.width - 850) / 2 : 0;
	    var topPosition = (screen.height) ? (screen.height - 500) / 2 : 0;
	
	    ventanaArchivos = window.open(url, "PopUpSubirArchivo", "width=980,height=320,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0" +
	        "left=" + leftPosition +
	        ",top=" + topPosition +
	        ",screenX=" + leftPosition +
	        ",screenY=" + topPosition);
	}
	
	/**
	 * Función para agregar formato Moneda a los Montos
	 */
	function agregaMonedaFormat(){ 
		$('input[name=listaMonto]').each(function() {		
			numero= this.id.substr(5,this.id.length);
			varMonto = eval("'#monto"+numero+"'");
			$(varMonto).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		});	 
	 
	 	$('input[name=listaMontoPendiente]').each(function() {		
			numero= this.id.substr(14,this.id.length);
			varMonto = eval("'#montoPendiente"+numero+"'");
			$(varMonto).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		});
	 
	 	$('input[name=listaMontoAplicado]').each(function() {		
			numero= this.id.substr(13,this.id.length);
			varMonto = eval("'#montoAplicado"+numero+"'");
			$(varMonto).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		});
	 }
	
	
	/**
	 * Función de Éxito al Procesar Domiciliacion de Pagos
	 */
	function funcionExitoProcesar(){
		deshabilitaBoton('procesar');
		habilitaBoton('generar');
	}
	
	/**
	 * Función de Error al Procesar Domiciliación de Pagos
	 */
	function funcionErrorProcesar(){
		
	}
	
	/**
	 * Función de Éxito al Generar Layout Domiciliacion de Pagos
	 */
	function funcionExitoGenerar(){
		deshabilitaBoton('generar');

		var valor =$('#campoGenerico').val();
		
		var secciones = valor.toString().split("-");
		var consecutivo = secciones[0];
		var folio = secciones[1];
		var transaccion = secciones[2];


		var url ='expProcesaDomiciliacionPagos.htm?consecutivo='+consecutivo+'&folioID='+folio+'&transaccion='+transaccion;
		window.open(url);
	}

	/**
	 * Función de Error al Generar Layout Domiciliacion de Pagos
	 */
	function funcionErrorGenerar(){
		
	}
	
	function recargarGridArchivos() {
	    consultaDomiciliacionProcesar();
	}