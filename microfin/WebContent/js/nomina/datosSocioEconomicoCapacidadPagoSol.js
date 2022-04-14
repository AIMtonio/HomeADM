var estatus = "";
var catTipoTransaccionTipoClav = {
	'agrega' : '1',
	'modifica' : '2',
	'calculaCapacidadPag' : '3'
};
var tipoHabilita;
var listaClasifClavPresup = "";
$(document).ready(function(){
	esTab = true;

	agregaFormatoControles('formaGenerica');
	$("#solicitudCreditoID").focus();
	deshabilitaBoton('graba', 'submit');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('calculrCapc', 'submit');

	$.validator.setDefaults({submitHandler : function(event) {
			$('#valorCapacidadPago').val($('#valorCapacidadPago').val().replace(",",""));
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','numeros','exitoTransParametro','falloTransParametro');
		}
	});

	/***********MANEJO DE EVENTOS******************/
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab = true;
		}
	});

	$('#calculrCapc').click(function() {
		var capacidadCadena = cadenaTotales();

		if (capacidadCadena != ""){
			$('#tipoTransaccion').val(catTipoTransaccionTipoClav.calculaCapacidadPag);
		}else{
			mensajeSis("La Solicitud de Crédito no tiene Registro de Información Economica");
		}
	});

	$('#graba').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionTipoClav.agrega);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionTipoClav.modifica);
	});

	if( $('#numSolicitud').val() != "" ){
		var numSolicitud=  $('#numSolicitud').val();
		$('#solicitudCreditoID').val(numSolicitud);
		$('#solicitudCreditoID').focus();
		consultaInfoSolicitudCred(this.id);
	}

