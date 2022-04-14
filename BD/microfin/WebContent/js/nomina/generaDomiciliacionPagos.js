$(document).ready(function() {
	esTab = false;
	
	var parametroBean = consultaParametrosSession();
	$('#fechaSistema').val(parametroBean.fechaAplicacion);
	var tipoTransaccion = {
		'generar'	: 2
	};
	
	var catTipoConsultaInstitucion = {
		'principal': 1
	};
	
	var catTipoConsulta = {
		'clientes'		: 1,
		'folio'			: 2,
		'domiciliacionPagos'	: 4,
	};
	
	
	var catTipoReporte = { 
		'Excel'	: 1 
	};
	
	var repLisReporte = {
		'generaExcel' : 4 
	};
	
	var Constantes = {
		"SI" 	: "S",
		"NO" 	: "N",	
	};
	 
	 $.validator.setDefaults({
		submitHandler: function(event) { 	
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'tipoTransaccion','funcionExito', 'funcionError');  
    	}
     });
		
	/**
	 * METODOS  Y MANEJO DE EVENTOS
	 */
	agregaFormatoControles('formaGenerica');

	$('#esNominaSI').attr("checked",true);
	$('#esNominaSI').focus();
	deshabilitaBoton('generarExcel');
	deshabilitaBoton('generarLayout');
	deshabilitaBoton('buscar');
	deshabilitaControl('busqueda');	
	$('#trBuscar').hide();
	$('#trGenerar').hide();

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
	 * Se valida cuando se selecciona la opción Es Nómina: SI
	 */
	$('#esNominaSI').click(function() { 
		$('#esNominaSI').attr("checked",true);
		$('#esNominaNO').attr("checked",false);
		$('#nomina').show();
		$('#institNominaID').show();
		$('#institNominaID').val('');
		$('#nombreEmpresa').show();
		$('#nombreEmpresa').val('');
		$('#convenio').show();
		$('#convenioNominaID').show();
		$('#convenioNominaID').val(0);
		$('#clienteID').val('');
		$('#nombreCliente').val("");
		$('#gridGeneraDomicialiacionPagos').html("");
		$('#gridGeneraDomicialiacionPagos').hide();
		deshabilitaBoton('generarExcel');
		deshabilitaBoton('generarLayout');
		deshabilitaBoton('buscar');
		$('#folioID').val('');
		$('#frecuencia').val('');
		deshabilitaControl('busqueda');	
		$('#trBuscar').hide();
		$('#trGenerar').hide();

	});
	
	/**
	 * Se valida cuando se selecciona la opción Es Nómina: NO
	 */
	$('#esNominaNO').click(function() { 
		$('#esNominaNO').attr("checked",true);
		$('#esNominaSI').attr("checked",false);
		$('#nomina').hide();
		$('#institNominaID').hide();
		$('#institNominaID').val('');
		$('#nombreEmpresa').hide();
		$('#nombreEmpresa').val('');
		$('#convenio').hide();
		$('#convenioNominaID').hide();
		$('#convenioNominaID').val(0);
		$('#clienteID').val('');
		$('#nombreCliente').val("");
		$('#gridGeneraDomicialiacionPagos').html("");
		$('#gridGeneraDomicialiacionPagos').hide();
		deshabilitaBoton('generarExcel');
		deshabilitaBoton('generarLayout');
		deshabilitaBoton('buscar');
		$('#folioID').val('');
		$('#frecuencia').val('');
		deshabilitaControl('busqueda');	
		$('#trBuscar').hide();
		$('#trGenerar').hide();
	});
	
	/**
	 * Lista de Instituciones de Nomina
	 */
	$('#institNominaID').bind('keyup',function(e){
		lista('institNominaID', '2', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});
		

	/**
	 * Consulta de Instituciones de Nomina
	 */
	$('#institNominaID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab) {
			consultaInstitucionNomina(this.id);
		}
	});
	
	/**
	 * Consulta si el Convenio realiza el Cobro de Domiciliacion de Pagos
	 */
	$('#convenioNominaID').change(function() {
		consultaDomiciliaPagos(this.id);
	});
	
	/**
	 * Lista de Clientes
	 */
	$('#clienteID').bind('keyup',function(e){

		if($('#esNominaSI').is(':checked')){	
			var esNomina = $('#esNominaSI').val();
		}else{
			var esNomina = $('#esNominaNO').val();
		}	
	
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "esNomina";
		camposLista[1] = "institNominaID";
		camposLista[2] = "convenioNominaID";
		camposLista[3] = "nombreCliente";
		
		parametrosLista[0] = esNomina;
		parametrosLista[1] = $('#institNominaID').val();
		parametrosLista[2] = $('#convenioNominaID').val();
		parametrosLista[3] = $('#clienteID').val();
		
		lista('clienteID', '2', '1', camposLista, parametrosLista, 'listaDomiciliacionPagos.htm');

	});
	
	/**
	 * Consulta de Clientes
	 */ 	
	$('#clienteID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
	    if(esTab){
	    	consultaClientes(this.id);
	    }
	});
	
	/**
	 * Consulta de Folio
	 */
	$('#folioID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
	    if(esTab){
	    	consultaDomiciliacionFolio(this.id);
	    }
	});
	
	/**
	 * Consulta de Domiciliación de Pagos
	 */
	$('#agregar').click(function() { 
		bloquearPantalla();
		if($('#esNominaSI').is(':checked')){
			if($('#institNominaID').val() == ""){
				mensajeSis("Especifique Empresa de Nomina.");
				$('#institNominaID').focus();
				$('#institNominaID').select();
			}
			
			else if($('#institNominaID').val() > 0){
				if($('#convenioNominaID').val() == 0){
					mensajeSis("Seleccione el Número de Convenio.");
					$('#convenioNominaID').focus();
					$('#convenioNominaID').select();
				}
				else if($('#clienteID').val() == ""){
					mensajeSis("Especifique el Cliente.");
					$('#clienteID').focus();
					$('#clienteID').select();
				}
				else{
					consultaGridDomiciliacionPagos();
				}
			}
			
			else{
				consultaGridDomiciliacionPagos();
			}
		}
		
		if($('#esNominaNO').is(':checked')){
			if($('#clienteID').val() == ""){
				mensajeSis("Especifique el Cliente.");
				$('#clienteID').focus();
				$('#clienteID').select();
			}
			else{
				consultaGridDomiciliacionPagos();
			}
		}

	});
	
	/**
	 * Buscar Domiciliación de Pagos
	 */
	$('#buscar').click(function(){
		bloquearPantalla();
		if($('#busqueda').val() == ""){
			mensajeSis("Especifique la Búsqueda.");
			$('#busqueda').focus();
			$('#busqueda').select();
		}
		else{
			busquedaDomiciliacionPagos();
		}
	});
	
	/**
	 * Busqueda de Nombre del Cliente
	 */
	$('#busqueda').blur(function(){
		 if(esTab){
			 if($('#busqueda').val() == ''){
				 bloquearPantalla();
				 busquedaDomiciliacionPagos();
			 }
		}
	});
	
	/**
	 * Generar Layout Domiciliacion de Pagos
	 */
	$('#generarLayout').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.generar);
	});
	
	/**
	 * Generar Layout Domiciliacion de Pagos
	 */
	$('#generarExcel').click(function() {
		generaReporte();
	});
	
	/**
	 * VALIDACIONES DE LA FORMA
	 */
	$('#formaGenerica').validate({			
		rules: {
			empresaNominaID :{
				required:true
			}
		},		
		messages: {
			empresaNominaID :{
				required:'Especifique Empresa de Nómina.'
			}
		}		
	});

	/**
	 * Consulta de Instituciones de Nomina
	 */
	function consultaInstitucionNomina(idControl) {
		var jqInstitucionID = eval("'#" + idControl + "'");
		var institNominaID = $(jqInstitucionID).val();
		var institucionBean = {
			'institNominaID': institNominaID				
		};
		$('#convenioNominaID').val(0);
		$('#clienteID').val('');
		$('#nombreCliente').val('');
		$('#gridGeneraDomicialiacionPagos').html("");
		$('#gridGeneraDomicialiacionPagos').hide();
		deshabilitaBoton('generarExcel');
		deshabilitaBoton('generarLayout');
		deshabilitaBoton('buscar');
		deshabilitaControl('busqueda');	
		$('#folioID').val('');
		$('#frecuencia').val('');
		$('#trBuscar').hide();
		$('#trGenerar').hide();
		
		if(institNominaID == 0){
			$('#institNominaID').val(0);
			$('#nombreEmpresa').val("TODAS");
			$('#convenioNominaID').val(0);
			$('#clienteID').val(0);
			$('#nombreCliente').val("TODOS");
			dwr.util.removeAllOptions('convenioNominaID'); 
			dwr.util.addOptions('convenioNominaID', {0:'SELECCIONAR'}); 
			$('#folioID').val('');
		}
		if(institNominaID != '' && !isNaN(institNominaID) && institNominaID > 0){
		institucionNomServicio.consulta(catTipoConsultaInstitucion.principal,institucionBean,function(institNomina) {
			if(institNomina!= null){
				$('#institNominaID').val(institNomina.institNominaID);
				$('#nombreEmpresa').val(institNomina.nombreInstit);
				$('#convenioNominaID').val(0);
				$('#clienteID').val('');
				$('#nombreCliente').val('');
				$('#folioID').val('');
				consultaConveniosEmpresaNomina();
				}
			else {
				mensajeSis("La Empresa de Nómina No Existe.");
				$('#institNominaID').focus();
				$('#institNominaID').val('');
				$('#nombreEmpresa').val('');
				$('#convenioNominaID').val(0);
				dwr.util.removeAllOptions('convenioNominaID'); 
				dwr.util.addOptions('convenioNominaID', {0:'SELECCIONAR'}); 
				}
			});
		}
	}
	
	/**
	 * Consulta de Convenios de Empresa de Nómina
	 */
	function consultaConveniosEmpresaNomina() {
		var institNominaID = $('#institNominaID').val();
		bean = {
			'institNominaID': institNominaID
		};
		
		dwr.util.removeAllOptions('convenioNominaID'); 
		dwr.util.addOptions('convenioNominaID', {0:'SELECCIONAR'}); 

		generaDomiciliacionPagosServicio.listaCombo(2, bean,function(convenios){
			if(convenios !=''){
				dwr.util.addOptions('convenioNominaID', convenios, 'convenioNominaID', 'descripcion');		
			}
		});
	}

	/**
	 * Consulta de Clientes
	 */ 	
	function consultaClientes(idControl){
		var jqClienteID = eval("'#" + idControl + "'");
		var clienteID = $(jqClienteID).val();
		
		if($('#esNominaSI').is(':checked')){	
			var esNomina = $('#esNominaSI').val();
		}else{
			var esNomina = $('#esNominaNO').val();
		}	
		
		var bean = {
			'clienteID': clienteID,
			'esNomina' : esNomina,
			'institNominaID' : $('#institNominaID').val(),
			'convenioNominaID' : $('#convenioNominaID').val(),
		};
		
		$('#gridGeneraDomicialiacionPagos').html("");
		$('#gridGeneraDomicialiacionPagos').hide();
		deshabilitaBoton('generarExcel');
		deshabilitaBoton('generarLayout');
		deshabilitaBoton('buscar');
		deshabilitaControl('busqueda');	
		$('#folioID').val('');
		$('#frecuencia').val('');
		$('#trBuscar').hide();
		$('#trGenerar').hide();
		
		if(clienteID == 0){
			$('#clienteID').val(0);
			$('#nombreCliente').val("TODOS");
		}
		if(clienteID != '' && !isNaN(clienteID) && clienteID > 0){
		generaDomiciliacionPagosServicio.consulta(catTipoConsulta.clientes,bean,function(clientes) {
			if(clientes != null){
				$('#clienteID').val(clientes.clienteID);
				$('#nombreCliente').val(clientes.nombreCliente);
			}
			else{
				mensajeSis("El Cliente No Existe para Realizar la Domiciliación de Pagos.");
				$('#clienteID').focus();
				$('#clienteID').val('');
				$('#nombreCliente').val('');
			  }
			});
		}
	}
	
	/**
	 * Consulta de Información Domiciliación de Pagos por Folio
	 */ 	
	function consultaDomiciliacionFolio(idControl){
		var jqFolioID = eval("'#" + idControl + "'");
		var folioID = $(jqFolioID).val();
		var bean = {
			'folioID': folioID				
		};
		
		if(folioID == '' || folioID == 0){
			$('#gridGeneraDomicialiacionPagos').html("");
			$('#gridGeneraDomicialiacionPagos').hide();
			deshabilitaBoton('generarExcel');
			deshabilitaBoton('generarLayout');
			deshabilitaBoton('buscar');
			deshabilitaControl('busqueda');	
			$('#trBuscar').hide();
			$('#trGenerar').hide();

		}
		if(folioID != '' && !isNaN(folioID) && folioID > 0){
		bloquearPantalla();
		generaDomiciliacionPagosServicio.consulta(catTipoConsulta.folio,bean,function(folios) {
			if(folios!= null){
				$('#contenedorForma').unblock(); 
				$('#numTransaccion').val(folios.numTransaccion);
				consultaDomiciliacionPagosActual();
			}
			else{
				$('#contenedorForma').unblock(); 
				$('#numTransaccion').val('');
				$('#gridGeneraDomicialiacionPagos').html("");
				$('#gridGeneraDomicialiacionPagos').hide();
				deshabilitaBoton('generarExcel');
				deshabilitaBoton('generarLayout');
				deshabilitaBoton('buscar');
				deshabilitaControl('busqueda');	
				$('#trBuscar').hide();
				$('#trGenerar').hide();
				}
			});
		}
	}
	
	
	/**
	 * Consulta si el Convenio realiza el Cobro de Domiciliacion de Pagos
	 */ 	
	function consultaDomiciliaPagos(idControl){
		var jqConvenioNominaID = eval("'#" + idControl + "'");
		var convenioNominaID = $(jqConvenioNominaID).val();
		var bean = {
			'convenioNominaID'	: convenioNominaID,
			'institNominaID'	: $('#institNominaID').val()
		};

		if(convenioNominaID != '' && !isNaN(convenioNominaID) && convenioNominaID > 0){
		generaDomiciliacionPagosServicio.consulta(catTipoConsulta.domiciliacionPagos,bean,function(domiciliacion) {
			if(domiciliacion != null){
				if(domiciliacion.domiciliacionPagos == 'N'){
					mensajeSis("El Número de Convenio no realiza Domiciliación de Pagos.");
					$('#convenioNominaID').focus();
					$('#convenioNominaID').val("0");
					}
				}
			});
		}
	}
	
	/**
	 * Función para Generar el Reporte en Excel
	 */
	function generaReporte(){
		var tipoReporte 	= catTipoReporte.Excel;
		var tipoLista 		= repLisReporte.generaExcel;
		  		
		var nombreInstitucion 	= parametroBean.nombreInstitucion;
		var fechaEmision 		= parametroBean.fechaSucursal;
		var nomUsuario			= parametroBean.claveUsuario;
		  
		var pagina ='generaDomiciliacionPagosRep.htm?numTransaccion='+$('#numTransaccion').val()
					+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista
					+'&nomUsuario='+nomUsuario+'&fechaSistema='+fechaEmision
					+'&nombreInstitucion='+nombreInstitucion;
		window.open(pagina);
	}
	
	
	});// fin document.ready
	
	/**
	 * Consulta para el grid de Domiciliación de Pagos al Agregar
	 */
	function consultaGridDomiciliacionPagos(){
		if($('#esNominaSI').is(':checked')){	
			var esNomina = $('#esNominaSI').val();
		}else{
			var esNomina = $('#esNominaNO').val();
		}	
		
		var params = {};
	  	params['esNomina'] 			= esNomina;
	  	params['institNominaID'] 	= $('#institNominaID').val();
	  	params['convenioNominaID'] 	= $('#convenioNominaID').val();
		params['clienteID']			= $('#clienteID').val();
		params['frecuencia']		= $('#frecuencia').val();
		params['tipoLista'] 		= 3;
		
		$.post("generaDomiciliacionPagosGrid.htm", params, function(data){	
			if(data.length >0) {
				$('#contenedorForma').unblock(); 
				$('#gridGeneraDomicialiacionPagos').html(data);
				$('#gridGeneraDomicialiacionPagos').show();
				habilitaBoton('generarExcel');
				habilitaBoton('generarLayout');
				habilitaBoton('buscar');
				agregaMonedaFormat();
				consultaNumTransaccion();
				consultaNumFolio();
				habilitaControl('busqueda');
				$('#trBuscar').show();
				$('#trGenerar').show();
				
				consultaRegistros();
				
			}else{
				$('#gridGeneraDomicialiacionPagos').html("");
				$('#gridGeneraDomicialiacionPagos').show();
				deshabilitaBoton('generarExcel');
				deshabilitaBoton('generarLayout');
				deshabilitaBoton('buscar');
				deshabilitaControl('busqueda');
				$('#trBuscar').hide();
				$('#trGenerar').hide();
			}
		});
	}
	
	/**
	 * Consulta para el grid de Domiciliación de Pagos al Eliminar
	 */
	function consultaDomiciliacionPagosActual(){
		if($('#esNominaSI').is(':checked')){	
			var esNomina = $('#esNominaSI').val();
		}else{
			var esNomina = $('#esNominaNO').val();
		}	
		
		var params = {};
	  	params['esNomina'] 			= esNomina;
	  	params['institNominaID'] 	= $('#institNominaID').val();
	  	params['convenioNominaID'] 	= $('#convenioNominaID').val();
		params['clienteID']			= $('#clienteID').val();
		params['frecuencia']		= $('#frecuencia').val();
		params['numTransaccion']	= $('#numTransaccion').val();
		params['tipoLista'] 		= 4;
		
		$.post("generaDomiciliacionPagosGrid.htm", params, function(data){	
			if(data.length >0) {
				$('#gridGeneraDomicialiacionPagos').html(data);
				$('#gridGeneraDomicialiacionPagos').show();
				habilitaBoton('generarExcel');
				habilitaBoton('generarLayout');
				habilitaBoton('buscar');
				agregaMonedaFormat();
				habilitaControl('busqueda');	
				$('#trBuscar').show();
				$('#trGenerar').show();

			}else{
				$('#gridGeneraDomicialiacionPagos').html("");
				$('#gridGeneraDomicialiacionPagos').show();
				deshabilitaBoton('generarExcel');
				deshabilitaBoton('generarLayout');
				deshabilitaBoton('buscar');
				deshabilitaControl('busqueda');
				$('#trBuscar').hide();
				$('#trGenerar').hide();
			}
		});
	}
	
	/**
	 * Busqueda de Domiciliación de Pagos
	 */
	function busquedaDomiciliacionPagos(){
		if($('#esNominaSI').is(':checked')){	
			var esNomina = $('#esNominaSI').val();
		}else{
			var esNomina = $('#esNominaNO').val();
		}	
		
		var params = {};
	  	params['esNomina'] 			= esNomina;
	  	params['institNominaID'] 	= $('#institNominaID').val();
	  	params['convenioNominaID'] 	= $('#convenioNominaID').val();
		params['clienteID']			= $('#clienteID').val();
		params['frecuencia']		= $('#frecuencia').val();
		params['folioID']		    = $('#folioID').val();
		params['busqueda']			= $('#busqueda').val();
		params['numTransaccion']	= $('#numTransaccion').val();
		params['tipoLista'] 		= 5;
		
		$.post("generaDomiciliacionPagosGrid.htm", params, function(data){	
			if(data.length >0) {
				$('#contenedorForma').unblock(); 
				$('#gridGeneraDomicialiacionPagos').html(data);
				$('#gridGeneraDomicialiacionPagos').show();
				habilitaBoton('generarExcel');
				habilitaBoton('generarLayout');
				habilitaBoton('buscar');
				agregaMonedaFormat();	
				habilitaControl('busqueda');
				$('#trBuscar').show();
				$('#trGenerar').show();
			}else{
				$('#gridGeneraDomicialiacionPagos').html("");
				$('#gridGeneraDomicialiacionPagos').show();
				deshabilitaBoton('generarExcel');
				deshabilitaBoton('generarLayout');
				deshabilitaBoton('buscar');
				deshabilitaControl('busqueda');
				$('#trBuscar').hide();
				$('#trGenerar').hide();
			}
		});
	}
	
	/**
	 * Función para agregar formato Moneda a los Montos Exigibles
	 */
	function agregaMonedaFormat(){ 
	 $('input[name=listaMontoExigible]').each(function() {		
			numero= this.id.substr(13,this.id.length);
			varMontoExigigle = eval("'#montoExigible"+numero+"'");
			$(varMontoExigigle).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		});	 
	 }
	
	/**
	 * Función para consultar el Número de Transacción
	*/
    function consultaNumTransaccion(){
	 	var numTransaccion = $('#numTransaccionGrid1').val();
	 	$('#numTransaccion').val(numTransaccion);
	 }
    
    /**
	 * Función para consultar el Número de Folio Interno del Layout a Generar la Domiciliación de Pagos
	*/
    function consultaNumFolio(){
	 	var numFolio = $('#foliosID1').val();
		 $('#folioID').val(numFolio);
	 }

    /**
     * Función para eliminar el Detalle de Domiciliación de Pagos
     */
	function eliminaDetalle(consecutivoID){
		var bajaDomiciliacionPagos = 1;
		var bean = {
			'numTransaccion'	:$('#numTransaccion').val(),
			'consecutivoID'		:consecutivoID
		};
		bloquearPantalla();
		generaDomiciliacionPagosServicio.bajaDomiciliacionPagos(bajaDomiciliacionPagos, bean, function(mensajeTransaccion) {
			if(mensajeTransaccion!=null){
				$('#contenedorForma').unblock(); 
				consultaDomiciliacionPagosActual();

			}else{				
				mensajeSis("Existió un Error al eliminar el Detalle de Domiciliación de Pagos.");			
			}
		});
	}
	
	
	/**
	 * Función para obtener el Total de Filas
	 */
	function consultaFilas(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
			totales++;
			
		});
		return totales;
	}
	
	/**
	 * Función para validar los registros del Grid
	 */
	function consultaRegistros(){
		var numFilas = consultaFilas();
		if(numFilas == 0){
			mensajeSis("No Existe Información con los Filtros Especificados.");
			$('#gridGeneraDomicialiacionPagos').html("");
			$('#gridGeneraDomicialiacionPagos').show();
			deshabilitaBoton('generarExcel');
			deshabilitaBoton('generarLayout');
			deshabilitaBoton('buscar');
			deshabilitaControl('busqueda');
			$('#trBuscar').hide();
			$('#trGenerar').hide();
			$('#agregar').focus();
		}
	}
	
	/**
	 * Función para Bloquear la Pantalla
	 */
	
	function bloquearPantalla(){
		$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
		$('#contenedorForma').block({
			message: $('#mensaje'),
		 	css: {border:		'none',
		 			background:	'none'}
		});
	}
	/**
	 * Función de Éxito
	 */
	function funcionExito(){
		var folio = $('#folioID').val();
		$('#institNominaID').val('');
		$('#nombreEmpresa').val('');
		$('#convenioNominaID').val(0);
		$('#clienteID').val('');
		$('#nombreCliente').val('');
		$('#frecuencia').val('');
		$('#folioID').val('');
		$('#gridGeneraDomicialiacionPagos').html("");
		$('#gridGeneraDomicialiacionPagos').hide();
		deshabilitaBoton('generarExcel');
		deshabilitaBoton('generarLayout');
		deshabilitaBoton('buscar');
		deshabilitaControl('busqueda');	
		$('#trBuscar').hide();
		$('#trGenerar').hide();
		var url ='expGeneraDomiciliacionPagos.htm?consecutivo='+$('#consecutivo').val()+'&folioID='+folio;
		window.open(url);
		
	}
	
	/**
	 * Función de Error
	 */
	function funcionError(){
		
	}
	