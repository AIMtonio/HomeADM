// DECLARACION DE VARIABLES
var parametroBean = consultaParametrosSession();
var nveces=0;
var arrendamientoID = 0;
$(document).ready(function() {
	esTab = false;		
	// Definicion de Constantes y Enums
	var catTipoTransaciones = {
			'grabar' : 1
	};
	
	var catTipoLisArrendamiento = {
			'listaArrendamientos' : 7
	};
	
	var catTipoListaAmortizaciones = {
			'amortizacionesMovCA' : 3
	};
		
	// ------------ Manejo de Eventos -----------------------------------------
	// se llena el combo al cargar la pagina
	consultaConceptosArrenda();
	// INICIALIZAR EL FORMULARIO
	inicializaFormulario();
	$('#tipoListaAmorti').val(catTipoListaAmortizaciones.amortizacionesMovCA);
	
	// EVENTOS
	$(':text').focus(function() {
		esTab = false;
	});
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	//Mostrar la lista de arrendamientos
	$('#arrendaID').bind('keyup',function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
            var parametrosLista = new Array();
            camposLista[0] = "arrendaID";
            parametrosLista[0] = $('#arrendaID').val();
            lista('arrendaID', '2', catTipoLisArrendamiento.listaArrendamientos,camposLista, parametrosLista, 'arrendamientosLista.htm');
        }
	});
	
	// realizar la consulta del arrendamiento seleccionado
	$('#arrendaID').blur(function() {
		if(!isNaN($('#arrendaID').val()) && esTab) {
			consultaArrendamiento(this.id);
		}
	});
	

	// agregar activo ligado y actualizar lista de activos vinculados a un arrendamiento.
	$('#agregar').click(function() {
		nveces = nveces +1;
		if(nveces == 1){
			$('#contenedorBotonGrabar').show();	
			$('#contenedorCargosAbonos').show();
		}
		//agregar registro
		if (verificarCampos()== true){
			agregarDetalle('tablaConceptosCA');
			limpiarConceptosCA();
		}
		verificarNumRenglon('tablaConceptosCA');
		
	});
	
	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaciones.grabar);
		
	});
		
	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoConcepto',
					'accionExitosa','accionNoExitosa');
		}
	});	
	
	//rules
	$('#formaGenerica').validate({
		rules: {
			arrendaID: {
				required : true,
				number: true
			}
		},
		messages: {
			arrendaID: {
				required : 'Especifique el ID del arrendamiento',
				number: 'Sólo números'
			}
		}		
	});
	
	
	
});// fin del Document
	
	// ------------ Metodos -------------------------------------
	// Metodo de consulta por ID de arrendamiento
	function consultaArrendamiento(idControl) {
	    var jqArrenda = eval("'#" + idControl + "'");
	    var arrendaID = $(jqArrenda).val();	   
	    var arrendamientosBean = {
			'arrendaID': arrendaID
		};
	    arrendamientoID = 0;
	    
	    setTimeout("$('#cajaLista').hide();", 200);	  
	    if (arrendaID != '' && !isNaN(arrendaID)) {
	    	camposPorDefault();
	    	reasignaTabIndex('tablaConceptosCA');
	    	reasignaTabIndexGrabar;
			// se realiza consulta al servicio
	    	arrendamientoServicio.consulta(2, arrendamientosBean,function(arrendamiento) {
	    		if (arrendamiento!=null){
	    			arrendamientoID = arrendamiento.arrendaID;
	    			// se llena los campos
	    			$('#nombreCliente').val((arrendamiento.nombreCliente).toUpperCase());	
	    			$('#productoArrendaDescri').val((arrendamiento.productoArrendaDescri).toUpperCase());
	    			$('#estatus').val((arrendamiento.estatus).toUpperCase());
	    			$('#tipoArrenda').val((arrendamiento.tipoArrenda).toUpperCase());
	    			$('#montoArrenda').val(arrendamiento.montoArrenda);
	    			$('#fechaApertura').val(arrendamiento.fechaApertura);
	    			$('#tasaFijaAnual').val(arrendamiento.tasaFijaAnual);
	    			$('#montoResidual').val(arrendamiento.montoResidual);
	    			// cuotas del arrendamiento
	    			consultarCoutas(arrendamientoID);
	    			// movimientos registrados
	    			listaMovimientos(arrendamientoID);
	    			// amortizaciones del arrendamiento
	    			listaAmortizaciones(arrendamientoID);
	    			$('#tipoConcepto').focus();
	    			habilitaBoton('agregar', 'button');
	    			deshabilitaBoton('grabar', 'submit');
	    			agregaFormatoControles('formaGenerica');
	    		}else{
	    			mensajeSis("No se encontró información del Arrendamiento seleccionado.");
	    			inicializaFormulario();
	    			consultaConceptosArrenda();
	    			consultarCoutas(arrendamientoID);
	    			agregaFormatoControles('formaGenerica');
	    			$("#arrendaID").focus();
	    		}
	        });
	    }
	}// fin del metodo: consultaArrendamiento
	
	/**
	 * Lista de movimientos de cargos y abonos de arrendamiento
	 */
	function listaMovimientos(arrendamientoID){
		var numeroError = 0; 
		var mensajeTransaccion = "";
		var params = {};
		params['tipoLista'] = 1;
		params['arrendaID'] = arrendamientoID;
		$.post("movimientosCargoAbono.htm",params,function(data) {
			if(data.length >0 && data != null) { 
				$('#contenedorMovimientos').html(data); 
				
				if ( $("#numeroErrorList").length ) {
					numeroError = $('#numeroErrorList').asNumber();  
					mensajeTransaccion = $('#mensajeErrorList').val();
				}
				
				if(numeroError==0){
					$('#contenedorMovimientos').show();
				}else{
					limpiaGrid('contenedorMovimientos','tablaMovsCA');
					mensajeSisError(numeroError,mensajeTransaccion);
				}
				agregaFormatoControles('formaGenerica');
			}
		});
	}
	
	// Metodo para consultar los conceptos de arrendamiento
	function consultaConceptosArrenda() {
  		dwr.util.removeAllOptions('tipoConcepto'); 
		dwr.util.addOptions('tipoConcepto', {'0':'SELECCIONAR'}); 
		movimientosCargoAbonoArrendaServicio.listaCombo(1, function(act){
			dwr.util.addOptions('tipoConcepto', act, 'tipMovCargoAbonoID', 'descripcion');
		});
		$('#tipoConcepto').val('0').selected = true;
	}
	
	//Metodo de Cuotas por arrendamiento(Amortizaciones)
	function consultarCoutas(arrendaID){
		var arrendaAmortiBean = {
				'arrendaID': arrendaID
			};
		 dwr.util.removeAllOptions('cuota');
		 dwr.util.addOptions('cuota', {'0':'SELECCIONAR'}); 
		 if (arrendaID != '' && !isNaN(arrendaID)) {
			 arrendaAmortiServicio.lista(1, arrendaAmortiBean, function(amortis){
	  				dwr.util.addOptions('cuota', amortis, 'arrendaAmortiID', 'arrendaAmortiID');
	  		});
		 }
		 $('#cuota').val('0').selected = true;
	}
	
	/**
	 * Lista de mortizaciones por ArrendamientoID
	 */
	function listaAmortizaciones(arrendamientoID){
		var numeroError = 0;
		var mensajeTransaccion = "";
		var params = {};
		params['tipoLista'] = 3;
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
					if ($('#siguiente').is(':visible') && $('#anterior').is(':visible')==false){
						$('#filaTotales').hide();	
					}
					if ($('#siguiente').is(':visible')==false && $('#anterior').is(':visible')==false){
						$('#filaTotales').show();	
					}
				}else{
					limpiaGrid('contenedorAmortizaciones','miTabla');
					mensajeSisError(numeroError,mensajeTransaccion);
				}				
			}
			agregaFormatoControles('formaGenerica');
		});
	} //fin metodo: amortizaciones
	
	function verificarCampos(){
		if($('#tipoConcepto').val()== 0){
			$('#tipoConcepto').focus();
			$('#tipoConcepto').select();
			mensajeSis('Seleccione el Tipo de Concepto');
			return false;
		}else if($('#descriConcepto').val()== ''){
			$('#descriConcepto').focus();
			mensajeSis('La Descripcion esta vacia');
			return false;
		} else if($('#cuota').val()== 0){
			$('#cuota').focus();
			$('#cuota').select();
			mensajeSis('Seleccione una Cuota');
			return false;
		}else if($('#naturaleza').val()== 0){
			$('#naturaleza').focus();
			$('#naturaleza').select();
			mensajeSis('Seleccione la Naturaleza del movimiento');
			return false;
		}else if($('#montoConcepto').asNumber() <= 0){
			$('#montoConcepto').focus();
			mensajeSis('El Monto no es valido');
			return false;
		}else  {
			return true;
		}
	}