/*========================================  CONSULTA DEL LISTADO DE SOLICITUD DE CREDITO ================================ */
	$("#solicitudCreditoID").bind('keyup',function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "clienteID";
		parametrosLista[0] = $("#solicitudCreditoID").val();

		lista('solicitudCreditoID', '2', '19',camposLista, parametrosLista,'listaSolicitudCredito.htm');
	});

	$('#solicitudCreditoID').blur(function(){
		var solicitudCreditoID = $('#solicitudCreditoID').val();

		if(esTab){
			if(solicitudCreditoID != null && solicitudCreditoID > 0){
				consultaInfoSolicitudCred(this.id);
			}else if (solicitudCreditoID != "" ){
				$('#gridClasifClavePresupConv').hide();
				inicializaForma('formaGenerica');
				deshabilitaBoton('graba', 'submit');
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('calculrCapc', 'submit');
				mensajeSis("Espeficique Número de Solicitud de Crédito Valido");
			}
		}
	});

	$('#formaGenerica').validate({
		rules : {

		},

		messages : {

		}
	});
});

	function exitoTransParametro(){
		agregaFormatoControles('formaGenerica');
		if ($('#tipoTransaccion').val() == catTipoTransaccionTipoClav.calculaCapacidadPag) {
			$('#valorCapacidadPago').val($('#consecutivo').val());
			$('#valorCapacidadPago').formatCurrency({positiveFormat: '%n',negativeFormat: '-%n', roundToDecimalPlace: 2});
			if (tipoHabilita == 1){
				habilitaBoton('modifica', 'submit');
			}else{
				habilitaBoton('graba', 'submit');
			}
		}else{
			$('#gridClasifClavePresupConv').hide();
			$(".blockUI").css({top: "0px"});
			$("#mensaje").css({top: "100px", left: "5px", width:"250px", position:'absolute'});
			inicializaForma('formaGenerica');
			$('#solicitudCreditoID').val($('#consecutivo').val());
			$('#valorCapacidadPago').val('');
			deshabilitaBoton('graba', 'submit');
			deshabilitaBoton('modifica', 'submit');
			deshabilitaBoton('calculrCapc', 'submit');
		}
	}

	function falloTransParametro(){
		agregaFormatoControles('formaGenerica');
	}

	/*==================  FUNCIONALIDAD QUE CONSULTA DE LA INFORMACION DE SOLICITUD DE CREDITO ===================== */
	function consultaInfoSolicitudCred(control) {
		var solicitudCreditoID = $('#solicitudCreditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(solicitudCreditoID != '' && !isNaN(solicitudCreditoID)){
			var solicitudBean = { 
				'solicitudCreditoID': solicitudCreditoID
			};
			
			solicitudCredServicio.consulta(16,solicitudBean, { async: false, callback: function(solicitudCred) {
				if(solicitudCred != null){
					$('#prospectoID').val(solicitudCred.prospectoID);
					if(solicitudCred.prospectoID > 0){
						consultaProspecto();
					}
					consultaDatosSocioEconomicoCapacidadPagoSol(solicitudCred.solicitudCreditoID);
					$('#estatus').val(solicitudCred.estatus);
					$('#montoResguardoConvenio').val(solicitudCred.resguardo);
					$('#porcentajeCapacidad').val(solicitudCred.porcentajeCapacidad);
					$('#clienteID').val(solicitudCred.clienteID);
					$('#nombreCliente').val(solicitudCred.nombreCompletoCliente);
					$('#productoCreditoID').val(solicitudCred.productoCreditoID);
					if(solicitudCred.productoCreditoID > 0){
						consultaProducCreditoForanea(solicitudCred.productoCreditoID);
					}
					$('#convenioNominaID').val(solicitudCred.convenioNominaID);
					$('#descConvenioNomina').val(solicitudCred.descripcionConvenio);
					$('#institNominaID').val(solicitudCred.institucionNominaID);
					$('#nombreInstit').val(solicitudCred.nombreInstit);
					$('#noEmpleado').val(solicitudCred.noEmpleado);

					var tipoCredito = "";
					if(solicitudCred.tipoCredito == "N") {
						tipoCredito = 'NUEVO';
					}
					if(solicitudCred.tipoCredito == "O") {
						tipoCredito = 'RENOVACIÓN';
					}
					if(solicitudCred.tipoCredito == "R") {
						tipoCredito = 'REESTRUCTURA';
					}
					if(solicitudCred.tipoCredito == "C") {
						tipoCredito = 'CONSOLIDACIÓN';
					}
					$('#tipoCreditoID').val(solicitudCred.tipoCredito);
					$('#tipoCredito').val(tipoCredito);
					$('#tipoEmpleado').val(solicitudCred.tipoEmpleado);
					$('#montoSolici').val(solicitudCred.montoSolici);

					consultaSucursal(solicitudCred.sucursalID);
					$('#fechaRegistro').val(solicitudCred.fechaRegistro);

					consultaGridClasifClavePresupConvSol(solicitudCred.institucionNominaID,solicitudCred.convenioNominaID, solicitudCred.solicitudCreditoID);

					if ($('#estatus').val() == "A" ) {
						deshabilitaBoton('graba', 'submit');
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('calculrCapc', 'submit');
					}

				}else{
					mensajeSis('El Número de Solicitud de Crédito no Existe');
					$('#gridClasifClavePresupConv').hide();
					inicializaForma('formaGenerica');
					deshabilitaBoton('graba', 'submit');
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('calculrCapc', 'submit');
				}
			}}); 
		}
	}

	/* ==================== CONSULTA DE LA DESCRIPCION DEL PROSPECTO ==============*/
	function consultaProspecto() {
		var prospectoID = $('#prospectoID').val();

		var prospectoBeanCon = {
			'prospectoID' : prospectoID
		};

		if (prospectoID != '' && !isNaN(prospectoID) && prospectoID > 0) {
				prospectosServicio.consulta(2, prospectoBeanCon, { async: false,callback : function(prospectos) {
				if (prospectos != null) {
					$('#descProspecto').val(prospectos.nombreCompleto);
				} else {
					mensajeSis("No Existe el Prospecto");
				}
			}});
		}
	}

	/* ==================== CONSULTA DE LA DESCRIPCION DEL PRODUCTO DE CREDITO ==============*/
	function consultaProducCreditoForanea(producto) {
		var ProdCredBeanCon = {
			'producCreditoID' : producto
		};

		if (producto != '' && !isNaN(producto)) {
			productosCreditoServicio.consulta(2, ProdCredBeanCon,{ async: false,callback : function(prodCred) {
				if (prodCred != null) {
					$('#descProductoCredito').val(prodCred.descripcion);
				} else {
					mensajeSis("No Existe el Producto de Crédito");
				}
			}});
		}
	}

	/* =========== CONSULTA DE LA DESCRIPCION DE LA SUCURSAL ============ */
	function consultaSucursal(sucursalID) {
		var numSucursal = sucursalID;
		var conSucursal = 2;

		if (numSucursal != '' && !isNaN(numSucursal) && numSucursal > 0) {
			sucursalesServicio.consultaSucursal(conSucursal, numSucursal,{ async: false,callback : function(sucursal) {
				if (sucursal != null) {
					$('#descSucursal').val(sucursal.nombreSucurs);
				}else {
					mensajeSis("El Número de la Sucursal No Existe.");
				}
			}});
		}
	}

	/* ======== FUNCION CONSULTAR GRID CLASIFICACION DE CLAVE PRESUPUESTAL POR SOLICITUD DE CREDITO ==========*/
	function consultaGridClasifClavePresupConvSol(institNominaID,convenioID,solicitudCreditoID){
		var params = { };

		if ($('#estatus').val() == "A"){
			params['tipoLista'] = 1;
			params['nomCapacidadPagoSolID'] = $('#nomCapacidadPagoSolID').val();
		}else{
			params['tipoLista'] = 3;
		}

		params['institNominaID'] = institNominaID;
		params['convenioID'] = convenioID;
		params['solicitudCreditoID'] = solicitudCreditoID;

		$.post("clasifClavePresupConvSolGridVista.htm", params, function(data){
			if(data.length > 0) {
				$('#gridClasifClavePresupConv').html(data);
				$('#gridClasifClavePresupConv').show();
				agregaFormatoControles('gridClasifClavePresupConv');
			}else{
				$('#gridClasifClavePresupConv').html("");
				$('#gridClasifClavePresupConv').show();
			}
		});
	}

	/* ===================== METODO DE SUMA DE TOTALES DE LOS IMPORTE POR SU CLASIFICACION ================ */
	function sumaTotalImporte (control, id){
		var numCodig = $('#numClaveConv' + id).val();
		var jqTotalImporte = eval("'totalImporte" + id+ "'");

		var totalImporte = parseFloat(0);
		var importe  = parseFloat(0);

		for(var i = 1; i <= numCodig; i++){
			importe  = parseFloat(0);
			var jqImporte = eval("'" + id +"importe" + i+ "'");
				importe = document.getElementById(jqImporte).value;
				importe = importe.replace(/,/g, "");

			if(importe != "" && importe != null && importe > 0 ){
				importe = parseFloat(importe);
			}else{
				importe = parseFloat(0);
			}

			totalImporte = totalImporte + importe;
		}

		$('#' + jqTotalImporte).val(totalImporte);
		$('#' + jqTotalImporte).formatCurrency({
					positiveFormat: '%n',
					roundToDecimalPlace: 2
		});
	}

	/* ================ METODO PARA COCATENAR LA CADENA DE CLASIFICACIONE SCON SU MONTO PARA EL CALCULO DE CAPACIDAD ============= */
	function cadenaTotales(){
		listaClasifClavPresup = "";
		$('#listaClasifClavPresup').val("");
		var numero = $('#numero').val();
		for(var i = 1; i <= numero; i++){
			var jqNomClasifClavPresupID = eval("'nomClasifClavPresupID" + i + "'");
			nomClasifClavPresupID = document.getElementById(jqNomClasifClavPresupID).value;

			var jqTotalImporte = eval("'totalImporte" + nomClasifClavPresupID + "'");
			var totalImporte = document.getElementById(jqTotalImporte).value;
				totalImporte = totalImporte.replace(/,/g, "");

			if(totalImporte != "" && totalImporte != null && totalImporte > 0 ){
				totalImporte = parseFloat(totalImporte);
			}else{
				totalImporte = parseFloat(0);
			}

			var cadena = nomClasifClavPresupID + "-" + totalImporte + ",";

			listaClasifClavPresup += cadena;
		}

		// RESGUARDO
		var resguardoRG = $('#resguardoRG').val();
		var totalImporteRG = $('#totalImporteRG').val();
			totalImporteRG = totalImporteRG.replace(/,/g, "");

		if(totalImporteRG != "" && totalImporteRG != null && totalImporteRG > 0 ){
			totalImporteRG = parseFloat(totalImporteRG);
		}else{
			totalImporteRG = parseFloat(0);
		}	
			
		var cadenaRG = resguardoRG + "-" + totalImporteRG + ",";

		listaClasifClavPresup += cadenaRG;

		// DEUDA DE CASA COMERCIAL
		var resguardoDC = $('#resguardoDC').val();
		var totalImporteDC = $('#totalImporteDC').val();
			totalImporteDC = totalImporteDC.replace(/,/g, "");

		if(totalImporteDC != "" && totalImporteDC != null && totalImporteDC > 0 ){
			totalImporteDC = parseFloat(totalImporteDC);
		}else{
			totalImporteDC = parseFloat(0);
		}				
		var cadenaDC = resguardoDC + "-" + totalImporteDC + ",";
		
		listaClasifClavPresup += cadenaDC;

		// porcentaje de capacidad de pago
		var porcentajeCapacidad =  $('#porcentajeCapacidad').val();
		if(porcentajeCapacidad != "" && porcentajeCapacidad != null && porcentajeCapacidad > 0 ){
			porcentajeCapacidad = parseFloat(porcentajeCapacidad);
		}else{
			porcentajeCapacidad = parseFloat(0);
		}
		listaClasifClavPresup += "PC" + "-" + porcentajeCapacidad + ",";

		$('#listaClasifClavPresup').val(listaClasifClavPresup);
		return listaClasifClavPresup; 
	}

	/* ==================== CONSULTA DE LOS DATOS SOCIO ECONOMICOS CAPACIDAD PAGO ==============*/
	function consultaDatosSocioEconomicoCapacidadPagoSol(solicitudCreditoID) {
		var solicitudCreditoBean = {
			'solicitudCreditoID' : solicitudCreditoID
		};
		
		if (solicitudCreditoID != '' && !isNaN(solicitudCreditoID) && solicitudCreditoID > 0) {
			nomCapacidadPagoSolServicio.consulta(2, solicitudCreditoBean,{ async: false,callback : function(solicitudCredito) {
	
				if (solicitudCredito != null) {
					$('#nomCapacidadPagoSolID').val(solicitudCredito.nomCapacidadPagoSolID);
					$('#valorCapacidadPago').val(solicitudCredito.capacidadPago);
					$('#valorCapacidadPago').formatCurrency({positiveFormat: '%n',negativeFormat: '-%n', roundToDecimalPlace: 2});
					$('#porcentajeCapacidad').val(solicitudCredito.porcentajeCapacidad);
					
					if(solicitudCredito.montoResguardo > 0){
						$('#importeRG').val(solicitudCredito.importeRG);
						$('#totalImporteRG').val(solicitudCredito.totalImporteRG);
					}
					tipoHabilita = 1;
					deshabilitaBoton('graba', 'submit');
					habilitaBoton('calculrCapc', 'submit');
					
				} else{
					$('#nomCapacidadPagoSolID').val(0);
					$('#valorCapacidadPago').val('');
					tipoHabilita = 2;
					deshabilitaBoton('modifica', 'submit');
					habilitaBoton('calculrCapc', 'submit');
				}
			}});
		}
	}
