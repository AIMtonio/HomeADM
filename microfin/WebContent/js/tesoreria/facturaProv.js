// variables Globales
var parametrosBean = consultaParametrosSession();
var varfechaAplicacion = parametrosBean.fechaAplicacion;
var procedeSubmit = 0;

var impuestosProv = {};
var importesImpuestos = {};
var impuestosProvRet = [];
var impuestosProvGrav = [];

var listaPersBloqBean = {
		'estaBloqueado'	:'N',
		'coincidencia'	:0
};

$(document).ready(function() {
	esTab = false;
	var tab2=false;
	parametrosBean = consultaParametrosSession();
	varfechaAplicacion = parametrosBean.fechaAplicacion;
	var rutaArchivos = parametrosBean.rutaArchivos;
	procedeSubmit = 0;
	// variable para saber si realizar o no el submit
	//Definicion de Constantes y Enums
	var catTipoTransaccionFactura = {
			'agrega':'1',
			'modifica':'2',
			'altaGrabaLista':'3',
			'cancelar':'4',
			'actUUID':'6',

	};

	var catTipoConsultaFactura = {
			'principal':1,
			'foranea':2,
			'factReq':3,
			'factImportes':8
	};

	var catTipoActualFactura = {
			'cancelacion':1,
			'enviarUUID':'7'
	};

	agregaFormatoControles('formaGenerica');
	escondeMensajeDeCancelacion();// esconde el mensaje de cancelacion R=rápido
	escondefechaDeCancelacion();// esconde la fecha de cancelacion, se muestra solo en consulta
	$('#fechaFactura').val(varfechaAplicacion);
	$('#fechaProgPago').val(varfechaAplicacion);
	var actualiza ='';
	//------------ Metodos y Manejo de Eventos -----------------------------------------

	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('cancelar', 'submit');
	deshabilitaBoton('adjuntarImagen', 'submit');
	deshabilitaBoton('adjuntarXML', 'submit');
	deshabilitaBoton('verImagen', 'submit');
	deshabilitaBoton('verArchivo', 'submit');
	deshabilitaControl('saldoFactura');
	deshabilitaControl('folioUUID');
	deshabilitaBoton('modificar', 'submit');
	$('#proveedorID').focus();


	listaCondicionesPago();
	listaTiposPagoProv();
	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			switch($('#tipoTransaccion').val()){
				case catTipoTransaccionFactura.altaGrabaLista: // si se dio clic en Agregar
					if(validaDatosEventoAgregar()==1){
								grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','polizaID','inicializaValores','funcionError');
					}
					break;
				case catTipoTransaccionFactura.cancelar:
					validaDatosEventoCancelar(function(data){
						if(data != null){
							if(data.procede == 1){
								grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma',
										'mensaje','true','polizaID','inicializaValoresCancela','funcionError');
							}

						}else{

						}

					});

					break;
				default:
					if(validaDatosEventoAgregar()==1){
									grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','polizaID','inicializaValores','funcionError');
					}
					break;

					case catTipoTransaccionFactura.actUUID:
					if(validaEventoFolioUUID()==1){
						grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','polizaID','inicializaValoresForma','funcionError');

					}
			}
		}
	});
    //Imprimir la poliza
	$('#impPoliza').click(function(){
		var poliza = $('#polizaID').val();
		var fecha = parametroBean.fechaSucursal;
		window.open('RepPoliza.htm?polizaID='+poliza+'&fechaInicial='+fecha+
				'&fechaFinal='+fecha+'&nombreUsuario='+parametroBean.nombreUsuario);
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#agrega').click(function() {
		requiereFolioUUID();
		$('#tipoTransaccion').val(catTipoTransaccionFactura.altaGrabaLista);
		$('#tipoActualizacion').val('0');
	});
	$('#modificar').click(function() {
		requiereFolioUUID();
		$('#tipoTransaccion').val(catTipoTransaccionFactura.modifica);
		$('#tipoActualizacion').val('0');
	});

	$('#prorrateaImp').val($('#prorrateaImpNO').val());
	$('#pagoAnticipado').val($('#pagadaAntNO').val());
	// funcion para validar que los datos requeridos
	// se especifiquen cuando le da clic en agregar
	function validaDatosEventoAgregar(){
		varfechaAplicacion = parametroBean.fechaAplicacion;
		if($('#fechaFactura').val() > varfechaAplicacion ){
			mensajeSis("La Fecha de Factura No Debe ser Superior a la Fecha del Sistema");
			$('#fechaFactura').select();
			$('#fechaFactura').focus();
			procedeSubmit = 0;
		}else{
			procedeSubmit = guardarDetalle();
		}
		return procedeSubmit;
	}

	$('#cancelar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionFactura.cancelar);
		$('#tipoActualizacion').val(catTipoActualFactura.cancelacion);

	});


	// funcion para validar que los datos requeridos
	// se especifiquen cuando le da clic en Cancelar
	function validaDatosEventoCancelar(callback) {
		var proce ="";
		var obj={};


	    validaPeriodoCon(function(submit) {
	    	if(submit != null){
	    		if(submit.procedeSubmitCancelar == 1){
	    			if ($.trim($('#motivoCancelacion').val()) != '') {
                        muestraMensajeDeCancelacion();
                        if ($('#estatus').val() != 'A' && $('#estatus').val() != 'R' && $('#estatus').val() != 'I') {

                        	procedeSubmit = 0;
                        	proce =0;
                            mensajeSis("La factura no puede cancelarse.");

                        } else {
                            procedeSubmit = 1;
                            proce=1;
                            muestraMensajeDeCancelacion();

                        }
                    } else {
                        procedeSubmit = 0;
                        proce=0;
                        mensajeSis("Agrege un Motivo por el cual desea cancelar la Factura.");
                        muestraMensajeDeCancelacion();
                        $('#motivoCancelacion').focus();

                    }

	    		}else{

	    			procedeSubmit = 0;
	    			proce=0;

	    		}

	    	}else{
	    		procedeSubmit = 0;
	    		proce=0;

	    	}

	    	obj['procede']=proce;
			return callback(obj);
	    });

	}





	// funcion para validar si se estan enviando datos en el folio UUID
	function validaEventoFolioUUID(){
		if($('#folioUUID').val() != ''){
				procedeSubmit = 1;

		}else{
			procedeSubmit = 0;
			mensajeSis("Especifique Folio UUID");
			$('#folioUUID').focus();
		}
		return procedeSubmit;
	}


	$('#noFactura').change(function() {
		esTab = true;
		$('#aplicaFolioUUID').val("");
		$('#folioUUID').val("");
	});

	$('#noFactura').blur(function() {
		if(esTab){
			$('#impPoliza').hide();
			$('#aplicaFolioUUID').val("");
			$('#folioUUID').val("");
			ocultaLista();
			esTab = true;
			validaFacturaProveedor(this.id);
			$('#monto').val("");
			$('#trasladado').val("");
			$('#impuestoTotal').val("");
			$('#subTotal').val("");
			$('#importeRetenido').val("");
			$('#totalFactura').val("");
		}
	});

	$('#noFactura').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "noFactura";
			camposLista[1] = "proveedorID";
			parametrosLista[0] = $('#noFactura').val();
			parametrosLista[1] = $('#proveedorID').val();
			listaAlfanumerica('noFactura', '1', '3', camposLista, parametrosLista, 'listaFacturaProvVista.htm');
		}
	});

	$('#proveedorID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = 'primerNombre';
			camposLista[1] = "apellidoPaterno";
			parametrosLista [0] = '';
			parametrosLista[1] = $('#proveedorID').val();
			listaAlfanumerica('proveedorID', '1', '1', camposLista, parametrosLista, 'listaProveedores.htm');
		}
	});

	$('#proveedorID').blur(function() {
		var proveedor = $('#proveedorID').asNumber();
		$('#impPoliza').hide();
		ocultaLista();
		$('#prorrateoContable').hide();
		$('#aplicaPro').hide();
		if(isNaN($('#proveedorID').val()) ){
			$('#proveedorID').val("");
			$('#proveedorID').focus();
		}else{
			if(tab2 == false){
				if(proveedor>0){
					listaPersBloqBean = consultaListaPersBloq(proveedor, 'PRV', 0, 0);
					if(listaPersBloqBean.estaBloqueado!='S'){
						consultaProveedor(this.id);
					} else {
						mensajeSis('El Proveedor se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						$('#proveedorID').val("");
						$('#proveedorID').focus();
						inicializaForma('formaGenerica','proveedorID');
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('cancelar', 'submit');
						deshabilitaBoton('adjuntarImagen', 'submit');
						deshabilitaBoton('adjuntarXML', 'submit');
						deshabilitaBoton('verImagen', 'submit');
						deshabilitaBoton('verArchivo', 'submit');
						escondefechaDeCancelacion();
						escondeMensajeDeCancelacion();
					}
				}
			}
		}
		$('#impPoliza').hide();
		consultaImpuestosProveedor(this.id);
	});

	 $('#noEmpleadoID').bind('keyup',function(e){
		 if(this.value.length >= 2){
			var camposLista = new Array();
		    var parametrosLista = new Array();
		    	camposLista[0] = "nombreCompleto";
		    	parametrosLista[0] = $('#noEmpleadoID').val();
		 listaAlfanumerica('noEmpleadoID', '1', '1', camposLista, parametrosLista, 'listaEmpleados.htm');
		 }
	});

	$('#noEmpleadoID').blur(function() {
		ocultaLista();
		if(esTab){
			validaEmpleado(this);
		}
	});

	$('#adjuntarImagen').click(function() {
		subirImagenFactura();

	});

	$('#adjuntarXML').click(function() {
		subirArchivoXML();

	});

	$('#verImagen').click(function() {
		verImagenFactura();
	});

	$('#verArchivo').click(function() {
		verArchivoFactura();
	});


	$('#enviarUUID').click(function() {

		$('#tipoTransaccion').val(catTipoTransaccionFactura.actUUID);
		$('#tipoActualizacion').val(catTipoActualFactura.enviarUUID);

	});

	$('#fechaFactura').change(function(){
		var fechaAplic = parametroBean.fechaAplicacion;
		var fechaFact = $('#fechaFactura').val();
		if(fechaFact==''){
			$('#fechaFactura').val(varfechaAplicacion);
		}else{
			if(esFechaValida(fechaFact)){
				if(mayor(fechaFact,fechaAplic)){
					mensajeSis("La fecha Capturada es mayor a la de hoy");
					$('#fechaFactura').val(varfechaAplicacion);
					regresarFoco('fechaFactura');
				}else{
					if(!esTab){
						regresarFoco('fechaFactura');
					}
				}
			}else{
				$('#fechaFactura').val(varfechaAplicacion);
				regresarFoco('fechaFactura');
			}
		}
	});

	$('#fechaProgPago').change(function(){
		var fechaAplic = $('#fechaFactura').val();
		var fechaFact  = $('#fechaProgPago').val();
		if(fechaFact==''){
			$('#fechaProgPago').val(fechaAplic);
		}else{
			if(esFechaValida(fechaFact)){
				if(mayor(fechaAplic,fechaFact)){
					mensajeSis("La fecha Capturada es Menor a la Fecha de Factura");
					$('#fechaProgPago').val($('#fechaVencimiento').val());
					regresarFoco('fechaProgPago');
				}else{
					if(!esTab){
						$('#fechaProgPago').focus();
					}else{
						$('#centroCostoID1').focus();
					}
				}
			}else{
				$('#fechaProgPago').val(fechaAplic);
				regresarFoco('fechaProgPago');
			}
		}
	});

	$('#pagadaAntSI').change(function(){
		$('#estatus').val('L');
		deshabilitaControl('condicionesPago');
		$('#condicionesPago').val(1);
		$('#fechaVencimiento').val($('#fechaFactura').val());
		$('#detallesPagoPro').show(200);
		$('#pagoAnticipado').val($('#pagadaAntSI').val());
		$('#lblCxP').hide();
		$('#tdCxP').hide();
	});

	$('#pagadaAntNO').change(function(){
		limpiarDetallePago();
		$('#estatus').val('A');
		$('#condicionesPago').val('');
		habilitaControl('condicionesPago');
		$('#detallesPagoPro').hide(200);
		$('#pagoAnticipado').val($('#pagadaAntNO').val());
		$('#lblCxP').show();
		$('#tdCxP').show();
	});

	$('#prorrateaImpSI').change(function(){
		$('#prorrateaImp').val($('#prorrateaImpSI').val());
	});

	$('#prorrateaImpNO').change(function(){
		$('#prorrateaImp').val($('#prorrateaImpNO').val());
	});

	$('#fechaProgPago').blur(function(){
		$('#centroCostoID1').focus();
	});

	$('#condicionesPago').blur(function() {
		consultaDiasCondicionesPago('condicionesPago');
	});

	$('#condicionesPago').change(function() {
		consultaDiasCondicionesPago('condicionesPago');
	});

	$('#cenCostoManualID').bind('keyup',function(){
		lista(this.id, '2', '1', 'descripcion', $('#cenCostoManualID').val(), 'listaCentroCostos.htm');
	});

	$('#cenCostoManualID').blur(function(){
		ocultaLista();
		if($('#cenCostoManualID').val()!='' && !isNaN($('#cenCostoManualID').val())){
			validaCentroCostos(this);
		}
	});

	$('#cenCostoAntID').bind('keyup',function(){
		lista(this.id, '2', '1', 'descripcion', $('#cenCostoAntID').val(), 'listaCentroCostos.htm');
	});
	$('#cenCostoAntID').blur(function(){
		ocultaLista();
		if($('#cenCostoAntID').val()!='' && !isNaN($('#cenCostoAntID').val())){
			validaCentroCostos(this);
		}
	});

	function listaTiposPagoProv(){
		var numLista=1;
		var tipoPagoBean={
			'tipoPagoProvID':0
		};
		dwr.util.removeAllOptions('tipoPagoAnt');
		dwr.util.addOptions( 'tipoPagoAnt', {'':'SELECCIONAR'});
		tipoPagoProvServicio.listaTipoPagoProv(numLista,tipoPagoBean,function(tipoPago){
			if(tipoPago!=null){
					dwr.util.addOptions('tipoPagoAnt', tipoPago, 'tipoPagoProvID', 'descripcion');
			}else{
			}

		});
	}


	$('#folioUUID').blur(function() {
		var folio = $('#folioUUID').val() ;
		validaFolio(folio);

	});





	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			proveedorID: {
				required: true,
				number: true
			},
			tipoProveedor: {
				required: true,
				number: true
			},
			noFactura: {
				required: true,
				numerosLetras:true
			},
			fechaFactura: {
				required: true,
				date: true
			},
			fechaProgPago: {
				required: true,
				date: true
			},
			fechaVencimiento: {
				required: true,
				date: true
			},
			saldoFactura: {
				required: true
			},
			condicionesPago:{
				required: true
			},
			proveedorID: {
				required: true
			},
			cenCostoManualID:{
				required: function(){return $('#pagadaAntNO').is(':checked');}
			},
			tipoPagoAnt:{
				required: function(){return $('#pagadaAntSI').is(':checked');}
			},
			cenCostoAntID:{
				required: function(){return $('#pagadaAntSI').is(':checked');}
			},
			noEmpleadoID:{
				required: function(){return $('#pagadaAntSI').is(':checked');}
			},
			folioUUID:{
				required : function() {return $('#aplicaFolioUUID').val() == '1';},
				minlength : 36
			}



		},
		messages: {
			proveedorID: {
				required: 'Especifique Proveedor',
				number : "Solo numeros"
			},
			proveedorID: {
				required: 'Especifique el Tipo de Proveedor ',
				number : "Solo numeros"
			},
			noFactura: {
				required: 'Especifique Número de Factura',
				numerosLetras:"Sólo Números y Letras",
			},
			fechaFactura: {
				required: 'Especifique Fecha',
				date : 'Fecha Incorrecta'
			},
			fechaProgPago: {
				required: 'Especifique Fecha',
				date : 'Fecha Incorrecta'
			},
			fechaVencimiento: {
				required: 'Especifique Fecha',
				date : 'Fecha Incorrecta'
			},
			saldoFactura: {
				required: 'Especifique Saldo'
			},
			condicionesPago:{
				required: 'Especifique Condiciones de Pago'
			},
			proveedorID: {
				required: 'Especifique Proveedor'
			},
			cenCostoManualID:{
				required: 'Especifique Centro de Costo'
			},
			tipoPagoAnt:{
				required: 'Especifique Tipo de Pago'
			},
			cenCostoAntID:{
				required: 'Especifique Centro de Costo'
			},
			noEmpleadoID:{
				required: 'Especifique No. Empleado'
			},
			folioUUID:{
				required: 'Especifique Folio UUID',
				minlength : 'Formato Incorrecto'
			}

		}
	});



	//------------ Validaciones de Controles -------------------------------------

	function limpiarDetallePago(){
		$('#tipoPagoAnt').val('');
		$('#cenCostoAntID').val('');
		$('#nombreCenCostoAnt').val('');
		$('#noEmpleadoID').val('');
		$('#nombreEmpleado').val('');
	}

	function validaFacturaProveedor(idControl) {
		habilitaControl('folioUUID');
		var jqFactura  = eval("'#" + idControl + "'");
		var numFactura = $(jqFactura).val();
		var numProveedor = $('#proveedorID').val();

		var facturaBeanCon = {
				'noFactura'	:numFactura,
				'proveedorID':$('#proveedorID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numFactura != ''  && esTab){
			consultaImportesImpuestos(numFactura,numProveedor);

			actualiza = 'S';
			habilitaBoton('agrega', 'submit');
			deshabilitaBoton('modificar', 'submit');
			facturaProvServicio.consulta(catTipoConsultaFactura.principal, facturaBeanCon,function(factura) {
				if(factura!=null){


					inicializaForma('formaGenerica','noFactura');
					agregaFormatoControles('formaGenerica');
					if(factura.estatus!="I"){
						consultaDetalleFactura(true);
					}else{
						consultaDetalleFactura(false);
					}


					switch(factura.estatus) {
					    case 'A': // REGISTRADO -ALTA
					    	habilitaBoton('cancelar', 'submit');
					    	consultaPolizaFactura(numFactura,numProveedor);
							escondefechaDeCancelacion();
							escondeMensajeDeCancelacion();
							habilitaBoton('adjuntarImagen', 'submit');
							habilitaBoton('adjuntarXML', 'submit');
							habilitaBoton('verImagen', 'submit');
							habilitaBoton('verArchivo', 'submit');
							habilitaControl('motivoCancelacion');
							deshabilitaBoton('modificar', 'submit');
					    break;

					    case 'C': // CANCELADO
					    	deshabilitaBoton('cancelar', 'submit');
							deshabilitaBoton('adjuntarImagen', 'submit');
							deshabilitaBoton('adjuntarXML', 'submit');
							deshabilitaBoton('verImagen', 'submit');
							deshabilitaBoton('verArchivo', 'submit');
							muestrafechaDeCancelacion();
							muestraMensajeDeCancelacion();
							deshabilitaControl('motivoCancelacion');
							deshabilitaControl('folioUUID');
							$('#enviarUUID').hide();
							deshabilitaBoton('modificar', 'submit');
					    break;

					    case 'R': // EN REQUISION
					    	habilitaBoton('cancelar', 'submit');
					    	consultaPolizaFactura(numFactura,numProveedor);
							escondefechaDeCancelacion();
							escondeMensajeDeCancelacion();
							habilitaBoton('adjuntarImagen', 'submit');
							habilitaBoton('adjuntarXML', 'submit');
							habilitaBoton('verImagen', 'submit');
							habilitaBoton('verArchivo', 'submit');
							habilitaControl('motivoCancelacion');
							deshabilitaBoton('modificar', 'submit');
					    break;

					    case 'L': // LIQUIDADA
					    	deshabilitaBoton('cancelar', 'submit');
					    	consultaPolizaFactura(numFactura,numProveedor);
					    	escondefechaDeCancelacion();
							escondeMensajeDeCancelacion();
							habilitaBoton('adjuntarImagen', 'submit');
							habilitaBoton('adjuntarXML', 'submit');
							habilitaBoton('verImagen', 'submit');
							habilitaBoton('verArchivo', 'submit');
							habilitaBoton('enviarUUID', 'submit');
							habilitaControl('motivoCancelacion');
							deshabilitaBoton('modificar', 'submit');
				    	break;

					    case 'P': // PAGADA PARCIALMENTE
					    	deshabilitaBoton('cancelar', 'submit');
					    	consultaPolizaFactura(numFactura,numProveedor);
					    	escondefechaDeCancelacion();
							escondeMensajeDeCancelacion();
							habilitaBoton('adjuntarImagen', 'submit');
							habilitaBoton('adjuntarXML', 'submit');
							habilitaBoton('verImagen', 'submit');
							habilitaBoton('verArchivo', 'submit');
							habilitaControl('motivoCancelacion');
							deshabilitaBoton('modificar', 'submit');
				    	break;
					    case 'V': // VENCIDA
					    	deshabilitaBoton('cancelar', 'submit');
					    	consultaPolizaFactura(numFactura,numProveedor);
							habilitaBoton('adjuntarImagen', 'submit');
							habilitaBoton('adjuntarXML', 'submit');
							habilitaBoton('verImagen', 'submit');
							habilitaBoton('verArchivo', 'submit');
					    	escondefechaDeCancelacion();
							escondeMensajeDeCancelacion();
							habilitaControl('motivoCancelacion');
							habilitaControl('folioUUID');
							deshabilitaBoton('modificar', 'submit');
				    	break;
					    case 'I': // IMPORTADA-GUARDADA
					    	deshabilitaBoton('cancelar', 'submit');
					    	habilitaBoton('modificar', 'submit');
					    	//consultaPolizaFactura(numFactura,numProveedor);
							escondefechaDeCancelacion();
							escondeMensajeDeCancelacion();
							habilitaBoton('adjuntarImagen', 'submit');
							habilitaBoton('adjuntarXML', 'submit');
							habilitaBoton('verImagen', 'submit');
							habilitaBoton('verArchivo', 'submit');
							deshabilitaControl('motivoCancelacion');
					    break;
					}
					if(factura.estatus != 'C'){
						if(factura.folioUUID == '' || factura.folioUUID == null){
							$('#enviarUUID').show();
							$('#enviaFolioUUID').val(1);
							habilitaControl('folioUUID');
						}
						else {
							$('#enviarUUID').show();

						}
					}

					deshabilitaControl('importeImpuesto');
					$('#subTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#totalFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#trasladado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#importeRetenido').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#impuestoTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

					agregatablaArrendam();
					dwr.util.setValues(factura);
					deshabilitaBoton('agrega', 'submit');
					consultaTipoProveedorFactura('proveedorID');
					deshabilitaControl('condicionesPago');
					deshabilitaControl('agregaDetalle');
					$('#monto').val(factura.subTotal-factura.totGravado);



					for (var j = 0; j < importesImpuestos.length; j++){
							var objeImporteImp= importesImpuestos[j];
							var ValImporteImp = objeImporteImp.importeImpuesto;
							var IDImpImpuesto = objeImporteImp.impuestoID;
							$('#impuesto'+IDImpImpuesto).val(ValImporteImp);

						}


					$('#trasladado').val(factura.totGravado);
					$('#importeRetenido').val(factura.totRetenido);
					var fechProg = factura.fechaProgPago;
					var fecPro = fechProg.substring(0,10);
					$('#fechaProgPago').val(fecPro);
					var fechVenc = factura.fechaVencimiento;
					var fecVen = fechVenc.substring(0,10);
					$('#fechaVencimiento').val(fecVen);
					deshabilitaControl('fechaFactura');
					deshabilitaControl('fechaProgPago');

					if(factura.pagoAnticipado=='S'){
						$('#pagadaAntSI').attr('checked','checked');
						$('#detallesPagoPro').show(200);
						$('#noEmpleadoID').val(factura.noEmpleadoID);
						validaCentroCostos('cenCostoAntID');
						validaEmpleado('noEmpleadoID');
						deshabilitaControl('cenCostoAntID');
						deshabilitaControl('tipoPagoAnt');
						deshabilitaControl('noEmpleadoID');
						$('#lblCxP').hide();
						$('#tdCxP').hide();
					}else{
						validaCentroCostos('cenCostoManualID');
						deshabilitaControl('cenCostoManualID');
						$('#detallesPagoPro').hide(200);
						$('#lblCxP').show();
						$('#tdCxP').show();
					}
					if(factura.prorrateaImp=='S'){
						$('#prorrateaImpSI').attr('checked','checked');
					}
					deshabilitaControl('pagadaAntSI');
					deshabilitaControl('pagadaAntNO');
					deshabilitaControl('prorrateaImpSI');
					deshabilitaControl('prorrateaImpNO');


					agregaFormatoControles('gridDetalle');
					agregaFormatoControles('formaGenerica');
					agregaFormatoControles('arrendamiento');
					agregaFormatoControles('Todo');
					$('#importeImpuesto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#subTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#totalFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

					$('#trasladado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#importeRetenido').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#saldoFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#impuestoTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
				}else{
					mostrarGridDetalle(false);
					if($('#proveedorID').val() != '' && $('#proveedorID').val() !='0' ){
						$('#agregaDetalle').show();
						//$('#condicionesPago').attr('disabled',false);
						habilitaControl('condicionesPago');

						$('#agregaDetalle').attr('disabled',false);
						$('#noFactura').val(numFactura);
						habilitaBoton('agrega', 'submit');
						deshabilitaBoton('cancelar', 'submit');
						deshabilitaBoton('modificar', 'submit');
						inicializaValoresFactura();
						escondefechaDeCancelacion();
						escondeMensajeDeCancelacion();

						//INICIO Habilita y limpia campos referentes a prorrateo de impuestos y pago anticipado
						limpiarDetallePago();
						$('#detallesPagoPro').hide();
						habilitaControl('cenCostoAntID');
						habilitaControl('tipoPagoAnt');
						habilitaControl('pagadaAntSI');
						habilitaControl('pagadaAntNO');
						habilitaControl('prorrateaImpSI');
						habilitaControl('prorrateaImpNO');
						habilitaControl('cenCostoManualID');
						habilitaControl('noEmpleadoID');
						$('#cenCostoManualID').val('');
						$('#nombreCenCostoManual').val('');
						$('#pagadaAntNO').attr('checked','checked');
						$('#prorrateaImpNO').attr('checked','checked');
						$('#pagoAnticipado').val('N');
						$('#prorrateaImp').val('N');
						$('#lblCxP').show();
						$('#tdCxP').show();
						$('#monto').val('');
						$('#importeImpuesto').val('');
						$('#subTotal').val('');
						$('#trasladado').val('');
						$('#impuestoTotal').val('');
						$('#importeRetenido').val('');
						$('#totalFactura').val('');

						//FIN

						habilitaControl('motivoCancelacion');
						habilitaControl('fechaFactura');
						habilitaControl('fechaProgPago');
						habilitaBoton('adjuntarImagen', 'submit');
						habilitaBoton('adjuntarXML', 'submit');
						habilitaBoton('verImagen', 'submit');
						habilitaBoton('verArchivo', 'submit');
						actualiza = 'N';
						$('#rutaImagenFact').val('');
						$('#rutaXMLFact').val('');
						$('#estatus').val('A');
						$('#prorrateoHecho').val('N');
					}else{
						$('#Todo').html(""); //DIV de proveedor servicios (cobra IVA)
						$('#arrendamiento').html(""); //Div de proveedor de arrendamiento u honorarios
						$('#aplicaPro').hide();
						$('#prorrateoContable').hide();

					}
				}
			});
		}
	}

	// FUNCION PARA CONSULTAR LA POLIZA DE LA FACTURA
	function consultaPolizaFactura(numFactura,numProveedor ){
		var conPrincipal = 4;
		var facturaBeanCon = {
				'noFactura'	:numFactura,
				'proveedorID':numProveedor
		};
			facturaProvServicio.consulta(conPrincipal, facturaBeanCon, function(poliza){
			if(poliza!=null){
				$('#polizaID').val(poliza.polizaID);
				$('#impPoliza').show();
			}
			else {
				$('#impPoliza').hide();
			}
		});
	}


	function validaCentroCostos(control){
		var jqCentro='';
		if(typeof(control)=='string'){
			jqCentro = eval("'#"+control+"'");
		}else{
			jqCentro = eval("'#"+control.id+"'");
		}
		var numcentroCosto = $(jqCentro).val();
		var tipoLista=1;
		var campoCentroCostoManual='nombreCenCostoManual';
		var campoCentroCostoAntici='nombreCenCostoAnt';
		var campoNombreCentro='';

		// validacion de que campo de centro de costos viene para poner el nombre
		if(jqCentro=='#cenCostoManualID'){
			campoNombreCentro=campoCentroCostoManual;
		}else if(jqCentro=='#cenCostoAntID'){
			campoNombreCentro=campoCentroCostoAntici;
		}
		var campoNombre=eval("'#"+campoNombreCentro+"'");

		setTimeout("$('#cajaLista').hide();", 200);
			if(numcentroCosto != '' && !isNaN(numcentroCosto) && esTab){
					var centroBeanCon = {
  					'centroCostoID':numcentroCosto
				 };
				centroServicio.consulta(tipoLista,centroBeanCon,function(centro) {
						if(centro!=null){
							$(campoNombre).val(centro.descripcion);
						}else{
								mensajeSis('El Centro de Costo No Existe');
								$(campoNombre).val('');
								$(jqCentro).val('');
								$(jqCentro).focus();
						}
					});
			}
	}

	function listaTipoGasto(idControl){
		var jqTipoGasto = eval("'#" + idControl + "'");
		if($(jqTipoGasto).length>2){
			var num = $(jqTipoGasto).val();

			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = num;

			listaAlfanumerica(idControl, '1', '1', camposLista, parametrosLista, 'listaTipoGas.htm');
		}
	}




	function consultaProveedor(idControl) {
			deshabilitaBoton('adjuntarImagen', 'submit');
			deshabilitaBoton('adjuntarXML', 'submit');
			deshabilitaBoton('verImagen', 'submit');
			deshabilitaBoton('verArchivo', 'submit');
			$('#enviarUUID').hide();
		inicializaForma('formaGenerica','proveedorID');
		$('#fechaFactura').val(varfechaAplicacion);
		$('#fechaProgPago').val(varfechaAplicacion);
		$('#gridDetalle').html("");
		var jqProveedor  = eval("'#" + idControl + "'");
		var numProveedor = $(jqProveedor).val();

		var proveedorBeanCon = {
				'proveedorID'	:numProveedor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProveedor != '' && !isNaN(numProveedor) ){

			proveedoresServicio.consulta(catTipoConsultaFactura.principal,proveedorBeanCon,function(proveedores) {
				if(proveedores!=null){

					var nombreCompleto ="";
					escondefechaDeCancelacion();
					escondeMensajeDeCancelacion();
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('cancelar', 'submit');

					if(proveedores.estatus != 'A'){
						mensajeSis("El Proveedor Debe estar Activo");
						inicializaForma('formaGenerica','proveedorID');
						$('#fechaFactura').val(varfechaAplicacion);
						$('#fechaProgPago').val(varfechaAplicacion);
						$('#proveedorID').val('');
						$('#proveedorID').focus();
					}else{

						if(proveedores.tipoPersona == 'F' ){

							nombreCompleto = proveedores.primerNombre+" "+proveedores.segundoNombre+" "+proveedores.apellidoPaterno+" "
							+proveedores.apellidoMaterno;
						}
						if(proveedores.tipoPersona == 'M' ){

							nombreCompleto = proveedores.razonSocial;
						}

						$('#nombreProv').val(nombreCompleto);
						$('#tipoProveedor').val(proveedores.tipoProveedorID);

						esTab = true;
						consultaTipoProveedor('tipoProveedor');
						validaCuentaContable(proveedores.cuentaCompleta);
						validaCuentaAnticipacion(proveedores.cuentaAnticipo);
					}
				}else{
					mensajeSis("El Proveedor No Existe.");
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('cancelar', 'submit');
					deshabilitaBoton('adjuntarImagen', 'submit');
					deshabilitaBoton('adjuntarXML', 'submit');
					deshabilitaBoton('verImagen', 'submit');
					deshabilitaBoton('verArchivo', 'submit');
					deshabilitaBoton('modificar', 'submit');
					escondefechaDeCancelacion();
					escondeMensajeDeCancelacion();
					$('#proveedorID').val("");
					$('#proveedorID').focus();

				}
			});
		}
	}
	function validaEmpleado(control){
		var evalEmpleado='';
		var ban=true;
		if(typeof(control)=='string'){
			ban=true;
			evalEmpleado = eval("'#"+control+"'");
		}else{
			ban=false;
			evalEmpleado = eval("'#"+control.id+"'");
		}
			if($(evalEmpleado).val()!='' && !isNaN($(evalEmpleado).val())){
				var consultaProvFact = 5;
				var empleadoBeanCon = {
					'empleadoID' : $(evalEmpleado).val()
				};
				empleadosServicio.consulta(consultaProvFact,empleadoBeanCon, { async: false, callback:function(empleados) {
					if(ban==true){
						if (empleados != null) {
							$('#nombreEmpleado').val(empleados.nombreCompleto);
						}else{
							mensajeSis("No Existe el Empleado");
							$('#noEmpleadoID').val('');
							$('#nombreEmpleado').val('');
							$('#noEmpleadoID').focus();
						}
					}else{
						if (empleados != null  && empleados.estatus!='I' ) {
							$('#nombreEmpleado').val(empleados.nombreCompleto);
						}else if(empleados == null){
							mensajeSis("El Empleado No existe");
							$('#noEmpleadoID').val('');
							$('#nombreEmpleado').val('');
							$('#noEmpleadoID').focus();
						}else{
							mensajeSis("Empleado Inactivo");
							$('#noEmpleadoID').val('');
							$('#nombreEmpleado').val('');
							$('#noEmpleadoID').focus();
						}
					}
				}
				});
			}else{
				$('#noEmpleadoID').val('');
				$('#nombreEmpleado').val('');
			}
	}
	// Consulta el tipo de proveedor de la factura
	function consultaTipoProveedorFactura(idControl) {

		var jqProveedor  = eval("'#" + idControl + "'");
		var numProveedor = $(jqProveedor).val();

		var proveedorBeanCon = {
				'proveedorID'	:numProveedor
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(numProveedor != '' && !isNaN(numProveedor) && esTab){
			proveedoresServicio.consulta(catTipoConsultaFactura.principal,proveedorBeanCon,function(proveedores) {
				if(proveedores!=null){
					esTab=true;
					var nombreCompleto ="";

					if(proveedores.tipoPersona == 'F' ){
						nombreCompleto = proveedores.primerNombre+" "+proveedores.segundoNombre+" "+proveedores.apellidoPaterno+" "
						+proveedores.apellidoMaterno;
					}
					if(proveedores.tipoPersona == 'M' ){
						nombreCompleto = proveedores.razonSocial;
					}

					$('#nombreProv').val(nombreCompleto);
					$('#tipoProveedor').val(proveedores.tipoProveedorID);
					consultaTipoProveedor('tipoProveedor');
				}
				else{
					mensajeSis("El Proveedor No Existe.");
					$('#proveedorID').focus();
					$('#proveedorID').val("");
				}
			});
		}
	}

	function consultaDetalleFactura(deshabilitar){
		$('#gridDetalle').show();
		var params = {};
		params['tipoLista'] = 2;
		params['noFactura'] = $('#noFactura').val();
		params['proveedorID'] = $('#proveedorID').val();

		$.post("detalleFacturaProvGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#gridDetalle').html(data);
				$('#gridDetalle').show();
				deshabilitaBotonGrid();
				var numDetalle = $('input[name=consecutivoID]').length;
				var tipoGasto ="tipoGastoID";
				for(var i = 1; i <= numDetalle; i++){
					var jqTipo =tipoGasto+i;
					consultaTipoGastoGrid(jqTipo);
				}
				// si no hay detalles en la factura se muestra la primer fila para el primer detalle
				if(numDetalle==0){
					agregaNuevoDetalle();
				}
				agregaFormatoControles('gridDetalle');
				if(deshabilitar==true){
					 deshabilitaDetalles();
				}else{
					habilitaDetalles();
				}

				$('#prorrateoContable').hide();
				$('#aplicaPro').hide();
				$('#adjuntarImagen').focus();
			}else{
				$('#gridDetalle').html("");
				$('#gridDetalle').show();
				$('#prorrateoContable').hide();
				$('#aplicaPro').hide();
			}
		});
	}

	function mostrarGridDetalle(deshabilitar){
		$('#gridDetalle').show();
		var params = {};
		params['tipoLista'] = 2;
		params['noFactura'] = $('#noFactura').val();
		params['proveedorID'] = $('#proveedorID').val();

		$.post("detalleFacturaProvGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#gridDetalle').html(data);
				$('#gridDetalle').show();
				deshabilitaBotonGrid();
				var numDetalle = $('input[name=consecutivoID]').length;
				var tipoGasto ="tipoGastoID";
				for(var i = 1; i <= numDetalle; i++){
					var jqTipo =tipoGasto+i;
					consultaTipoGastoGrid(jqTipo);
				}

				if(numDetalle==0){
					// si no hay detalles en la factura se muestra la primer fila para el primer detalle
					agregaNuevoDetalle();
				}
				agregaFormatoControles('gridDetalle');
				if(deshabilitar==true){
					 deshabilitaDetalles();
				}
				agregatablaArrendam();
				$('#pagadaAntSI').focus();
			}else{
				$('#gridDetalle').html("");
				$('#gridDetalle').show();
				$('#noFactura').focus();
			}
		});
	}


	function consultaTipoProveedor(idControl) {
		var jqTipoProveedor  = eval("'#" + idControl + "'");
		var numtipoProv = $(jqTipoProveedor).val();
		var tipoProveedorBeanCon = {
				'tipoProveedorID'	:numtipoProv
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(numtipoProv != '' && !isNaN(numtipoProv) && esTab){

			tipoProvServicio.consulta(catTipoConsultaFactura.foranea,tipoProveedorBeanCon,function(tiposProv) {
				if(tiposProv!=null){
					esTab=true;
					$('#descripTipoProv').val(tiposProv.descripcion);
					consultaImpuestosXTipoProv('tipoProveedor');
				}
				else{
					mensajeSis("El tipo no existe");
				}
			});
		}
	}


	function consultaImpuestosProveedor(provID){
		var jqProveedorID  = eval("'#" + provID + "'");
		var numProv = $(jqProveedorID).val();
		var proveedorBeanCon = {
				'proveedorID'	:numProv
		};
		tipoLista= 3;
		if(numProv != '' && !isNaN(numProv) && esTab){
			detfacturaProvServicio.listaDetalleFacturaProv(tipoLista, proveedorBeanCon, function(impuestos){
				if(impuestos!=null){
					impuestosProv = impuestos;

					impuestosProvGrav.length=0;
					impuestosProvRet.length=0;

					for (var i = 0; i < impuestosProv.length; i++){
						var impuestoIDE = impuestosProv[i];
						var gravaRet = impuestoIDE.gravaRetiene;
						if(gravaRet == 'G'){
							impuestosProvGrav.push(impuestoIDE);
						}else if(gravaRet== 'R'){
							impuestosProvRet.push(impuestoIDE);

						}

					}
				}
			});
		}
	}

	function consultaImportesImpuestos(numFactura,numProveedor){
		var facturaBeanCon = {
				'noFactura'	:numFactura,
				'proveedorID':numProveedor
		};
		tipoLista= 4;
		detfacturaProvServicio.listaDetalleFacturaProv(tipoLista, facturaBeanCon, function(importes){
				if(importes!=null){
					importesImpuestos = importes;
				}
			});

	}


	function consultaImpuestosXTipoProv(idControl){
		var jqTipoImpPro  = eval("'#" + idControl + "'");
		var numtipoProv = $(jqTipoImpPro).val();

		var tipoProveedorBeanCon = {
				'tipoProveedorID'	:numtipoProv
		};
		tipoLista= 2;
		cadena="";
		if(numtipoProv != '' && !isNaN(numtipoProv) && esTab){
			tipoprovimpServicio.listaCombo(tipoLista, tipoProveedorBeanCon, function(impuestos){

				if(impuestos!=null){
					esTab=true;
				}

			});
		}
	}




	function consultaTipoGasto(idControl){
		var jqTipoGasto =eval("'#tipoGastoID" + idControl + "'");
		var jqDescTipo = eval("'#descripTGasto" + idControl + "'");
		var numTipoGasto = $(jqTipoGasto).val();
		var tipoCon =1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoGasto != '' && !isNaN(numTipoGasto) ){

			var RequisicionTipoGastoListaBean = {
					'tipoGastoID' : numTipoGasto
			};

			requisicionGastosServicio.consultaTipoGasto(tipoCon,RequisicionTipoGastoListaBean,function(tipoGastoCon){

				if(tipoGastoCon!=null){
					$(jqDescTipo).val(tipoGastoCon.descripcionTG);

				}else{
					mensajeSis("No existe el Tipo de Gasto");
					$(jqTipoGasto).focus();
					$(jqTipoGasto).val('');
				}
			});
		}
	}

	function consultaTipoGastoGrid(idControl){
		var jqTipo  = eval("'#" + idControl + "'");
		var numTipoGasto = $(jqTipo).val();

		var desc = idControl.substring(11);
		var jqDescripcion = eval("'#descripTGasto" + desc + "'");
		var tipoCon =1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoGasto != '' && !isNaN(numTipoGasto) ){

			var RequisicionTipoGastoListaBean = {
					'tipoGastoID' : numTipoGasto
			};

			requisicionGastosServicio.consultaTipoGasto(tipoCon,RequisicionTipoGastoListaBean,function(tipoGastoCon){
				if(tipoGastoCon!=null){
					$(jqDescripcion).val(tipoGastoCon.descripcionTG);
				}else{
					mensajeSis("No existe el Tipo de Gasto");
				}
			});
		}
	}

	function listaCondicionesPago() {
		var tipoCon = 2;
		var condicionesListaBean = {
				'condicionPagoID' : '0'
		};
		dwr.util.removeAllOptions('condicionesPago');
		dwr.util.addOptions( 'condicionesPago', {'':'SELECCIONAR'});
		condicionespagServicio.listaCombo(tipoCon, condicionesListaBean, function(condiciones){
			if(condiciones!=null){
				dwr.util.addOptions('condicionesPago', condiciones, 'condicionPagoID', 'descripcion');
			}else{
				mensajeSis("No Existe condición de pago");
			}
		});
	}

	// calcula la fecha de vencimiento de acuerdo al numero de dias de las condiciones de pago seleccionadas
	function consultaDiasCondicionesPago(idControl){
		var jqCondicion  = eval("'#" + idControl + "'");
		var numCondic = $(jqCondicion).val();
		var TipoConDias= 3;
		var condiconesBeanCon = {
				'condicionPagoID'	:numCondic
		};
		if(numCondic != '' && !isNaN(numCondic) && esTab){
			condicionespagServicio.consulta(TipoConDias,condiconesBeanCon,function(condiciones) {
				if(condiciones!=null){
					if($('#fechaFactura').val() == ""){
						mensajeSis("Ingresar Fecha de Factura");
						listaCondicionesPago();
						$('#fechaFactura').focus();
					}
					if($('#fechaFactura').val() != ""){
						var fechFactura = $('#fechaFactura').val();
						var dias =0;
						var fechFactConv= $.datepicker.parseDate('yy-mm-dd',fechFactura);
						dias = condiciones.numeroDias;
						var unDia = 24*60*60*1000; // equivalente a un dia en milisegundos
						var miliseg = fechFactConv.getTime();
						miliseg += (unDia * dias); // suma los dias a la fecha
						fechFactConv.setTime(miliseg);
						var nuevafecFact = $.datepicker.formatDate('yy-mm-dd', fechFactConv);
						$('#fechaVencimiento').val(nuevafecFact);
						$('#fechaProgPago').val(nuevafecFact);
					}
				}
			});
		}
	}


	function validaPeriodoCon(callback) {

	   	var tipoConsulta = 5;
    	var tipoConsulta2 = 7;
    	var tipoConsulta3 = 6;
    	var obj={};
    	var procedeSubmitCancelar = 0;


		var FacturaBeans = {
			'noFactura': $('#noFactura').val(),
			'proveedorID': $('#proveedorID').val()
			};


		facturaProvServicio.consulta(tipoConsulta, FacturaBeans,function(facturaProve){
			if(facturaProve!=null){
				if(facturaProve.estatusPeriodo == 'C' || facturaProve.estatusPeriodo == ''){
					mensajeSis('El período contable está cerrado, la factura no puede ser cancelada');
					deshabilitaBoton('cancelar', 'submit');
					deshabilitaBoton('impPoliza', 'submit');
					procedeSubmitCancelar = 0;

				}else{
					 facturaProvServicio.consulta(tipoConsulta2, FacturaBeans, function(factProveedor){
						if(factProveedor!=null){
							if(factProveedor.numAnticipos > 0){
								mensajeSis('La factura ya esta en un anticipo, no puede ser cancelada');
								deshabilitaBoton('cancelar', 'submit');
								deshabilitaBoton('impPoliza', 'submit');
								procedeSubmitCancelar = 0;

							}
							else{
								facturaProvServicio.consulta(tipoConsulta3, FacturaBeans, function(facturaProveedor){
									if(facturaProveedor!=null){
										if(facturaProveedor.numDisp > 0){
											mensajeSis('La factura ya esta en una dispersión, no puede ser cancelada');
											deshabilitaBoton('cancelar', 'submit');
											deshabilitaBoton('impPoliza', 'submit');
											procedeSubmitCancelar = 0;
										}else{
											procedeSubmitCancelar = 1;

										}
									}
									obj['procedeSubmitCancelar']=procedeSubmitCancelar;
									return callback(obj);

								});
							}
						}
						obj['procedeSubmitCancelar']=procedeSubmitCancelar;
						return callback(obj);
					});

				}

			}
			obj['procedeSubmitCancelar']=procedeSubmitCancelar;
			return callback(obj);
		});
	}






	function inicializaValoresFactura(){
		$('#condicionesPago').val('');
		$('#fechaVencimiento').val('');
		$('#fechaProgPago').val(varfechaAplicacion);
		$('#fechaFactura').val(varfechaAplicacion);
		$('#saldoFactura').val('');
		$('#enviarUUID').hide();
		habilitaControl('folioUUID');
	}

	function subirImagenFactura() {
		if($('#saldoFactura').val()== '' || $('#saldoFactura').val()=='0'){
			mensajeSis("La Factura no tiene ninguna partida.");
		}	else{
			$('#tipoArchivo').val('I');
			var tipoTransaccion = 5;
			var tipoActualizacion= 2;

			var tipoArchivo = $('#tipoArchivo').val();
			var rutaImagen = $('#rutaImagenFact').val();
			var rutaArch = $('#rutaXMLFact').val();

			if(rutaImagen != '' ){
				confirmar=confirm("Actualmente Existe una Imagen de Factura ¿Desea Reemplazarla?");
				if (confirmar == true) {
					var url ="facturaFileUploadVista.htm?proveedorID="+$('#proveedorID').val()+"&noFactura="+
					$('#noFactura').val()+"&ruta="+rutaArchivos+"&tipoArchivo="+tipoArchivo+"&tipoTransaccion="+tipoTransaccion+"&tipoActualizacion="+
					tipoActualizacion+"&actualiza="+actualiza+"&rutaImagenFact="+rutaImagen+"&rutaXMLFact="+rutaArch;

					var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
					var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;
					window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
							"left="+leftPosition+
							",top="+topPosition+
							",screenX="+leftPosition+
							",screenY="+topPosition);

				}else{
					return false;
				}
			}else{

				var url ="facturaFileUploadVista.htm?proveedorID="+$('#proveedorID').val()+"&noFactura="+
				$('#noFactura').val()+"&ruta="+rutaArchivos+"&tipoArchivo="+tipoArchivo+"&tipoTransaccion="+tipoTransaccion+"&tipoActualizacion="+
				tipoActualizacion+"&actualiza="+actualiza+"&rutaImagenFact="+rutaImagen+"&rutaXMLFact="+rutaArch;
				var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
				var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;
				window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
						"left="+leftPosition+
						",top="+topPosition+
						",screenX="+leftPosition+
						",screenY="+topPosition);

			}

		}

	}

	function subirArchivoXML() {
		var tipoTransaccion = 5;
		var tipoActualizacion= 2;

		$('#tipoArchivo').val('A');
		var tipoArchivo = $('#tipoArchivo').val();
		var rutaXML = $('#rutaXMLFact').val();
		var rutaImagen = $('#rutaImagenFact').val();
		if(rutaXML != '' ){

			confirmar=confirm("Actualmente Existe un Archivo de Factura ¿Desea Reemplazarlo?");
			if (confirmar == true) {
				var url ="facturaFileUploadVista.htm?proveedorID="+$('#proveedorID').val()+"&noFactura="+
				$('#noFactura').val()+"&ruta="+rutaArchivos+"&tipoArchivo="+tipoArchivo+"&tipoTransaccion="+tipoTransaccion+"&tipoActualizacion="+
				tipoActualizacion+"&actualiza="+actualiza+"&rutaImagenFact="+rutaImagen+"&rutaXMLFact="+rutaXML;
				var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
				var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;
				window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
						"left="+leftPosition+
						",top="+topPosition+
						",screenX="+leftPosition+
						",screenY="+topPosition);
			}else{
				return false;
			}
		}else{
			var url ="facturaFileUploadVista.htm?proveedorID="+$('#proveedorID').val()+"&noFactura="+
			$('#noFactura').val()+"&ruta="+rutaArchivos+"&tipoArchivo="+tipoArchivo+"&tipoTransaccion="+tipoTransaccion+"&tipoActualizacion="+
			tipoActualizacion+"&actualiza="+actualiza+"&rutaImagenFact="+rutaImagen+"&rutaXMLFact="+rutaXML;
			var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
			var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;
			window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
					"left="+leftPosition+
					",top="+topPosition+
					",screenX="+leftPosition+
					",screenY="+topPosition);
		}
	}


	function verImagenFactura() {
		var parametros = $('#rutaImagenFact').val();

		var tipo = "I";
		if(parametros==''){
			mensajeSis("No hay Imagen que Mostrar.");
		}else{
			var extarchivo= parametros.substring(parametros.lastIndexOf('.'));

			var pagina="facturasVerArchivos.htm?tipo="+tipo+"&extarchivo="+extarchivo+"&recurso="+parametros;
			$('#imgFactura').attr("src",pagina);

			if(extarchivo != '.pdf'){
				$('#imagenFactura').html();
				$.blockUI({message: $('#imagenFactura'),
					css: {
						top:  ($(window).height() - 400) /2 + 'px',
						left: ($(window).width() - 1000) /2 + 'px',
						width: '70%'
					} });
				$('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
			}else{
				window.location=pagina;
				$('#imagenFactura').hide();
			}
		}
	}

	function verArchivoFactura() {
		var parametros = $('#rutaXMLFact').val();
		var tipo = "A";
		if(parametros==''){
			mensajeSis("No hay Archivo que Mostrar.");
		}else{
			var extarchivo= parametros.substring(parametros.lastIndexOf('.'));
			var pagina="facturasVerArchivos.htm?recurso="+parametros+"&tipo="+tipo+"&extarchivo="+extarchivo;
			window.location=pagina;
			$('#imagenFactura').hide();
		}
	}

	function requiereFolioUUID() {
		var parametros = $('#rutaXMLFact').val();
		var parametrosImg = $('#rutaImagenFact').val();

		if(parametros=='' && parametrosImg==''){
			$('#aplicaFolioUUID').val("");
		}else{
			$('#aplicaFolioUUID').val(1);
		}
	}


	function quitaCeros(){
		var numFactura=$('#noFactura').val();
		var tamanio=$('#noFactura').val().length;
		var factura=numFactura;
		for(var x=0;x<=tamanio;x++){

			if(numFactura.substring(x,(x+1))=='0'){
				factura=numFactura.substring(x+1,$('#noFactura').val().length);
			}
			else{
				return factura;
			}
		}
	}



}); // fin query ready