//inicializa el formulario
function inicializaFormulario(){
	inicializaForma('formaGenerica', 'arrendaID');
	camposPorDefault();
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('agregar', 'button');
	deshabilitaBoton('grabar', 'submit');
	$('#arrendaID').val('');
	$('#arrendaID').focus();
}

//campos en pantalla por default
function camposPorDefault(){
	arrendamientoID = 0;
	nveces = 0;
	// arrendamiento
	$('#tipoArrenda').val('');	
	$('#nombreCliente').val('');
	$('#productoArrendaDescri').val('');	
	$('#estatus').val('');
	$('#montoArrenda').val(0.00);
	$('#fechaApertura').val(parametroBean.fechaAplicacion);
	$('#tasaFijaAnual').val(0.00);
	$('#montoResidual').val(0.00);
	
	// cargos y abonos
	$('#tipoConcepto').val('0').selected = true;
	$('#descriConcepto').val('');
	$('#cuota').val('0').selected = true;
	$('#naturaleza').val('0').selected = true;
	$('#tipoTransaccion').val('');
	$('#montoConcepto').val(0.00);
	
	$('#numTab').val('7');	
	$('#numeroFila').val('0');

	$('#contenedorBotonGrabar').show();
	// tablas
	$('#contenedorCargosAbonos').hide();
	limpiarTablaConceptos('tablaConceptosCA');
	limpiaGrid('contenedorMovimientos','movsLigados');
	limpiaGrid('contenedorAmortizaciones','miTabla');
}
function limpiarConceptosCA(){
	// cargos y abonos
	$('#tipoConcepto').val('0').selected = true;
	$('#descriConcepto').val('');
	$('#cuota').val('0').selected = true;
	$('#naturaleza').val('0').selected = true;
	$('#montoConcepto').val(0.00);
	agregaFormatoControles('formaGenerica');
}

