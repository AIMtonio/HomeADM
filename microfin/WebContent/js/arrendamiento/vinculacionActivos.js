// DECLARACION DE VARIABLES
var parametroBean = consultaParametrosSession();
$(document).ready(function() {
	esTab = false;
	tabActivoID = false;
	
	// ------------ Manejo de Eventos -----------------------------------------
	// INICIALIZAR EL FORMULARIO
	inicializaFormulario();
	$('#arrendaID').focus();
	
	// EVENTOS
	$(':text').focus(function() {
		esTab = false;
		tabActivoID = false;
	});
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
			tabActivoID = true;
		}
	});
	
	$(':button, :submit').focus(function() {
	 	esTab = false;
	});
	
	$(':button, :submit').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	//Mostrar la lista de arrendamientos
	$('#arrendaID').bind('keyup',function(e) {
		lista('arrendaID', '2', '3', 'arrendaID', $('#arrendaID').val(), 'listaArrendamientos.htm');
	});
	
	// realizar la consulta del arrendamiento seleccionado
	$('#arrendaID').blur(function() {
		if (esTab) {
 			$("#tipoActivo").focus();
 		}
		if((isNaN($('#arrendaID').val()) || $('#arrendaID').val() == '') && esTab) {
			$('#arrendaID').val("");
			$('#arrendaID').focus();
			inicializaForma('formaGenerica','arrendaID');
			deshabilitaBoton('agregar', 'button');
		} else {
			funcionConsultaArrendamiento(this.id);
		}
	});
	
	//Mostrar la lista de activos
	$('#activoID').bind('keyup',function(e) {
		var camposLista = new Array();
        var parametrosLista = new Array();
        camposLista[0] = "descripcion";
        camposLista[1] = "tipoActivo";
        parametrosLista[0] = $('#activoID').val();
        parametrosLista[1] = $('#tipoActivo').val();
		lista('activoID', '2', '2', camposLista, parametrosLista, 'listaActivosVinculacion.htm');
	});
	
	// realizar la consulta al seleccionar un activo
	$('#activoID').blur(function() {
		if (esTab) {
 			$("#agregar").focus();
 		}
		if((isNaN($('#activoID').val()) || $('#activoID').val() == '') && esTab) {
			$('#activoID').val("");
			$('#activoID').focus();
			inicializaCamposActivo();
			deshabilitaBoton('agregar', 'button');
		} else {
			funcionConsultaActivo(this.id);
		}
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			deshabilitaBoton('agregar', 'button');
			deshabilitaBoton('grabar', 'submit');
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoActivo');
			inicializaCamposActivo();
			$('#tipoActivo').val(0).selected = true;
			habilitaBoton('grabar', 'submit');
		}
    });

	// agregar activo ligado y actualizar lista de activos vinculados a un arrendamiento.
	$('#agregar').click(function() {
		agregarDetalle('tablaActivosLigados');
		inicializaCamposActivo();
		$('#tipoActivo').val(0).selected = true;
	});
	
	// ------------ Metodos -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			arrendaID: 'required',
			activoIDVin: 'required',
		},
		
		messages: {
			arrendaID: 'Especifique número de arrendamiento',
			activoIDVin: 'Especifique número de activo',
		}		
	});
		
});// fin del Document

//inicializa el formulario
function inicializaFormulario(){
	inicializaForma('formaGenerica', 'arrendaID');
	camposDefaultPantalla();
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('agregar', 'button');
}

//campos en pantalla por default
function camposDefaultPantalla(){
	$('#arrendaID').val('');	
	$('#clienteID').val('');
	$('#nombreCliente').val('');	
	$('#tipoArrenda').val('');
	$('#estatus').val('');	
	$('#productoArrendaID').val('');
	$('#productoArrenda').val('');
	$('#fechaApertura').val(parametroBean.fechaAplicacion);
	$('#monto').val('0.0');	
	$('#valorResidual').val('0.0');
	$('#tasaFijaAnual').val('0.0');	
	$('#activoID').val('');
	$('#tipoActivo').val(0).selected = true;
	$('#descripcion').val('');
	$('#subtipoActivo').val('');
	$('#marca').val('');	
	$('#modelo').val('');
	$('#numSerie').val('');	
	$('#numFactura').val('');
	$('#valorFactura').val('0.0');	
	$('#costosAdicionales').val('0.0');
	$('#productoArrenda').val('');
	$('#fechaAdquisicion').val(parametroBean.fechaAplicacion);
}

function inicializaCamposActivo() {
	$('#activoID').val('');
	$('#descripcion').val('');
	$('#subtipoActivo').val('');
	$('#marca').val('');
	$('#modelo').val('');
	$('#numSerie').val('');	
	$('#numFactura').val('');
	$('#valorFactura').val('0.0');	
	$('#costosAdicionales').val('0.0');
	$('#fechaAdquisicion').val(parametroBean.fechaAplicacion);
}