function deshabilitaBotonGrid(){
	var numDetalle = $('input[name=consecutivoID]').length;
	if(numDetalle != '0'){
		$('#agregaDetalle').hide();
	}
}

// funcion que crea la lista que guardara el grid
function guardarDetalle(){
	var varTipoGastoID = "";
	var varCentroCostoID = "";
	var varCantidad = "";
	var varDescripcion = "";
	var varGravable = "";
	var varGravaCero = "";
	var varPrecioUnitario = "";
	var varImporte = "";

	var enviar = verificarvacios(); // se llama a la funcion que valida los elementos del grid
	if(enviar==1){
		guardaDetalleImp(); // CREA la lista de la seccion de impuestos por partida

		var numDetalle = $('input[name=consecutivoID]').length;
		$('#detalleFactura').val("");
		for(var i = 1; i <= numDetalle; i++){
			varTipoGastoID 		= eval("'#tipoGastoID"+i+"'");
			varCentroCostoID 	= eval("'#centroCostoID"+i+"'");
			varCantidad 		= eval("'#cantidad"+i+"'");
			varDescripcion 		= eval("'#descripcion"+i+"'");
			varGravable 		= eval("'#gravable"+i+"'");
			varGravaCero		= eval("'#gravaCero"+i+"'");
			varPrecioUnitario 	= eval("'#precioUnitario"+i+"'");
			varImporte 			= eval("'#importe"+i+"'");
			if(i == 1){
				$('#detalleFactura').val($('#detalleFactura').val() +
						$(varTipoGastoID).val() + ']' +
						$(varCentroCostoID).val() + ']' +
						$(varCantidad).asNumber() + ']' +
						$(varDescripcion).val() + ']' +
						$(varGravable).val() + ']' +
						$(varGravaCero).val()+']'+
						$(varPrecioUnitario).asNumber() + ']' +
						$(varImporte).asNumber()+']' );
			}else{
				$('#detalleFactura').val($('#detalleFactura').val() + '[' +
						$(varTipoGastoID).val() + ']' +
						$(varCentroCostoID).val() + ']' +
						$(varCantidad).asNumber() + ']' +
						$(varDescripcion).val() + ']' +
						$(varGravable).val() + ']' +
						$(varGravaCero).val()+']'+
						$(varPrecioUnitario).asNumber() + ']' +
						$(varImporte).asNumber() + ']' );
			}
		}
	}
	return enviar;
}


	// funcion que crea la lista que guardara el grid para los impuestos
	function guardaDetalleImp(){
		var varImporteImpuesto = "";
		var varImpuestoID = "";
		var varnoPartidaID ="";
		var varCentroCostoID = "";

		var numDetalle = $('input[name=consecutivoID]').length;
		$('#detalleFacturaImp').val("");
		for(var i = 1; i <= numDetalle; i++){

			for (var j = 0; j < impuestosProv.length; j++){
				var impuestoID = impuestosProv[j];


					varImporteImpuesto 	= eval("'#importeImpuesto-"+i+"-"+impuestoID.impuestoID+"'");
					varImpuestoID 		= eval("'#impuestoID-"+i+"-"+impuestoID.impuestoID+"'");
					varnoPartidaID		= eval("'#noPartidaID"+i+"'");
					varCentroCostoID 	= eval("'#centroCostoID"+i+"'");

					$(varnoPartidaID).val(i);

					if(j == 0){
						$('#detalleFacturaImp').val($('#detalleFacturaImp').val() + '[' +
								$(varnoPartidaID).asNumber() + ']' +
								$(varImpuestoID).asNumber()+']' +
								$(varImporteImpuesto).asNumber()+ ']'  +
								$(varCentroCostoID).asNumber()+ ']');


					}else{
						$('#detalleFacturaImp').val($('#detalleFacturaImp').val() + '[' +
								$(varnoPartidaID).asNumber() + ']' +
								$(varImpuestoID).asNumber() + ']' +
								$(varImporteImpuesto).asNumber() + ']' +
								$(varCentroCostoID).asNumber()+ ']');

					}

			}

		}
	}