//limpiar Detalle del Grid
function limpiaDetalleGrid(idTabla){
	$('#'+idTabla).find(':tr').each( 
		function(){	    		
			var child = $(this);
			child.remove();
		}
	);
}

//limpiar los Grids
function limpiaGrid(idControl,idTabla){
	$('#'+idControl).html('');
	$('#'+idControl).hide();
	limpiaDetalleGrid(idTabla);
}


/**
 * Agrega un nuevo renglón a la tabla del grid.
 * @param idControl : ID de la tabla.
 */
function agregarDetalle(idControl){	
	var idTab = 'numTab';
	reasignaTabIndex(idControl);
	var numTab = $("#"+idTab).asNumber();
	var numeroFila = ($("#"+idControl+" > tbody > tr").length) - 1;
	numTab++;
	numeroFila++;
	var nuevaFila =
		"<tr id=\"renglon" + numeroFila + "\" name=\"renglon" + numeroFila + "\">" + 
			"<td><input id=\"fechaMovimientoCA" + numeroFila + "\" name=\"fechaMovimiento\" size=\"13\" type=\"text\" value=\"" + parametroBean.fechaAplicacion + "\" readonly=\"readonly\" style=\"text-align: center; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"usuarioMovimientoNomCA" + numeroFila + "\" name=\"usuarioMovimientoNom\" size=\"20\" type=\"text\" value=\"" + parametroBean.nombreUsuario + "\" readonly=\"readonly\" style=\"text-align: center; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"arrendaAmortiIDCA" + numeroFila + "\" name=\"arrendaAmortiIDCA\" size=\"8\" type=\"text\" value=\"" + $('#cuota').val() + "\" readonly=\"readonly\" style=\"text-align: center; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"tipoConceptoDesCA" + numeroFila + "\" name=\"tipoConceptoDes\" size=\"20\" type=\"text\" value=\"" + $('#tipoConcepto option:selected').text() + "\" readonly=\"readonly\" style=\"text-align: center; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"descriConceptoCA" + numeroFila + "\" name=\"descriConceptoCA\" size=\"20\" type=\"text\" value=\"" + $('#descriConcepto').val() + "\" readonly=\"readonly\" style=\"text-align: center; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"montoConceptoCA" + numeroFila + "\" name=\"montoConceptoCA\" size=\"18\" type=\"text\" value=\"" + $('#montoConcepto').val() + "\" readonly=\"readonly\" style=\"text-align: right; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\" esMoneda=\"true\"/></td>" +
			"<td><input id=\"naturalezaDesCA" + numeroFila + "\" name=\"naturalezaDes\" size=\"11\" type=\"text\" value=\"" + $('#naturaleza option:selected"').text() + "\" readonly=\"readonly\" style=\"text-align: center; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td nowrap=\"nowrap\">" +
				"<input type=\"button\" id=\"eliminar" + numeroFila + "\" name=\"eliminar\" value=\"\" class=\"btnElimina\" onclick=\"eliminarParam('renglon" + numeroFila + "')\" tabindex=\"" + numTab + "\"/>" +
				"<input id=\"usuarioMovimientoCA" + numeroFila + "\" name=\"usuarioMovimientoCA\" type=\"hidden\" value=\"" + parametroBean.numeroUsuario+ "\" readonly=\"readonly\" />"+
				"<input id=\"tipoConceptoCA" + numeroFila + "\" name=\"tipoConceptoCA\" type=\"hidden\" value=\"" + $('#tipoConcepto').val() + "\" readonly=\"readonly\"/>"+
				"<input id=\"naturalezaCA" + numeroFila + "\" name=\"naturalezaCA\" type=\"hidden\" value=\"" + $('#naturaleza').val() + "\" readonly=\"readonly\"/>"+
				"<input id=\"arrendID" + numeroFila + "\" name=\"arrendaIDCA\" type=\"hidden\" value=\"" + $('#arrendaID').val() + "\" readonly=\"readonly\"/>"+
			"</td>" +
		"</tr>";
	$('#'+idControl).append(nuevaFila);
	$("#"+idTab).val(numTab);
	$("#numeroFila").val(numeroFila);
	reasignaTabIndexGrabar();
	agregaFormatoControles('formaGenerica');
}