//Activos ligados a un arrendamiento
function activosLigados(arrendamientoID){
	var params = {};
	params['tipoLista'] = 1;
	params['arrendaID'] = arrendamientoID;
	$.post("activosLigadosGrid.htm",params,function(data) {
		if(data.length >0 && data != null) { 
			limpiarGridActivosLigados();
			limpiarDetalleGrid();
			$('#contenedorActivosLigados').show(); 
			$('#contenedorActivosLigados').html(data); 
			agregaFormatoControles('contenedorActivosLigados');
		}else{
			mensajeSis('No hay activos vinculados');
			$("#numTab").val(4);
			$("#numeroFila").val(0);
			limpiarGridActivosLigados();
			limpiarDetalleGrid(); 
			reasignaTabIndex('tablaActivosLigados');
		}
	});
}

//limpiar tabla de amortizaciones
function limpiarGridActivosLigados(){
	$('#contenedorActivosLigados').hide();
	$('#contenedorActivosLigados').html('');
}

//limpiar Detalle del Grid
function limpiarDetalleGrid(){
	$('#tablaActivosLigados').find(':input').each( 
		function(){	    		
			var child = $(this);
			child.val('');
		}
	);
}

/**
 * Agrega un nuevo renglón a la tabla del grid.
 * @param idControl : ID de la tabla.
 */