// funcion para validar los datos del grid
function verificarvacios(){
	var mostrarAlert= 1;
	var procede = 0;
	var numCodig = $('input[name=consecutivoID]').length;
	$('#detalleFactura').val("");
	for(var i = 1; i <= numCodig; i++){
		var idcc = eval("'#centroCostoID"+i+"'");
		if ( $.trim($(idcc).val()) ==""){
			$(idcc).focus();
			$(idcc).val("");
			$(idcc).addClass("error");
			if(mostrarAlert == 1){
				mensajeSis("Especifique Centro de Costos.");
				mostrarAlert = 0;
				i = 1000;
			}
			procede= 0;
		}else{
			var idtg = eval("'#tipoGastoID"+i+"'");
			if ( $.trim($(idtg).val()) =="" || isNaN($.trim($(idtg).val())) ){
				$(idtg).focus();
				$(idtg).val("");
				$(idtg).addClass("error");
				if(mostrarAlert == 1){
					mensajeSis("Especifique Tipo de Gasto.");
					mostrarAlert = 0;
					i = 1000;
				}
				procede= 0;
			}else{
				var idcan = eval("'#cantidad"+i+"'");
				if ( $(idcan).asNumber() <="0"){
					$(idcan).focus();
					$(idcan).val("");
					$(idcan).addClass("error");
					if(mostrarAlert == 1){
						mensajeSis("Especifique Cantidad.");
						mostrarAlert = 0;
						i = 1000;
					}
					procede= 0;
				}else{
					var iddes = eval("'#descripcion"+i+"'");
					if ( $.trim($(iddes).val()) ==""){
						$(iddes).focus();
						$(iddes).val("");
						$(iddes).addClass("error");
						if(mostrarAlert == 1){
							mensajeSis("Especifique Concepto.");
							mostrarAlert = 0;
							i = 1000;
						}
						procede= 0;
					}else{
						var idgra = eval("'#gravable"+i+"'");
						if ( $.trim($(idgra).val()) ==""){
							$(idgra).focus();
							$(idgra).val("");
							$(idgra).addClass("error");
							if(mostrarAlert == 1){
								mensajeSis("Especifique Grava.");
								mostrarAlert = 0;
								i = 1000;
							}
							procede= 0;
						}else{
							var idpun = eval("'#precioUnitario"+i+"'");
							if ( $(idpun).asNumber() =="0"){
								$(idpun).focus();
								$(idpun).val("");
								$(idpun).addClass("error");
								if(mostrarAlert == 1){
									mensajeSis("Especifique Precio Unitario.");
									mostrarAlert = 0;
									i = 1000;
								}
								procede= 0;
							}else{
								var idimp = eval("'#importe"+i+"'");
								if ( $(idimp).asNumber() ==""){
									$(idimp).focus();
									$(idimp).val("");
									$(idimp).addClass("error");
									if(mostrarAlert == 1){
										mensajeSis("Especifique Importe.");
										mostrarAlert = 0;
										i = 1000;
									}
									procede= 0;
								}else{
									procede= 1;
								}
							}
						}
					}
				}
			}
		}
	}// fin for
	return procede;
}

