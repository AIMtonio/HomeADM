var nomClavePresupID = "";

var catTipoTransaccionSuspCred = {
	'procesoSuspension' : '1',
};


$(document).ready(function(){
	esTab = true;

	$("#creditoID").focus();
	$("#fechaSuspension").val(parametroBean.fechaAplicacion);
	deshabilitaBoton('procesar', 'submit');
	agregaFormatoControles('formaGenerica');

	$.validator.setDefaults({submitHandler : function(event) {
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','creditoID','exitoTransParametro','falloTransParametro');
	}});

	/***********MANEJO DE EVENTOS******************/
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab = true;
		}
	});

	$('#procesar').click(function() {
		var fechaDefuncion = $('#fechaDefuncion').val();
		if(fechaDefuncion > parametroBean.fechaAplicacion){
			mensajeSis("La Fecha Defunción no Debe ser Mayor a la Fecha del Sistema.");
			$("#fechaDefuncion").focus();
			return false;
		}
		$('#tipoTransaccion').val(catTipoTransaccionSuspCred.procesoSuspension);
	});


/*========================================  CONSULTA DEL LISTADO DE PRODUCTO DE CREDITO ================================ */
	$('#creditoID').bind('keyup',function(e) {
		limpia();
		lista('creditoID', '2', '57','nombreCliente', $('#creditoID').val(),'ListaCredito.htm');
	});

	$('#creditoID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		limpia();
		var creditoID = $('#creditoID').val();
		if(esTab){
			if (creditoID != null && creditoID > 0){
				$("#fechaSuspension").val(parametroBean.fechaAplicacion);
				consultaCredito(this.id);
			}else if(creditoID != ""){
				mensajeSis("Espeficique un Número de Crédito Valido");
				$("#creditoID").focus();
				$("#creditoID").val("");
				deshabilitaBoton('procesar', 'submit');
			}
		}
	});

	$('#fechaDefuncion').blur(function(){
		var fechaDefuncion = $('#fechaDefuncion').val();
		if(esTab){
			if(fechaDefuncion > parametroBean.fechaAplicacion){
				mensajeSis("La Fecha Defunción no Debe ser Mayor a la Fecha del Sistema.");
				$("#fechaDefuncion").focus();
			}
		}
	});

	$('#formaGenerica').validate({
		rules : {
			creditoID: {
				required: true
			},
			fechaDefuncion: {
				required: true
			},
			folioActa: {
				required: true
			},
			observDefuncion: {
				required: true
			}
		},

		messages : {
			creditoID: {
				required: 'Especifique el Número de Crédito.'
			},
			fechaDefuncion: {
				required: 'Especifique la Fecha Defunción.'
			},
			folioActa: {
				required: 'Especifique el Folio de Acta.'
			},
			observDefuncion: {
				required: 'Especifique la Observación de la Defunción'
			}
		}
	});
});

	function exitoTransParametro(){
		deshabilitaBoton('procesar','submit');
		$("#creditoID").focus();
	}

	function falloTransParametro(){

	}

	/* ======= FUNCION DE CONSULTA INFORMACION DE CREDITO ========= */
	function consultaCredito(controlID){
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito)){
			var creditoBeanCon = { 
				'creditoID': numCredito
			};
			creditosServicio.consulta(48,creditoBeanCon,function(credito) {
				if(credito!=null){
					$("#productoCreditoID").val(credito.producCreditoID);
					$("#descProducto").val(credito.nombreProducto);
					$("#clienteID").val(credito.clienteID);
					$("#nombreCliente").val(credito.nombreCompleto);
					var descEstatus = "";
				
					if(credito.estatus == "I" ){
						mensajeSis("El Crédito Se Encuentra Inactivo.");
						deshabilitaBoton('procesar','submit');
						descEstatus = "INACTIVO";
						$("#creditoID").focus();
					}
					if(credito.estatus == "A" ){
						mensajeSis("El Crédito Aun no se Encuentra Vigente.");
						deshabilitaBoton('procesar','submit');
						descEstatus = "AUTORIZADO";
						$("#creditoID").focus();
					}
					if(credito.estatus == "V" ){
						habilitaBoton('procesar','submit');
						descEstatus = "VIGENTE";
					}
					if(credito.estatus == "P" ){
						mensajeSis("El Crédito ya se Encuentra Pagado.");
						deshabilitaBoton('procesar','submit');
						descEstatus = "PAGADO";
						$("#creditoID").focus();
					}
					if(credito.estatus == "C" ){
						mensajeSis("El Crédito se Encuentra Cancelado.");
						deshabilitaBoton('procesar','submit');
						descEstatus = "CANCELADO";
						$("#creditoID").focus();
					}
					if(credito.estatus == "B" ){
						habilitaBoton('procesar','submit');
						descEstatus = "VENCIDO";
					}
					if(credito.estatus == "K" ){
						mensajeSis("El Crédito se Encuentra Castigado.");
						deshabilitaBoton('procesar','submit');
					}
					if(credito.estatus == "S" ){
						consultaInfCreditoSusp();
						descEstatus = "SUSPENDIDO";
						mensajeSis("El Crédito ya se Encuentra Suspendido.");
						$("#creditoID").focus();
						deshabilitaBoton('procesar','submit');
					}

					$("#estatus").val(descEstatus);
					$("#montoCredito").val(credito.montoCredito);
					$("#convenioNominaID").val(credito.convenioNominaID);
					$("#descConvenioNomina").val(credito.desConvenio);
					$("#fechaInicio").val(credito.fechaInicio);
					$("#fechaVencimiento").val(credito.fechaVencimien);
					$("#diaAtraso").val(credito.diasAtraso);
					
					consultaSaldoCredito(this.id);
				}else{
					inicializaForma('formaGenerica','creditoID');
					mensajeSis("EL Número de Crédito no Existe.");
					deshabilitaBoton('procesar','submit');
					$("#creditoID").focus();
				}
			});
		}
	}
	
	/* ======= FUNCION DE CONSULTA DE SALDO DEL CREDITO ========= */
	function consultaSaldoCredito(controlID){
		var numCredito = $('#creditoID').val();
		if(numCredito != '' && !isNaN(numCredito)){
			var creditoBeanCon = { 
				'creditoID': numCredito
			};
			creditosServicio.consulta(17,creditoBeanCon,function(creditoBean) {
				if(creditoBean!=null){
					$("#totalAdeudo").val(creditoBean.adeudoTotal);
					$("#totalSalCapital").val(creditoBean.totalCapital);
					$("#totalSalInteres").val(creditoBean.totalInteres);
					$("#totalSalMoratorio").val(creditoBean.saldoMoratorios);
					$("#totalSalComisiones").val(creditoBean.totalComisi);
				}
			});
		}
	}
	
	/* ======= FUNCION DE CONSULTA DE SALDO DEL CREDITO ========= */
	function consultaInfCreditoSusp(){
		var numCredito = $('#creditoID').val();
		if(numCredito != '' && !isNaN(numCredito)){
			var creditoBeanCon = { 
				'creditoID': numCredito
			};
			carCreditoSuspendidoServicio.consulta(1,creditoBeanCon,function(credSuspendido) {
				if(credSuspendido!=null){
					$("#fechaSuspension").val(credSuspendido.fechaSuspencion);
					$("#fechaDefuncion").val(credSuspendido.fechaDefuncion);
					$("#folioActa").val(credSuspendido.folioActa);
					$("#observDefuncion").val(credSuspendido.observDefuncion);

					deshabilitaControl('fechaDefuncion');
					deshabilitaControl('folioActa');
					deshabilitaControl('observDefuncion');
				}else{
					$("#fechaSuspension").val("");
					$("#fechaDefuncion").val("");
					$("#folioActa").val("");
					$("#observDefuncion").val("");
					habilitaControl('fechaDefuncion');
					habilitaControl('folioActa');
					habilitaControl('observDefuncion');
				}
			});
		}
	}
	
	/* ============= FUNCION LIMPIA ========== */
	function limpia(){
		$("#productoCreditoID").val("");
		$("#descProducto").val("");
		$("#clienteID").val("");
		$("#nombreCliente").val("");
		$("#estatus").val("");
		$("#montoCredito").val("");
		$("#convenioNominaID").val("");
		$("#descConvenioNomina").val("");
		$("#fechaInicio").val("");
		$("#fechaVencimiento").val("");
		$("#diaAtraso").val("");
		$("#totalAdeudo").val("");
		$("#totalSalCapital").val("");
		$("#totalSalInteres").val("");
		$("#totalSalMoratorio").val("");
		$("#totalSalComisiones").val("");
		$("#fechaSuspension").val("");
		$("#fechaDefuncion").val("");
		$("#folioActa").val("");
		$("#observDefuncion").val("");
		habilitaControl('fechaDefuncion');
		habilitaControl('folioActa');
		habilitaControl('observDefuncion');
		deshabilitaBoton('procesar','submit');
	}