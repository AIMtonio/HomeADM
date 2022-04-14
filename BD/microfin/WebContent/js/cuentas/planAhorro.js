var parametroBean = consultaParametrosSession(); 
var fechaSistema = parametroBean.fechaAplicacion;

$(document).ready(function(){
	var tipoCuentaAhoID = 0;
	var maxFoliosPlanAho = 0;
	var saldoDisponCliente = 0.0;

	$("#tipoTransaccion").val(1);

	agregaFormatoControles('formaGenerica');
	inicializaForma();
	consultaPlanesAhorro();

	$("#clienteID").focus();

	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
   	});

	$("#clienteID").blur(function(){
		validaClienteID();
		inicializaFormaCliente();
	});

	$('#cuentaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#clienteID').val();

		lista('cuentaID', '2', '9', camposLista,parametrosLista,'cuentasAhoListaVista.htm');
   	});

	$("#cuentaID").blur(function(){
		validaCuentaID();
	});

	$("#planID").blur(function(){
		validaPlanID();

	});

	$("#serie").blur(function(){
		calculaFolios($("#serie").asNumber(),saldoDisponCliente);
	});

	$("#montoDep").blur(function(){
		calculaFolios(0,$("#montoDep").asNumber());
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			if( $("#serie").asNumber() != 0 &&	$("#montoDep").asNumber()!= 0){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','numeroTransaccion','consultaExitosa','consultaFallida');
			}
		}
	});

	$('#formaGenerica').validate({
		rules:{
			clienteID : {
				required : true
			},
			cuentaID : {
				required : true
			},
			planID : {
				required : true
			},
			serie : {
				required : true
			},
			montoDep : {
				required : true
			}
		},
		messages:{
			clienID : {
				required : "Especificar el número de cliente."
			},
			cuentaID : {
				required : "Especificar el número de Cuenta de Ahorro."
			},
			planID : {
				required : "Especificar el número de Plan de Ahorro."
			},
			serie : {
				required : "Especificar el número de folios para el cliente."
			},
			montoDep : {
				required : "Especificar el monto del deposito."
			}
		}
	});


	function validaClienteID(){
		var tipoCon = 1;
		clienteServicio.consulta(tipoCon,$("#clienteID").val(),function(clienteBean){
			if (clienteBean!=null) {
				$("#nombreCliente").val(clienteBean.nombreCompleto);
			}
		});
	}

	function validaCuentaID(){
		var tipoCon = 4;
		var paramCon = {};
		paramCon['cuentaAhoID'] = $("#cuentaID").val();
		paramCon['clienteID'] = $("#clienteID").val();

		cuentasAhoServicio.consultaCuentasAho(tipoCon,paramCon,{
			async : false,
			callback : function(cuentaAhoBean){
				if (cuentaAhoBean!=null){
					$("#descCuenta").val(cuentaAhoBean.descripcionTipoCta); 
					$("#montoDep").val(cuentaAhoBean.saldoDispon);
					tipoCuentaAhoID = cuentaAhoBean.tipoCuentaID;
					saldoDisponCliente = $("#montoDep").asNumber();
				}
			}
		});
	}

	function validaPlanID(){
		var tipoCon = 1;
		var clienID = $("#clienteID").val();
		var cuenID = $("#cuentaID").val();
		var planCon = $("#planID").val();

		if (clienID!='' && cuenID!='' && planCon!=0) {
			var parametrosCon = {};
			parametrosCon['clienteID'] = clienID;
			parametrosCon['cuentaID'] = cuenID;
			parametrosCon['planID'] = planCon;

			tiposPlanAhorroServicio.consulta(tipoCon,parametrosCon,{
				async: false,
				callback: function(planAhoBean){
					if (planAhoBean!=null) {
						var arrayTiposCuentas = planAhoBean.tiposCuentas.split(',');
						if(arrayTiposCuentas.indexOf(tipoCuentaAhoID)>=0){
							$("#monto").val(planAhoBean.depositoBase);
							$("#fechaMeta").val(planAhoBean.fechaLiberacion);
							maxFoliosPlanAho = Number(planAhoBean.maxDep);
							consultaFoliosCliente();
						}else{
							mensajeSis("La Tipo de Cuenta de Ahorro no está permitida para el Plan de Ahorro seleccionado.");
							setTimeout('$("#planID").focus();',0);
						}
					}
				}
			});
		}else{
			if (clienID=='') {
				mensajeSis("Especifique Número de Cliente.");
				setTimeout('$("#clienteID").focus();',0);
				$("#planID").val(0);
			}else if(cuenID==''){
				mensajeSis("Especifique Número de Cuenta.");
				setTimeout('$("#cuentaID").focus();',0);
				$("#planID").val(0);
			}else if (planCon==0) {
				mensajeSis("Seleccione un Plan de Ahorro.");
				setTimeout('$("#planID").focus();',0);
			}
		}
	}

	function consultaPlanesAhorro() {			
		dwr.util.removeAllOptions('planID'); 
		dwr.util.addOptions('planID', {"":'SELECCIONAR'});
		tiposPlanAhorroServicio.listaCombo(2,{},function(planesAhorro){
			dwr.util.addOptions('planID', planesAhorro, 'planID', 'nombre');
		});
	}

	function consultaFoliosCliente(){
		var tipoCon = 1;
		var parametrosCon = {};
		parametrosCon['clienteID'] = $("#clienteID").val();
		parametrosCon['cuentaID'] = $("#cuentaID").val();
		parametrosCon['planID'] = $("#planID").val();
		foliosPlanAhorroServicio.consulta(tipoCon,parametrosCon,{
			async: true,
			callback : function(foliosPlanAhorroBean){
				if (foliosPlanAhorroBean != null) {
					$("#saldoActual").val(foliosPlanAhorroBean.saldoActual);
				}else{
					$("#saldoActual").val('0.00');
				}
				$("#serie").val('0');
				calculaFolios($("#serie").asNumber(),saldoDisponCliente);
			}
		});
	}

	function calculaFolios(foliosPorCli,montoDepClien){
		var montoBase = $("#monto").asNumber();
		var saldoActual = $("#saldoActual").asNumber();
		var folios = 0;
		var montoDeposito = 0.00;

		folios = (saldoActual / montoBase);
		if (folios == maxFoliosPlanAho) {
			folios = -1;
			montoDeposito = 0.00;
		}else if(folios != 0){
			folios = maxFoliosPlanAho - folios;
			if(foliosPorCli<folios  && foliosPorCli>0){
				folios = foliosPorCli;
			}
		}else if (folios == 0) {
			if (foliosPorCli<maxFoliosPlanAho && foliosPorCli>0) {
				folios = foliosPorCli;
			}else{
				folios = maxFoliosPlanAho;
			}
		}

		montoDeposito = folios * montoBase;
		if (montoDepClien == 0 ) {
			folios = 0;
			montoDeposito = -1;
		}else if(montoDepClien<montoDeposito){
			folios = Math.trunc(montoDepClien/montoBase);
			montoDeposito = folios*montoBase;
		}

		if (folios > 0){
			habilitaBoton('agregar','submit');
		}else if (folios<0) {
			mensajeSis("El Cliente ha adquirido el máximo de folios permitidos por Plan de Ahorro.");
			folios = 0;
			deshabilitaBoton('agregar','submit');
			setTimeout('$("#clienteID").focus();',0);
		}else if(montoDeposito<0){
			mensajeSis("El Cliente no cuenta con Saldo suficiente para adquirir un Plan de Ahorro.");
			montoDeposito = 0;
			deshabilitaBoton('agregar','submit');
			setTimeout('$("#cuentaID").focus();',0);
		}

		$("#serie").val(folios);
		$("#montoDep").val(parseFloat(montoDeposito).toFixed(2));
	}

	function inicializaForma(){
		$("#clienteID").val('');
		$("#cuentaID").val('');
		$("#descCuenta").val('');
		$("#serie").val('');
		$("#montoDep").val('0.00');
		$("#saldoActual").val('0.00');
		deshabilitaControl("monto");
		deshabilitaControl("fechaMeta");
		deshabilitaControl("saldoActual");
		deshabilitaBoton('agregar','submit');
	}
});

function inicializaFormaCliente(){
	$("#cuentaID").val('');
	$("#descCuenta").val('');
	$("#planID").val(0);
	$("#monto").val('');
	$("#fechaMeta").val('');
	$("#serie").val('');
	$("#montoDep").val('0.00');
	$("#saldoActual").val('0.00');
	deshabilitaControl("monto");
	deshabilitaControl("fechaMeta");
	deshabilitaControl("saldoActual");
	deshabilitaBoton('agregar','submit');
};

function consultaExitosa(){
	imprimeTicket();
	inicializaFormaCliente();
}

function consultaFallida(){
	
}

function imprimeTicket(){
	var clienteID = $("#clienteID").val();
	var numTrans = $("#numeroTransaccion").val();
	var planID = $("#planID").val();
	var cuentaAhoID = $("#cuentaID").val();

	var url = "repTicketPlanAhorro.htm?clienteID="+clienteID+"&numTrans="+numTrans+
			"&planID="+planID+"&cuentaID="+cuentaAhoID;
	window.open(url,"_blank");
}