function deshabilitaDetalles(){
	$('input[name=consecutivoID]').each(function() {

		var jqTipoGasto = eval("'#" + this.id + "'");
		var numFila= $(jqTipoGasto).val();
		var jqtipoGastoID		= "tipoGastoID" + numFila;
		var jqdescripcion	 	= "descripcion" + numFila ;
		var jqgravable 		  	= "gravable" + numFila ;
		var jqprecioUnitario	= "precioUnitario" + numFila ;
		var jqcantidad			= "cantidad" + numFila;
		var jqGravaCero			= "gravaCero"+numFila;
		var jqcentroCostoID		= "centroCostoID"+numFila;


		desabilitaControlGrid(jqtipoGastoID);
		desabilitaControlGrid(jqdescripcion);
		desabilitaControlGrid(jqgravable);
		desabilitaControlGrid(jqprecioUnitario);
		desabilitaControlGrid(jqcantidad);
		desabilitaControlGrid(jqGravaCero);
		desabilitaControlGrid(jqGravaCero);
		desabilitaControlGrid(jqcentroCostoID);


	});
}

function desabilitaControlGrid(jqControl){
	deshabilitaControl(jqControl);
}

function habilitaDetalles(){
	$('input[name=consecutivoID]').each(function() {

		var jqTipoGasto = eval("'#" + this.id + "'");
		var numFila= $(jqTipoGasto).val();
		habilitaControl("tipoGastoID" + numFila);
		habilitaControl("descripcion" + numFila);
		habilitaControl("gravable" + numFila);
		habilitaControl("cantidad" + numFila);
		habilitaControl("gravaCero"+numFila);
		habilitaControl("centroCostoID"+numFila);
		habilitaControl("precioUnitario"+numFila);
		deshabilitaControl("importe"+numFila);
		habilitaControl("importeImpuesto"+numFila);
	});
}