/**
 * Actualizar el número de tabindex de los inputs que se encuentran dentro de la tabla. 
 * @param idTabla : ID de la tabla a actualizar.
 */
function reasignaTabIndex(idTabla){
	var numInicioTabs = 7;
	$('#'+idTabla+' tr').each(function(index){
		if(index>1){
			var elimina="#"+$(this).find("input[name^='eliminar']").attr("id");
			numInicioTabs++;
			$(elimina).attr('tabindex' , numInicioTabs);
		}
	});
	$('#numTab').val(numInicioTabs);
}

function reasignaTabIndexGrabar(){
	var numInicioTabs = $('#numTab').val();
	numInicioTabs++;
	$('#grabar').attr('tabindex' , numInicioTabs);
	$('#numTab').val(numInicioTabs);
} 

function eliminarParam(id) {
	$('#'+id).remove();
	reasignaTabIndex('tablaConceptosCA');
	reasignaTabIndexGrabar();
	verificarNumRenglon('tablaConceptosCA');
}

function verificarNumRenglon(idTabla){
	var numeroFila = ($("#"+idTabla+" > tbody > tr").length) - 1;	
	if(numeroFila<1){
		deshabilitaBoton('grabar', 'submit');
		// oculta encabezados
		$('#contenedorCargosAbonos').hide();
		nveces = 0;
	}else{
		habilitaBoton('grabar', 'submit');
	}
}

function limpiarTablaConceptos(idTabla){
	$('#'+idTabla+' tr').each(function(index){
		if(index>0){
			var child = $(this);
			child.remove();
		}
	});
}

function accionExitosa(){
	limpiarTablaConceptos('tablaConceptosCA');
	verificarNumRenglon('tablaConceptosCA');
	// movimientos registrados
	$('#contenedorMovimientos').html(''); 
	listaMovimientos(arrendamientoID);
	// amortizaciones del arrendamiento
	$('#contenedorAmortizaciones').html(''); 
	listaAmortizaciones(arrendamientoID);
	$('#tipoConcepto').focus();
	agregaFormatoControles('formaGenerica');
	
}

function accionNoExitosa(){
	$('#grabar').focus();
	agregaFormatoControles('formaGenerica');
}