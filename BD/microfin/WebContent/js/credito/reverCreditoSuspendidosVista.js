var nomClavePresupID = "";

var catTipoTransaccionReverSuspCred = {
	'procesoReverSuspencion': '2'
};


$(document).ready(function(){
	esTab = true;

	$("#creditoID").focus();
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
		$('#tipoTransaccion').val(catTipoTransaccionReverSuspCred.procesoReverSuspencion);
	});


/*========================================  CONSULTA DEL LISTADO DE PRODUCTO DE CREDITO ================================ */
	$('#creditoID').bind('keyup',function(e) {
		limpia();
		lista('creditoID', '1', '1','nombreCliente', $('#creditoID').val(),'listaCreditoSusp.htm');
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
});

	$('#formaGenerica').validate({
		rules : {
			creditoID: {
				required: true
			}
		},
	
		messages : {
			creditoID: {
				required: 'Especifique el Número de Crédito.'
			}
		}
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
						descEstatus = "AUTORIZADO";
						deshabilitaBoton('procesar','submit');
						$("#creditoID").focus();
					}
					if(credito.estatus == "V" ){
						descEstatus = "VIGENTE";
						deshabilitaBoton('procesar','submit');
					}
					if(credito.estatus == "P" ){
						mensajeSis("El Crédito ya se Encuentra Pagado.");
						deshabilitaBoton('procesar','submit');
						descEstatus = "PAGADO";
						$("#creditoID").focus();
					}
					if(credito.estatus == "C" ){
						mensajeSis("El Crédito se Encuentra Cancelado.");
						descEstatus = "CANCELADO";
						deshabilitaBoton('procesar','submit');
						$("#creditoID").focus();
					}
					if(credito.estatus == "B" ){
						descEstatus = "VENCIDO";
						deshabilitaBoton('procesar','submit');
					}
					if(credito.estatus == "K" ){
						descEstatus = "CASTIGADO";
						deshabilitaBoton('procesar','submit');
					}
					
					if(credito.estatus == "S" ){
						consultaInfCreditoSusp();
						descEstatus = "SUSPENDIDO";
						var fechaSuspension = $('#fechaSuspension').val();
						if(fechaSuspension == parametroBean.fechaAplicacion){
							habilitaBoton('procesar','submit');
						}else{
							mensajeSis("El Crédito solo puede ser reversado el mismo día que se realizo la suspención.");
							deshabilitaBoton('procesar','submit');
						}
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
					$("#folioActa").val(credSuspendido.folioActa);
					$("#observDefuncion").val(credSuspendido.observDefuncion);

					deshabilitaControl('folioActa');
					deshabilitaControl('observDefuncion');
				}else{
					$("#fechaSuspension").val("");
					$("#folioActa").val("");
					$("#observDefuncion").val("");
					habilitaControl('folioActa');
					habilitaControl('observDefuncion');
				}
			});
		}
	}
	
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
		$("#folioActa").val("");
		$("#observDefuncion").val("");
		habilitaControl('folioActa');
		habilitaControl('observDefuncion');
		deshabilitaBoton('procesar','submit');
	}