function listaTipoGasto(idControl){
	var camposLista = new Array();
	var parametrosLista = new Array();
	camposLista[0] = "descripcionTG";
	parametrosLista[0] = document.getElementById(idControl).value;
	if(document.getElementById(idControl).value != ""){
		lista(idControl, '1', '1', camposLista, parametrosLista, 'requisicionTipoGastoListaVista.htm');
	}
}

function consultaTipoGasto(idControl){
	var jqTipoGasto =eval("'#tipoGastoID" + idControl + "'");
	var jqDescTipo = eval("'#descripTGasto" + idControl + "'");
	var numTipoGasto = $(jqTipoGasto).val();
	var tipoCon =1;
	setTimeout("$('#cajaLista').hide();", 200);
	if(numTipoGasto != '' && !isNaN(numTipoGasto) ){

		var RequisicionTipoGastoListaBean = {
				'tipoGastoID' : numTipoGasto
		};

		requisicionGastosServicio.consultaTipoGasto(tipoCon,RequisicionTipoGastoListaBean,function(tipoGastoCon){

			if(tipoGastoCon!=null){
				$(jqDescTipo).val(tipoGastoCon.descripcionTG);
			}else{
				mensajeSis("No existe el Tipo de Gasto");
				$(jqTipoGasto).focus();
				$(jqTipoGasto).val('');
			}
		});
	}
}