function agregarDetalle(idControl){	
	// var idTabla = $('#'+idControl).attr('id');
	var idTab = 'numTab';
	reasignaTabIndex(idControl);
	//habilitaBoton(idBotonGrabar, 'submit');
	var numTab = $("#"+idTab).asNumber();
	var numeroFila = ($("#"+idControl+" > tbody > tr").length) - 1;
	numTab++;
	numeroFila++;
	var nuevaFila =
		"<tr id=\"renglon" + numeroFila + "\" name=\"renglon" + numeroFila + "\">" + 
			"<td><input id=\"activoIDVin" + numeroFila + "\" name=\"activoIDVin\" size=\"8\" type=\"text\" value=\"" + $('#activoID').val() + "\" readonly=\"readonly\" style=\"text-align: center; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"tipoActivoVin" + numeroFila + "\" name=\"tipoActivoVin\" size=\"8\" type=\"text\" value=\"" + $('#tipo').val() + "\" readonly=\"readonly\" style=\"text-align: left; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"activoDescri" + numeroFila + "\" name=\"activoDescri\" size=\"30\" type=\"text\" value=\"" + $('#descripcion').val() + "\" readonly=\"readonly\" style=\"text-align: left; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"clasificacion" + numeroFila + "\" name=\"clasificacion\" size=\"30\" type=\"text\" value=\"" + $('#subtipoActivo').val() + "\" readonly=\"readonly\" style=\"text-align: left; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"marcaActivo" + numeroFila + "\" name=\"marcaActivo\" size=\"30\" type=\"text\" value=\"" + $('#marca').val() + "\" readonly=\"readonly\" style=\"text-align: left; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"modeloActivo" + numeroFila + "\" name=\"modeloActivo\" size=\"30\" type=\"text\" value=\"" + $('#modelo').val() + "\" readonly=\"readonly\" style=\"text-align: left; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"numSerieActivo" + numeroFila + "\" name=\"numSerieActivo\" size=\"30\" type=\"text\" value=\"" + $('#numSerie').val() + "\" readonly=\"readonly\" style=\"text-align: left; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"numFacturaActivo" + numeroFila + "\" name=\"numFacturaActivo\" size=\"10\" type=\"text\" value=\"" + $('#numFactura').val() + "\" readonly=\"readonly\" style=\"text-align: left; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"valorFacturaActivo" + numeroFila + "\" name=\"valorFacturaActivo\" size=\"10\" type=\"text\" value=\"" + $('#valorFactura').val() + "\" readonly=\"readonly\" style=\"text-align: right; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\" esMoneda=\"true\"/></td>" +
			"<td><input id=\"fechaAdqActivo" + numeroFila + "\" name=\"fechaAdqActivo\" size=\"12\" type=\"text\" value=\"" + $('#fechaAdquisicion').val() + "\" readonly=\"readonly\" style=\"text-align: center; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"plazoMaximo" + numeroFila + "\" name=\"plazoMaximo\" size=\"10\" type=\"text\" value=\"" + $('#plazoMaximo').val() + "\" readonly=\"readonly\" style=\"text-align: left; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\"/></td>" +
			"<td><input id=\"residualMaximo" + numeroFila + "\" name=\"residualMaximo\" size=\"10\" type=\"text\" value=\"" + $('#porcentResidMax').val() + "\" readonly=\"readonly\" style=\"text-align: right; font-size: smaller;\" class=\"ui-widget ui-widget-content ui-corner-all\" esTasa=\"true\"/></td>" +
			"<td nowrap=\"nowrap\">" +
				"<input type=\"button\" id=\"eliminar" + numeroFila + "\" name=\"eliminar\" value=\"\" class=\"btnElimina\" onclick=\"eliminarParam('renglon" + numeroFila + "')\" tabindex=\"" + numTab + "\"/>" +
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
	var numInicioTabs = 5;
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

function funcionConsultaArrendamiento(idControl) {
	var varJqArrendamiento = eval("'#" + idControl + "'");
	var varArrendamiento = $(varJqArrendamiento).val();
	var varTipoCon = 2;
	
	var varMesaControlArrendamientoBean = {
		'arrendaID': varArrendamiento
	};

	setTimeout("$('#cajaLista').hide();", 200);
	
	if(varArrendamiento != '' && !isNaN(varArrendamiento) ){
		varArrendamiento = parseInt(varArrendamiento); 
		arrendamientoServicio.consulta(varTipoCon, varMesaControlArrendamientoBean, function(varArrendamientos) {
			if(varArrendamientos != null){
				$('#arrendaID').val(varArrendamientos.arrendaID);
				$('#clienteID').val(varArrendamientos.clienteID);
				$('#nombreCliente').val(varArrendamientos.nombreCliente);
				$('#tipoArrenda').val(varArrendamientos.tipoArrenda);
				$('#estatus').val(varArrendamientos.estatus);
				$('#productoArrendaID').val(varArrendamientos.productoArrendaID);
				$('#productoArrenda').val(varArrendamientos.productoArrendaDescri);
				$('#fechaApertura').val(varArrendamientos.fechaApertura);
				$('#monto').val(varArrendamientos.montoArrenda);
				$('#valorResidual').val(varArrendamientos.montoResidual);
				$('#tasaFijaAnual').val(varArrendamientos.tasaFijaAnual);
				agregaFormatoControles('formaGenerica');
				if ($('#estatus').val() == 'GENERADO' && $('#descripcion').val() != '' && $('input[name="activoIDVin"').filter(function(){return this.value==$('#activoID').val()}).length <= 0) {
					habilitaBoton('agregar', 'button');
				} else {
					deshabilitaBoton('agregar', 'button');
				}
				inicializaCamposActivo();
				$('#tipoActivo').val(0).selected = true;
				activosLigados(varArrendamiento);
			}else{ 
				limpiarGridActivosLigados();
				mensajeSis("El arrendamiento no existe");
				$(varJqArrendamiento).focus();
				deshabilitaBoton('agregar', 'button');
				inicializaForma('formaGenerica');
				$('#tipoActivo').val(0).selected = true;
				agregaFormatoControles('formaGenerica');
			}
		});
	}
}

function funcionConsultaActivo(idControl) {
	var varJqActivo = eval("'#" + idControl + "'");
	var varActivo = $(varJqActivo).val();
	var varTipoCon = 2;
	
	var varActivoArrendaBean = {
		'activoID': varActivo
	};

	setTimeout("$('#cajaLista').hide();", 200);
	
	if(varActivo != '' && !isNaN(varActivo) ){
		varActivo = parseInt(varActivo); 
		activoArrendaServicio.consulta(varTipoCon, varActivoArrendaBean, function(varActivos) {
			if(varActivos != null){
				$('#activoID').val(varActivos.activoID);
				$('#tipoActivo').val(varActivos.tipoActivo);
				if ($('#tipoActivo').val() == 1) {
					$('#tipo').val('AUTOS');
				}
				if ($('#tipoActivo').val() == 2) {
					$('#tipo').val('MUEBLES');
				}
				$('#descripcion').val(varActivos.descripcion);
				$('#subtipoActivo').val(varActivos.subtipoActivo);
				$('#marca').val(varActivos.marca);
				$('#modelo').val(varActivos.modelo);
				$('#numSerie').val(varActivos.numeroSerie);	
				$('#numFactura').val(varActivos.numeroFactura);
				$('#valorFactura').val(varActivos.valorFactura);	
				$('#costosAdicionales').val(varActivos.costosAdicionales);
				$('#fechaAdquisicion').val(varActivos.fechaAdquisicion);
				$('#plazoMaximo').val(varActivos.plazoMaximo);
				$('#porcentResidMax').val(varActivos.porcentResidMax);
				agregaFormatoControles('formaGenerica');
				if ($('#estatus').val() == 'GENERADO' && $('input[name="activoIDVin"').filter(function(){return this.value==$('#activoID').val()}).length <= 0) {
					habilitaBoton('agregar', 'button');
					if (tabActivoID) {
						$('#agregar').focus();
					}
				} else {
					deshabilitaBoton('agregar', 'button');
					if (tabActivoID) {
						if ($('input[name="activoIDVin"').length > 0) {
							$('#' + $('#contenedorActivosLigados').find(".btnElimina").attr('id')).focus();
						} else {
							$('#grabar').focus();
						}
					}
				}
			}else{ 
				mensajeSis("El activo no existe");
				$(varJqActivo).focus();
				deshabilitaBoton('agregar', 'button');
				inicializaCamposActivo();
				agregaFormatoControles('formaGenerica');
			}
		});
	}
}