function validaCentroCostos(control){
	var jqCentro='';
	if(typeof(control)=='string'){
		jqCentro = eval("'#"+control+"'");
	}else{
		jqCentro = eval("'#"+control.id+"'");
	}
	var numcentroCosto = $(jqCentro).val();
	var tipoLista=1;

	setTimeout("$('#cajaLista').hide();", 200);
		if(numcentroCosto != '' && !isNaN(numcentroCosto) && esTab){
				var centroBeanCon = {
					'centroCostoID':numcentroCosto
			 };
			centroServicio.consulta(tipoLista,centroBeanCon,function(centro) {
					if(centro!=null){
					}else{
							mensajeSis('El Centro de Costo No Existe');
							$(jqCentro).val('');
							$(jqCentro).focus();
					}
				});
		}
}


function formatoMoneda(){
	$('input[name=consecutivoID]').each(function(){
		ID = this.id.substring(13);

		$('#importe'+ID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#precioUnitario'+ID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

		for (var i = 0; i < impuestosProv.length; i++){
			var impuestoID = impuestosProv[i];

			 $('#importeImpuesto-'+ID+'-'+impuestoID.impuestoID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});


		}
	});
}

function calculoSumas(){
	var	ID=0;
	var subTotalFinal 	= 0;
	var totalGravado 	= 0;
	var totalRetenido 	= 0;
	var importeTotal 	= 0;

	$('input[name=consecutivoID]').each(function(){
		ID = this.id.substring(13);

		var importeUnitario = $('#importe'+ID).asNumber();

		importeTotal+= parseFloat(importeUnitario);


		for (var i = 0; i < impuestosProv.length; i++){
			var impuestoID = impuestosProv[i];
			var gravaRet = impuestoID.gravaRetiene;
			var montoImpuesto = $('#importeImpuesto-'+ID+'-'+impuestoID.impuestoID).asNumber();
			 montoImpuesto= parseFloat(montoImpuesto);

			if(gravaRet == 'G'){
				totalGravado += montoImpuesto;

				}
			else if (gravaRet == 'R'){
				totalRetenido += montoImpuesto;
			}
		}
	});


	$('input[name=impuestoTotal]').each(function(){

		var IDCajitaImp =  this.id.substring(8);

		$(this.id).val("0.00");
		var acumuladoImp = 0;

		for (var i = 0; i < impuestosProv.length; i++){
			var impuestoID = impuestosProv[i];
			var idRen = 0;
			$('input[name=consecutivoID]').each(function(){
			idRen = this.id.substring(13);
				var montoImpuestoDet = $('#importeImpuesto-'+idRen+'-'+impuestoID.impuestoID).asNumber();
				montoImpuestoDet= parseFloat(montoImpuestoDet);

				if(impuestoID.impuestoID == IDCajitaImp){
					acumuladoImp = montoImpuestoDet + acumuladoImp;
					$('#impuesto'+impuestoID.impuestoID).val(acumuladoImp.toFixed(2));
					}
				});


		}
	});


	$('#monto').val(parseFloat(importeTotal.toFixed(2)));

	subTotalFinal = parseFloat(importeTotal.toFixed(2))+parseFloat(totalGravado.toFixed(2));

	$('#subTotal').val(subTotalFinal);
	var totalFin = subTotalFinal-parseFloat(totalRetenido.toFixed(2));

	$('#totalFactura').val(totalFin.toFixed(2));

	$('#totalGravable').val(parseFloat(importeTotal.toFixed(2)));
	/*Metodo que actualiza el campo saldo Factura con el valor del
	 total de la factura solo si no es pago anticipado*/

	actualizarSaldoFactura(totalFin.toFixed(2));

	$('#totalFactura').val(totalFin.toFixed(2));

	$('#totalFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

	if(($('#saldoFactura').asNumber()>0 && $('#prorrateoHecho').val()=='N' && !$('#prorrateoContable').is(':visible'))
				|| ($('#pagadaAntSI').is(':checked') && $('#prorrateoHecho').val()=='N' && (!$('#prorrateoContable').is(':visible')) ) ){
		$('#aplicaPro').show(500);
	}else{
		$('#aplicaPro').hide(500);
	}


	$('#saldoFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#subTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#totalFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});


	$('#trasladado').val(totalGravado.toFixed(2));
	$('#importeRetenido').val(totalRetenido.toFixed(2));

	$('#trasladado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#importeRetenido').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#importeImpuesto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

	if($('#pagadaAntSI').is(':checked')){
		$('#saldoFactura').val('0.00');
	}else if($('#pagadaAntNO').is(':checked')){
		$('#saldoFactura').val(totalFin.toFixed(2));
	}

	}



function calcularTotales(renglonID){
var	montoImp	= 0;
var	montoImporteSum	= 0;


var jqPrecioUni = eval("'#precioUnitario" +renglonID+ "'");
var jqCantidad = eval("'#cantidad" +renglonID+ "'");
var precioUni = $(jqPrecioUni).asNumber();

if(precioUni == '' ){
	precioUni = 0;
}

var cantidad = $(jqCantidad).asNumber();
var importe			= 0;

importe = precioUni.toFixed(2) * cantidad;
var jqGrava = eval("'#gravable" +renglonID+ "'");
var jqImporte = eval("'#importe" +renglonID+ "'");
var jqGravaCero = eval("'#gravaCero"+renglonID+"'");

$(jqImporte).val(importe);

montoImporteSum = (montoImporteSum+ parseFloat(importe.toFixed(2)));

for (var i = 0; i < impuestosProv.length; i++){
	var impuestoID = impuestosProv[i];
	var baseCalculo = impuestoID.baseCalculo;
	var impuestoCal = impuestoID.impuestoCalculo;

	if(baseCalculo == 'S'){
		montoImp = importe*impuestoID.tasa/100;
		$('#importeImpuesto-'+renglonID+'-'+impuestoID.impuestoID).val(montoImp);
		$('#impuestoID-'+renglonID+'-'+impuestoID.impuestoID).val(impuestoID.impuestoID);
	}
	else if(baseCalculo == 'I'){
		if(impuestoCal != impuestoID.impuestoID){
		var importeImp = $('#importeImpuesto-'+renglonID+'-'+impuestoCal).asNumber();
		montoImp = importeImp*impuestoID.tasa/100;
		 $('#importeImpuesto-'+renglonID+'-'+impuestoID.impuestoID).val(montoImp);
		 $('#impuestoID-'+renglonID+'-'+impuestoID.impuestoID).val(impuestoID.impuestoID);

		}
	}


	 $('#importeImpuesto-'+renglonID+'-'+impuestoID.impuestoID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

			if(($(jqGrava).val()=='S' && $(jqGravaCero).val()=='S') || $(jqGrava).val()=='N'){

				 $('#importeImpuesto-'+renglonID+'-'+impuestoID.impuestoID).val(0.00);
			}

}


calculoSumas();

agregaFormatoControles('gridDetalle');
guardaDetalleImp();
}

function agregatablaArrendam(){
	$('#Todo').hide();
	$('#Todo').html("");
	$('#arrendamiento').html("");
	$('#arrendamiento').show();
	var tablaImportes = '<table id="calculosar" align="right">';
	tablaImportes += '<tr  id="trMonto" >';
	tablaImportes += '<td class="label"> <label for="lblMonto">Monto: </label></td><td>';
	tablaImportes += '<input type="text" id="monto" style="text-align:right;" disabled="true"  readonly="true" name="monto" size="12" tabindex="25" /></td></tr>';
				for (var i = 0; i < impuestosProvGrav.length; i++){
				var objeImpuesto= impuestosProvGrav[i];
				var IDimpuesto = objeImpuesto.impuestoID;
				var descripcion = objeImpuesto.descripCorta;
	tablaImportes += '<tr id="trImpuesto'+IDimpuesto+'">';
	tablaImportes += '<td><label for="lblTrasladado'+IDimpuesto+'">'+descripcion+':</label></td>';
	tablaImportes += '<td><input type="text" id="impuesto'+IDimpuesto+'" style="text-align:right;" name="impuestoTotal" size="12" disabled="true" readOnly="readOnly" tabindex="26" /></td></tr>';
				};
	tablaImportes += '<tr id="trSubTotal" >';
	tablaImportes += '<td  class="label" ><label for="lblSubtotal">SubTotal: </label></td>';
	tablaImportes += '<td><input type="text" id="subTotal" disabled="true"  style="text-align:right;"  name="subTotal" path="subTotal" size="12" tabindex="27" /></td></tr>';
				for (var i = 0; i < impuestosProvRet.length; i++){
					var objeImpuestoRet= impuestosProvRet[i];
					var IDimpuestoRet = objeImpuestoRet.impuestoID;
					var descripcionRet = objeImpuestoRet.descripCorta;
	tablaImportes += '<tr id="trRetenido'+IDimpuestoRet+'">';
	tablaImportes += '<td><label for="lblRetenido'+IDimpuestoRet+'">'+descripcionRet+':</label></td>';
	tablaImportes += '<td><input type="text" id="impuesto'+IDimpuestoRet+'" style="text-align:right;" name="impuestoTotal" size="12" disabled="true" readOnly="readOnly" tabindex="28" /></td></tr>';
				};
	tablaImportes += '<tr id="trTotalFact" >';
	tablaImportes += '<td class="label"><label for="lblstotalFactura">Total Factura:</label></td>';
	tablaImportes += '<td><input type="text" id="totalFactura" disabled="true"  style="text-align:right;"  name="totalFactura" path="totalFactura" size="12" tabindex="30" esMoneda="true" /></td></tr>';
	tablaImportes += '</table>';
	tablaImportes += '</div>';

	$('#arrendamiento').append(tablaImportes);
	return false;
}


function agregaFormato(idControl){
	var jControl = eval("'#" + idControl + "'");

	$(jControl).bind('keyup',function(){
		$(jControl).formatCurrency({
			colorize: true,
			positiveFormat: '%n',
			roundToDecimalPlace: -1
		});
	});
	$(jControl).blur(function() {
		$(jControl).formatCurrency({
			positiveFormat: '%n',
			roundToDecimalPlace: 2
		});
	});
	$(jControl).formatCurrency({
		positiveFormat: '%n',
		roundToDecimalPlace: 2
	});


}

function inicializaValores(){
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('cancelar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	$('#impPoliza').show();
	$('#enviarUUID').show();
	$('#estatus').val('A');
	escondeMensajeDeCancelacion();// esconde el mensaje de cancelacion
	escondefechaDeCancelacion();// esconde la fecha de cancelacion, se muestra solo en consulta
	$('#impPoliza').show();
	$('#totalFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#subTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#trasladado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#importeRetenido').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#impuestoTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#saldoFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#folioCargaID').val('0');
	$('#folioFacturaID').val('0');
	$('#mesSubirFact').val('0');
	deshabilitaDetalles();
	formatoMoneda();
}



function inicializaValoresForma(){
	$('#subTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#totalFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#trasladado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#impuestoTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#importeRetenido').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#saldoFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	formatoMoneda();
}

function inicializaValoresCancela(){
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('cancelar', 'submit');
	deshabilitaBoton('adjuntarImagen', 'submit');
	deshabilitaBoton('verImagen', 'submit');
	deshabilitaBoton('verArchivo', 'submit');
	deshabilitaBoton('adjuntarXML', 'submit');
	deshabilitaBoton('modificar', 'submit');
	$('#enviarUUID').hide();
	$('#impPoliza').hide();
	$('#estatus').val('A');
	$('#fechaFactura').val(varfechaAplicacion);
	$('#fechaProgPago').val(varfechaAplicacion);
	escondeMensajeDeCancelacion();// esconde el mensaje de cancelacion
	escondefechaDeCancelacion();// esconde la fecha de cancelacion, se muestra solo en consulta
	$('#totalFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#subTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#trasladado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#impuestoTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#importeRetenido').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#saldoFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	formatoMoneda();
}
///INICIO DE VALIDACIONES DEL GRID

$("#numeroDetalle").val($('input[name=consecutivoID]').length);

function validaDigitos(e){
	if(e.which!=0 && (e.which<48 || e.which>57)){
		return false;
		}
}


function eliminaDetalle(control){
	var numeroID = control.id;
	var jqTr = eval("'#renglon" + numeroID + "'");
	var jqTr2 = eval("'#renglonDescripcion" + numeroID + "'");

	var jqDesCuentaCompleta = eval("'#desCuentaCompleta" + numeroID + "'");
	var jqCentroCosto = eval("'#centroCostoID" + numeroID + "'");
	var jqConsecutivoID = eval("'#consecutivoID" + numeroID + "'");
	var jqTipoGastoID	= eval("'#tipoGastoID"+numeroID+"'");
	var jqDescripTGasto = eval("'#descripTGasto"+numeroID+"'");
	var jqCantidad		= eval("'#cantidad"+numeroID+"'");
	var jqCuentaCompleta = eval("'#cuentaCompleta" + numeroID + "'");
	var jqReferencia = eval("'#referencia" + numeroID + "'");
	var jqDescripcion = eval("'#descripcion" + numeroID + "'");
	var jqCargos = eval("'#cargos" + numeroID + "'");
	var jqAbonos = eval("'#abonos" + numeroID + "'");
	var jqElimina = eval("'#" + numeroID + "'");
	var jqAgrega = eval("'#agrega" + numeroID + "'");
	var jqGravable = eval("'#gravable"+numeroID+"'");
	var jqGravaCero = eval("'#gravaCero"+numeroID+"'");
	var jqPUni		= eval("'#precioUnitario"+numeroID+"'");
	var jqImporte	=eval("'#importe"+numeroID+"'");
	var jqImporteImpuesto =eval("'#importeImpuesto"+numeroID+"'");
	var jqImpuestoID =eval("'#impuestoID"+numeroID+"'");
	var jqNoPartidaID = eval("'#noPartidaID"+numeroID+"'");


	var jqConsecutivoIDSig = eval("'#consecutivoID" + String(eval(parseInt(numeroID)+1)) + "'");
	//Si es el primer Elemento
	if ($(jqConsecutivoID).attr("id") == $("input[name=consecutivoID]:first-child").attr("id")){
		$(jqConsecutivoIDSig).val("1");
	}else if($(jqConsecutivoIDSig).val()!= null && $(jqConsecutivoIDSig).val()!= undefined) {
		//Valida Antes de actualizar, que si exista un sig elemento
		for (var i=(parseInt(numeroID)+1);i<=$("#numeroDetalle").val();i++){
			jqConsecutivoIDSig = eval("'#consecutivoID" + i + "'");
			$(jqConsecutivoIDSig).val(numeroID);
			numeroID++;
		}
	}

	$(jqDesCuentaCompleta).remove();
	$(jqTr2).remove();

	$(jqTipoGastoID).remove();
	$(jqDescripTGasto).remove();
	$(jqCantidad).remove();
	$(jqPUni).remove();
	$(jqImporte).remove();
	$(jqImporteImpuesto).remove();
	$(jqImpuestoID).remove();
	$(jqNoPartidaID).remove();
	$(jqConsecutivoID).remove();
	$(jqCentroCosto).remove();
	$(jqCuentaCompleta).remove();
	$(jqReferencia).remove();
	$(jqDescripcion).remove();
	$(jqCargos).remove();
	$(jqAbonos).remove();
	$(jqElimina).remove();
	$(jqAgrega).remove();
	$(jqGravable).remove();
	$(jqGravaCero).remove();
	$(jqTr).remove();

	$('#numeroDetalle').val($('#numeroDetalle').val()-1);

	var arregloIDS=[];
	$('input[name=elimina]').each(function(){
		arregloIDS.push(this.id);
	});

	//Reordenamiento de Controles
	for(var i=1;i<=$('#numeroDetalle').val();i++){
		var jqConsecutivo = eval("'#consecutivoID" + arregloIDS[(i-1)] + "'");
		var jqCentroCosto = eval("'#centroCostoID" + arregloIDS[(i-1)] + "'");
		var jqTipoGastoID = eval("'#tipoGastoID"+ arregloIDS[(i-1)] +"'");
		var jqDescripTGasto = eval("'#descripTGasto"+ arregloIDS[(i-1)] +"'");
		var jqCantidad = eval("'#cantidad"+ arregloIDS[(i-1)] +"'");
		var jqDesCuentaCompleta = eval("'#desCuentaCompleta" + arregloIDS[(i-1)] + "'");
		var jqCuentaCompleta = eval("'#cuentaCompleta"+ arregloIDS[(i-1)] +"'");
		var jqReferencia = eval("'#referencia"+ arregloIDS[(i-1)] +"'");
		var jqDescripcion = eval("'#descripcion"+ arregloIDS[(i-1)] +"'");
		var jqGravable = eval("'#gravable"+ arregloIDS[(i-1)] +"'");
		var jqGravaCero = eval("'#gravaCero"+ arregloIDS[(i-1)] +"'");
		var jqPUni		= eval("'#precioUnitario"+arregloIDS[(i-1)]+"'");
		var jqImporte	=eval("'#importe"+arregloIDS[(i-1)]+"'");
		var jqCargos  = eval("'#cargos"+ arregloIDS[(i-1)] +"'");
		var jqAbonos = eval("'#abonos"+ arregloIDS[(i-1)] +"'");

		for (var h = 0; h < impuestosProv.length; h++){
			var impuestoID = impuestosProv[h];
			var jqImporteImpuesto =eval("'#importeImpuesto-"+arregloIDS[(i-1)]+"-"+impuestoID.impuestoID+"'");
			var jqImpuestoID =eval("'#impuestoID-"+arregloIDS[(i-1)]+"-"+impuestoID.impuestoID+"'");

				$(jqImporteImpuesto).attr("id", "importeImpuesto-" + i +"-"+impuestoID.impuestoID);
				$(jqImpuestoID).attr("id", "impuestoID-" + i +"-"+impuestoID.impuestoID);

		}

		var jqAgrega = eval("'#agrega"+ arregloIDS[(i-1)] +"'");
		var jqElimina = eval("'#"+ arregloIDS[(i-1)] +"'");
		var jqRenglon = eval("'#renglon"+ arregloIDS[(i-1)] +"'");
		var jqRenglonDescripcion = eval("'#renglonDescripcion"+ arregloIDS[(i-1)] +"'");
		var jqNoPartida = eval("'#noPartidaID"+ arregloIDS[(i-1)] +"'");

		$(jqConsecutivo).attr("id", "consecutivoID" + i);
		$(jqCentroCosto).attr({
			"id": "centroCostoID" + i,
			"onKeyUp": "listaCentroCostos(\'centroCostoID"+i+"\');",
			"onBlur":	"validaCentroCostos(\'centroCostoID"+i+"\');",
			"onKeyPress": "listaCentroCostos('centroCostoID"+i+"');"
		});

		$(jqTipoGastoID).attr({
			"id": ("tipoGastoID"+i),
			"onKeyUp":	'listaTipoGasto("tipoGastoID'+i+'");',
			"onBlur" :	'consultaTipoGasto('+i+');'
		});
		$(jqDescripTGasto).attr("id", "descripTGasto" + i);
		$(jqCantidad).attr({
			"id": ("cantidad" + i),
			"onBlur": "validaCantidad('cantidad"+i+"');"
		});
		$(jqDesCuentaCompleta).attr("id", "desCuentaCompleta" + i);
		$(jqCuentaCompleta).attr("id", "cuentaCompleta" + i);
		$(jqReferencia).attr("id", "referencia" + i);
		$(jqDescripcion).attr("id", "descripcion" + i);
		$(jqGravable).attr("id", "gravable" + i);
		$(jqGravaCero).attr("id", "gravaCero" + i);
		$(jqPUni).attr({
			"id": ("precioUnitario" + i),
			"onBlur":	"calcularTotales("+i+");validaPrecio('precioUnitario"+i+"');"
		});
		$(jqImporte).attr("id", "importe" + i);
		$(jqCargos).attr("id", "cargos" + i);
		$(jqAbonos).attr("id", "abonos" + i);
		$(jqAgrega).attr("id", "agrega" + i);
		$(jqElimina).attr("id", i);
		$(jqRenglon).attr("id", "renglon" + i);
		$(jqRenglonDescripcion).attr("id", "renglonDescripcion" + i);
		$(jqNoPartida).attr("id", "noPartidaID" + i);
		calcularTotales(i);

	}
	if($('#numeroDetalle').val()=='0'){
		agregaNuevoDetalle();
	}

	//Cuando elimina un detalle regresa el foco a el precio unitario del detalle anterior
	// e inicializa los campos de calculos
	var idAnterior = numeroID-1;
	var jqPU=eval("'#precioUnitario"+idAnterior+"'");
	$(jqPU).focus();

}

// funcionpara agregar un nuevo detalle
function agregaNuevoDetalle(){
	var numeroFila =0;
	$('tr[name=renglon]').each(function() {
		numeroFila++;
	});
	var nuevaFila = parseInt(numeroFila) + 1;
	$('#numeroDetalle').val(nuevaFila);
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	if(numeroFila == 0){
		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="1" autocomplete="off" disabled="true"  /></td>';
		tds += '<td><input type="text" id="centroCostoID'+nuevaFila+'" name="centroCostoID" size="10" value="" autocomplete="off"  onKeyUp="listaCentroCostos(\'centroCostoID'+nuevaFila+'\');" onblur="validaCentroCostos(\'centroCostoID'+nuevaFila+'\');" /></td>';

		tds += '<td nowrap="nowrap"><input type="text" id="tipoGastoID'+nuevaFila+'" name="tipoGastoID" size="10" value="" autocomplete="off" onkeyup="listaTipoGasto(\'tipoGastoID'+nuevaFila+'\');" onblur="consultaTipoGasto('+nuevaFila+');" />';
		tds += '<input type="text" id="descripTGasto'+nuevaFila+'" name="descripTGasto" size="35" disabled="true" /> </td>';
		tds += '<td><input type="text" id="cantidad'+nuevaFila+'" name="cantidad"  style="text-align:right;" size="15" onchange="calcularTotales('+nuevaFila+');" onBlur="validaCantidad(\'cantidad'+nuevaFila+'\');" /></td>';
		tds += '<td><input type="text" id="descripcion'+nuevaFila+'" name="descripcion" size="40" value="" autocomplete="off" onBlur=" ponerMayusculas(this);" maxlength="50"/></td>';
		tds += '<td><select id="gravable'+nuevaFila+'" name="gravable" onchange="calcularTotales('+nuevaFila+');desactivaGravaCero(this);">';
		tds += '<option value="S">SI</option>';
		tds += '<option value="N">NO</option>';
		tds += '</select></td>';
		tds += '<td><select id="gravaCero'+nuevaFila+'" name="gravaCero" onchange="calcularTotales('+nuevaFila+');" style="width:70px">';
		tds += '<option value="S">SI</option>';
		tds += '<option value="N" selected>NO</option> </td>';
		tds += '<td><input type="text" id="precioUnitario'+nuevaFila+'" name="precioUnitario"  style="text-align:right;" size="15" value="" autocomplete="off" esMoneda="true"  onblur="calcularTotales('+nuevaFila+')";validaPrecio(\'precioUnitario'+nuevaFila+'\'); " /></td>';
		tds += '<td nowrap="nowrap"><input type="text" id="importe'+nuevaFila+'" name="importe"  style="text-align:right;" size="15" value="" autocomplete="off"  esMoneda="true" disabled="true"/></td>';
		for (var i = 0; i < impuestosProv.length; i++){
			var impuestoID= impuestosProv[i].impuestoID;
			tds += '<td nowrap="nowrap"><input type="text" id="importeImpuesto-'+nuevaFila+'-'+impuestoID+'" name="importeImpuesto"  style="text-align:right;" onblur="calculoSumas();" size="15" value="" autocomplete="off"  esMoneda="true"  align="right" /><input type="hidden" id="impuestoID-'+nuevaFila+'-'+impuestoID+'" name="impuestoID"   size="5" value="" /><input type="hidden" id="noPartidaID'+nuevaFila+'" name="noPartidaID" size="5" value="" /></td>';
		};
		}else{

		var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="'+valor+'" autocomplete="off" disabled="true"  /></td>';
		tds += '<td><input type="text" id="centroCostoID'+nuevaFila+'" name="centroCostoID" size="10" value="" autocomplete="off"  onKeyUp="listaCentroCostos(\'centroCostoID'+nuevaFila+'\');" onblur="validaCentroCostos(\'centroCostoID'+nuevaFila+'\');" /></td>';
		tds += '<td nowrap="nowrap"><input type="text" id="tipoGastoID'+nuevaFila+'" name="tipoGastoID" size="10" value="" autocomplete="off" onkeyup="listaTipoGasto(\'tipoGastoID'+nuevaFila+'\');" onblur="consultaTipoGasto('+nuevaFila+');" />';
		tds += '<input type="text" id="descripTGasto'+nuevaFila+'" name="descripTGasto" size="35" disabled="true" /> </td>';
		tds += '<td><input type="text" id="cantidad'+nuevaFila+'" name="cantidad"  style="text-align:right;" size="15" onchange="calcularTotales('+nuevaFila+');" onBlur="validaCantidad(\'cantidad'+nuevaFila+'\');" /></td>';
		tds += '<td><input type="text" id="descripcion'+nuevaFila+'" name="descripcion" size="40" value="" autocomplete="off" onBlur=" ponerMayusculas(this);" maxlength="50"/></td>';
		tds += '<td><select id="gravable'+nuevaFila+'"onchange="calcularTotales('+nuevaFila+');desactivaGravaCero(this);">';
		tds += '<option value="S">SI</option>';
		tds += '<option value="N">NO</option>';
		tds += '</select></td>';
		tds += '<td><select id="gravaCero'+nuevaFila+'" name="gravaCero" onchange="calcularTotales('+nuevaFila+');" style="width:70px" >';
		tds += '<option value="S">SI</option>';
		tds += '<option value="N" selected>NO</option> </td>';
		tds += '<td><input type="text" id="precioUnitario'+nuevaFila+'" name="precioUnitario" style="text-align:right;" size="15" value="" autocomplete="off" esMoneda="true" onblur="calcularTotales('+nuevaFila+')"; validaPrecio(\'precioUnitario'+nuevaFila+'\');"  /></td>';
		tds += '<td nowrap="nowrap"><input type="text" id="importe'+nuevaFila+'" name="importe"  style="text-align:right;" size="15" value="0" autocomplete="off"  align="right" esMoneda="true" disabled="true"/></td>';
		for (var i = 0; i < impuestosProv.length; i++){
			var impuestoID= impuestosProv[i].impuestoID;

			if($("#estatus").val()!="I"){
				tds += '<td nowrap="nowrap">';
				tds += '<input type="text" id="importeImpuesto-'+nuevaFila+'-'+impuestoID+'" name="importeImpuesto" ';
				tds += ' style="text-align:right;" onblur="calculoSumas();" size="15" value="" autocomplete="off"  esMoneda="true" align="right" />';
				tds += ' <input type="hidden" id="impuestoID-'+nuevaFila+'-'+impuestoID+'" name="impuestoID"   size="5" value="" />';
				tds += ' <input type="hidden" id="noPartidaID'+nuevaFila+'" name="noPartidaID" size="5" value="" />';
				tds += '</td>';
			}else{
				tds += '<td nowrap="nowrap">';
				tds += '<input type="text" id="importeImpuesto-'+nuevaFila+'-'+impuestoID+'" name="importeImpuesto" ';
				tds += ' style="text-align:right;" onblur="calculoSumas();" size="15" value="" autocomplete="off"  esMoneda="true" align="right" />';
				tds += ' <input type="hidden" id="impuestoID-'+nuevaFila+'-'+impuestoID+'" name="impuestoID"   size="5" value='+impuestoID+' />';
				tds += ' <input type="hidden" id="noPartidaID'+nuevaFila+'" name="noPartidaID" size="5" value='+nuevaFila+' />';
				tds += '</td>';
			}

		};
	}
	tds += '<td nowrap="nowrap"><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaDetalle(this)"/>';
	tds += ' <input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>';
	tds += '</tr>';
	$("#miTabla").append(tds);

	agregaFormatoControles('gridDetalle');
	return false;
}
function desactivaGravaCero(control){
	var ID=control.id.substring(8);
	var controlID=eval("'#"+control.id+"'");
	var gravaCero=eval("'#gravaCero"+ID+"'");
	if($(controlID).val()=='N'){
		$(gravaCero).val('N');
		deshabilitaControl(('gravaCero'+ID));
	}else if($(controlID).val()=='S'){
		$(gravaCero).val('N');
		habilitaControl(('gravaCero'+ID));
	}
}


//funcion para mostrar la lista de Centro de Constos en el Grid de Detalle Factura  fcamacho
function listaCentroCostos(idControl){
	var jq = eval("'#" + idControl + "'");
	if(jq.length>2){
		var num = $(jq).val();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = num;

		lista(idControl, '2', '1', camposLista, parametrosLista, 'listaCentroCostos.htm');
	}
}

$("#agregaDetalle").click(function(){
	agregaNuevoDetalle();
});

function validaCantidad(idControl){
	var jControl = eval("'#" + idControl + "'");
	var valor = $(jControl).val();
	var valorNumero = $(jControl).asNumber();
	if(isNaN(valor) && valorNumero==0){
		$(jControl).val('');
		$(jControl).focus();
		$(jControl).select();
		$(jControl).addClass("error");
	}
}

function validaPrecio(idControl){
	var jControl = eval("'#" + idControl + "'");
	var valor = $(jControl).val();
	var valorNumero = $(jControl).asNumber();
	if(isNaN(valor) && valorNumero==0){
		$(jControl).val('');
		$(jControl).focus();
		$(jControl).select();
		$(jControl).addClass("error");
	}

}
function muestraMensajeDeCancelacion(){
	$('#labelMotivoCancel').show('slow');
	$('#trMotivoCancel').show('slow');
}

function escondeMensajeDeCancelacion(){
	$('#labelMotivoCancel').hide();
	$('#trMotivoCancel').hide();
	$('#motivoCancelacion').val('');
}

function escondefechaDeCancelacion(){
	$('#tdLabelFechCancela').hide();
	$('#tdFechCancelacion').hide();
	$('#fechaCancelacion').val('');
}

function muestrafechaDeCancelacion(){
	$('#tdLabelFechCancela').show();
	$('#tdFechCancelacion').show();
}


function actualizarSaldoFactura(totalFactura){
	if($('#pagadaAntSI').is(':checked')){
		$('#saldoFactura').val('0.00');
	}else if($('#pagadaAntNO').is(':checked')){
		$('#saldoFactura').val(totalFactura);
	}
	$('#saldoFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
}
/*funcion valida fecha formato (yyyy-MM-dd)*/
function esFechaValida(fecha){
	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
			return false;
		}

		var mes=  fecha.substring(5, 7)*1;
		var dia= fecha.substring(8, 10)*1;
		var anio= fecha.substring(0,4)*1;

		switch(mes){
		case 1: case 3:  case 5: case 7:
		case 8: case 10:
		case 12:
			numDias=31;
			break;
		case 4: case 6: case 9: case 11:
			numDias=30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
			break;
		default:
			mensajeSis("Fecha introducida errónea.");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida errónea.");
			return false;
		}
		return true;
	}
}

function comprobarSiBisisesto(anio){
	if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
		return true;
	}
	else {
		return false;
	}
}

function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
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

		function validaCuentaContable(idControl) {
				var numCtaContable = idControl;
				var conPrincipal = 1;
				var CtaContableBeanCon = {
						'cuentaCompleta':numCtaContable
				};
				esTab = true;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCtaContable != '' && !isNaN(numCtaContable) && esTab ){
					cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){
						if(ctaConta!=null){
						}
						else{
							mensajeSis("La Cuenta Contable del Proveedor no Existe.");
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('cancelar', 'submit');
							deshabilitaBoton('adjuntarImagen', 'submit');
							deshabilitaBoton('adjuntarXML', 'submit');
							deshabilitaBoton('verImagen', 'submit');
							deshabilitaBoton('verArchivo', 'submit');
							deshabilitaBoton('modificar', 'submit');
							escondefechaDeCancelacion();
							escondeMensajeDeCancelacion();
							$('#proveedorID').val("");
							$('#proveedorID').focus();
							$('#nombreProv').val("");
							$('#tipoProveedor').val("");
							$('#descripTipoProv').val("");
						}
					});
				}
			}
		function validaCuentaAnticipacion(idControl) {
			var numCtaContable = idControl;
			var tipConForanea = 2;
			var CtaContableBeanCon = {
					'cuentaCompleta':numCtaContable
			};
			esTab = true;
			setTimeout("$('#cajaLista').hide();", 200);
			if(numCtaContable != '' && !isNaN(numCtaContable) && esTab ){
				cuentasContablesServicio.consulta(tipConForanea,CtaContableBeanCon,function(ctaConta){
					if(ctaConta!=null){
						if(ctaConta.grupo != "E"){
					}
					else{
							mensajeSis("La Cuenta Contable del Proveedor no es de Detalle.");
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('cancelar', 'submit');
							deshabilitaBoton('adjuntarImagen', 'submit');
							deshabilitaBoton('adjuntarXML', 'submit');
							deshabilitaBoton('verImagen', 'submit');
							deshabilitaBoton('verArchivo', 'submit');
							deshabilitaBoton('modificar', 'submit');
							escondefechaDeCancelacion();
							escondeMensajeDeCancelacion();
							$('#proveedorID').val("");
							$('#proveedorID').focus();
							$('#nombreProv').val("");
							$('#tipoProveedor').val("");
							$('#descripTipoProv').val("");
					}
					}else {
							mensajeSis("La Cuenta Contable del Proveedor no Existe.");
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('cancelar', 'submit');
							deshabilitaBoton('adjuntarImagen', 'submit');
							deshabilitaBoton('adjuntarXML', 'submit');
							deshabilitaBoton('verImagen', 'submit');
							deshabilitaBoton('verArchivo', 'submit');
							escondefechaDeCancelacion();
							escondeMensajeDeCancelacion();
							$('#proveedorID').val("");
							$('#proveedorID').focus();
							$('#nombreProv').val("");
							$('#tipoProveedor').val("");
							$('#descripTipoProv').val("");
							deshabilitaBoton('modificar', 'submit');
					}
				});
			}
		}
//Regresar el foco a un campo de texto. Habia problemas al regresar el foco a un input en el nav. firefox
function regresarFoco(idControl){
	var jqControl=eval("'#"+idControl+"'");
	setTimeout(function(){
		$(jqControl).focus();
	 },0);
}
function ocultaLista(){
	setTimeout("$('#cajaLista').hide();", 200);
}



function validaFolio(folio) {
	var numFolio = $('#folioUUID').val() ;
	expr = /^([0-9A-K]{8}[-][0-9A-K]{4}[-][0-9A-K]{4}[-][0-9A-K]{4}[-][0-9A-K]{12})$/;

	if(numFolio != '' ){
    if (!expr.test(folio)) {
       mensajeSis("El Folio UUID no es válido");
    	$('#folioUUID').focus();
    	$('#folioUUID').select();
    	$('#folioUUID').val('');
     }
	}
}


var patronFolio = new Array(8,4,4,4,12)
function mascara(d,sep,pat,nums){

if(d.valant != d.value){

	valorFolio = d.value
	largo = valorFolio.length
	valorFolio = valorFolio.split(sep)
	valorFolio2 = ''
	for(r=0;r<valorFolio.length;r++){
		valorFolio2 += valorFolio[r]
	}

	valorFolio = ''
	valorFolio3 = new Array()
	for(s=0; s<pat.length; s++){
		valorFolio3[s] = valorFolio2.substring(0,pat[s])
		valorFolio2 = valorFolio2.substr(pat[s])
	}
	for(q=0;q<valorFolio3.length; q++){
		if(q ==0){
			valorFolio = valorFolio3[q]
		}
		else{
			if(valorFolio3[q] != ""){
				valorFolio += sep + valorFolio3[q]

				}
		}
	}
	d.value = valorFolio
	d.valant = valorFolio
	}
}

function funcionError(){
	$('#subTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#totalFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#trasladado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#impuestoTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#importeRetenido').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#saldoFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	formatoMoneda();
}
