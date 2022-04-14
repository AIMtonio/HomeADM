var parametroBean = consultaParametrosSession();
var fechaSistemaTicket= parametroBean.fechaAplicacion;
var cobraGarantiaFinanciada = "N";
var tipoCalInteres = 0;
var catFormTipoCalInt = {
		'principal'	: 1,
};
var TasaFijaID 			= 1; // ID de la formula para tasa fija (FORMTIPOCALINT)
var TasaBasePisoTecho 	= 3; // ID de la formula para tasa base con piso y techo (FORMTIPOCALINT)
var VarTasaFijaoBase 	= 'Tasa Fija'; // Texto que indica si se trata de tasa fija o tasa base actual (alert)
var cobraAccesorios = 'N';
var varSucurCli = 0;
var cuotasMaxProyectar = 0;	// Cuotas Maximas a Proyectar

var Enum_Constantes = {
	'SI' : 'S',
	'NO' : 'N'
};

listaPersBloqBean = {
		'estaBloqueado'	:'N',
		'coincidencia'	:0
};

var consultaSPL = {
		'opeInusualID' : 0,
		'numRegistro' : 0,
		'permiteOperacion' : 'S',
		'fechaDeteccion' : '1900-01-01'
};

var esCliente 			='CTE';


$(document).ready(function(){
	$("#creditoID").focus();
	//Definición de constantes y Enums
	esTab = true;

	var catTipoConsultaCredito = {
  		'principal'	: 1,
  		'foranea'	: 2,
  		'pago'		: 7
	};

	var catTipoTranCredito = {
  		'pagoCredito'		: 12 ,
  		'pagoCreditoGrupal': 18 ,
  		'prepagoCredito': 21 ,
  		'prepagoCreditoGrupal' :22,// cambiar esto
	};
	//-----------------------Métodos y manejo de eventos-----------------------

	var procedePago = 2;
	var montoPagarMayor = 1;

	deshabilitaBoton('amortiza', 'submit');
	deshabilitaBoton('movimientos', 'submit');
	deshabilitaBoton('pagar', 'submit');
	deshabilitaControl('tipoPrepago');

	// llena el combo para la Formula de Calculo de Interés
	consultaComboCalInteres();
	muestraCamposTasa(0);
	consultaCobraGarantiaFinanciada();
	$('#impTicket').hide();
	ocultaCamposAlCargar(); // ocultamos algunos campos  al cargar la pantalla

	$(':text').focus(function() {
	 	esTab = false;
	});

	agregaFormatoControles('formaGenerica');

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

   	$.validator.setDefaults({
   		submitHandler: function(event) {
   			var prorrateoPagoSI = 'S';
   			var prorrateoPagoNO = 'N';
   			var pagoExigible = $('#pagoExigible').asNumber();
   			var estatus = $('#estatus').val();
   			var adeudo = 0;
   	    	var montoPag = 0;
   	    	var prorrateaGpo = $('#prorrateoPago').val();

   	    	if(montoPagarMayor == 1){
   	        	montoPag = $('#montoPagar').asNumber();
   	        	if($('#tipoPrepago').val() != 'P'){
	   	    		if($('#grupoID').val() > 0 && prorrateaGpo == prorrateoPagoSI){
	   	    			adeudo = $('#montoTotDeudaPC').asNumber();
	   	    		}else{
	   	    			adeudo = $('#adeudoTotal').asNumber();
	   	    		}
	   	    	}else{
                    if($('#prepagoCredito').is(':checked')){
                        adeudo = $('#adeudoTotalPrepago').asNumber();
                    }else{
                        adeudo = $('#adeudoTotal').asNumber();
                    }
	   	    	}
   	        	if(montoPag > adeudo && cobraGarantiaFinanciada == 'N' ){
   	        		var mensajeRetorno = 'El Monto a Pagar es Mayor al Adeudo.';
   	        		if($('#totalAde').is(':checked') && $('#tipoPrepago').val() == 'P'){
	   	    			mensajeRetorno = 'Para Finiquitar un crédito con el Tipo de Prepago: <b>Pago Cuotas Completas Proyectadas</b>, la opción a seleccionar en el Tipo de Pago debe ser <b>Prepago</b>, ingresando el total de cuotas a liquidar.';
	   	    		}
   	        		mensajeSis(mensajeRetorno);
   	    			$('#montoPagar').focus();
   	        	}else{
   	   	        	if($('#exigible').is(':checked') && montoPag > 0 && pagoExigible == 0 && estatus !='PAGADO'){
   	   	        		mensajeSis("El Crédito No Presenta Adeudo.");
   	   	    			$('#montoPagar').focus();
   	   	    			$('#montoPagar').val('');

   	   	        	}else { if($('#prepagoCredito').is(':checked') && montoPag == 0 && estatus !='PAGADO'){
			   	        		mensajeSis("El Monto debe ser Mayor a Cero.");
			   	    			$('#montoPagar').focus();
			   	    			$('#montoPagar').val('');
			   	        	} else { if($('#prepagoCredito').is(':checked') && montoPag >= $('#montoTotGrupalDeudaPrepago').asNumber() && $('#tipoPrepago').val() == 'U' && estatus !='PAGADO'
			   	        					&& $('#prorrateoPago').val() == prorrateoPagoSI){
							        		mensajeSis("No Puede PrePagar el Total del Capital, Por Favor Seleccione la Opcion Total Adeudo.");
							    			$('#montoPagar').focus();
							    			$('#montoPagar').val('');

							        	} else if($('#prepagoCredito').is(':checked') && montoPag >= $('#adeudoTotalPrepago').asNumber() && $('#tipoPrepago').val() == 'U' && estatus !='PAGADO'
			   	        					&& $('#prorrateoPago').val() == prorrateoPagoNO){
							        		mensajeSis("No Puede PrePagar el Total del Capital, Por Favor Seleccione la Opcion Total Adeudo.");
							    			$('#montoPagar').focus();
							    			$('#montoPagar').val('');
							        	}
			   	        					else{
						   	    	    		if($('#exigible').is(':checked') || $('#totalAde').is(':checked')){
							   	    	    		procedePago = validaFiniquito();
							   	    	    		if(procedePago ==2){
							   	    	    			$('#montoPagar').focus();
							   	    	    		}else{
							   	    	    			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','numeroTransaccion','funcionExitoPago','funcionFalloPago');
							   	    	    		}
						   	    	    		}else{
						   	    	    			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','numeroTransaccion','funcionExitoPago','funcionFalloPago');
						   	    	    		}
						   	    	    }
						   	  }
   	   	        		}
   	        	  }
   	    	}
   		}
    });

	$('#montoPagar').blur(function(){
		var prorrateoPagoNO = 'N';
		var prorrateoPagoSI = 'S';
		if($('#montoPagar').asNumber() > $('#saldoCta').asNumber()){
			mensajeSis("El Saldo de la Cuenta es Insuficiente.");
			$('#montoPagar').focus();
			montoPagarMayor = 2;
		}else{
			montoPagarMayor = 1;
		}
		if(($('#prepagoCredito').is(':checked')) && ($('#montoPagar').asNumber() >= $('#adeudoTotalPrepago').asNumber())
				&& $('#estatus').val()!= 'PAGADO' && $('#prorrateoPago').val() == prorrateoPagoNO && $('#tipoPrepago').val() != 'P'){
			mensajeSis("Para Liquidar el Crédito, Por Favor Seleccione la Opción Total Adeudo.");

			$('#totalAde').attr('checked',true);
			$('#prepagoCredito').attr('checked',false);
			$('#montoPagar').focus();

			if($('#grupoID').val() > 0){
				$('#labelPagoExiGrupoPC').hide();
				$('#montoTotExigiblePC').hide();
				$('#labelTotalAdeGrupalPC').show();
				$('#montoTotDeudaPC').show();

				$('#exigibleAlDiaG').hide();
				$('#montoProyectadoG').hide();
				$('#lblExigibleAlDiaG').hide();
				$('#lblMontoProyectadoG').hide();

				$('#lblexigibleAlDia').hide();
				$('#exigibleAlDia').hide();
				$('#exigibleAlDia').hide();
				$('#montoProyectado').hide();
			}else{

			}
			$('#labelTotalAdeudoPC').show();
			$('#adeudoTotal').show();

			$('#labelPagoExiGrupoPC').hide();
			$('#montoTotExigiblePC').hide();
			$('#labelPagoExigiblePC').hide();
			$('#pagoExigible').hide();

			$('#exigibleAlDiaG').hide();
			$('#montoProyectadoG').hide();
			$('#lblExigibleAlDiaG').hide();
			$('#lblMontoProyectadoG').hide();

			$('#lblexigibleAlDia').hide();
			$('#exigibleAlDia').hide();
			$('#montoProyectado').hide();
			$('#lblmontoProyectado').hide();

			$('#labelTotalAdeudoPrepago').hide();
			$('#adeudoTotalPrepago').hide();
			$('#lblmontoTotGrupalDeudaPrepago').hide();
			$('#montoTotGrupalDeudaPrepago').hide();

			$('#labelCuotaProyec').hide();
			$('#cuotasProyectadas').hide();

			$('#divTipoPrepago').hide();
			$('#divTipoPrepago1').hide();
			ocultaPagoCuotas();
			consultaGrupoDeudaTotalFiniquito();
			consultaFiniquitoLiqAnticipada();
		}
		if(($('#prepagoCredito').is(':checked')) && ($('#montoPagar').asNumber() >= $('#montoTotGrupalDeudaPrepago').asNumber())
				&& $('#estatus').val()!= 'PAGADO' && $('#prorrateoPago').val() == prorrateoPagoSI && $('#tipoPrepago').val() != 'P'){
			mensajeSis("Para Liquidar el Crédito, Por Favor Seleccione la Opción Total Adeudo.");

			$('#totalAde').attr('checked',true);
			$('#prepagoCredito').attr('checked',false);
			$('#montoPagar').focus();

			if($('#grupoID').val() > 0){
				$('#labelPagoExiGrupoPC').hide();
				$('#montoTotExigiblePC').hide();
				$('#labelTotalAdeGrupalPC').show();
				$('#montoTotDeudaPC').show();

				$('#exigibleAlDiaG').hide();
				$('#montoProyectadoG').hide();
				$('#lblExigibleAlDiaG').hide();
				$('#lblMontoProyectadoG').hide();

				$('#lblexigibleAlDia').hide();
				$('#exigibleAlDia').hide();
				$('#exigibleAlDia').hide();
				$('#montoProyectado').hide();
			}else{

			}
			$('#labelTotalAdeudoPC').show();
			$('#adeudoTotal').show();

			$('#labelPagoExiGrupoPC').hide();
			$('#montoTotExigiblePC').hide();
			$('#labelPagoExigiblePC').hide();
			$('#pagoExigible').hide();

			$('#exigibleAlDiaG').hide();
			$('#montoProyectadoG').hide();
			$('#lblExigibleAlDiaG').hide();
			$('#lblMontoProyectadoG').hide();

			$('#lblexigibleAlDia').hide();
			$('#exigibleAlDia').hide();
			$('#montoProyectado').hide();
			$('#lblmontoProyectado').hide();

			$('#labelTotalAdeudoPrepago').hide();
			$('#adeudoTotalPrepago').hide();
			$('#lblmontoTotGrupalDeudaPrepago').hide();
			$('#montoTotGrupalDeudaPrepago').hide();

			$('#labelCuotaProyec').hide();
			$('#cuotasProyectadas').hide();

			$('#divTipoPrepago').hide();
			$('#divTipoPrepago1').hide();
			ocultaPagoCuotas();
			consultaGrupoDeudaTotalFiniquito();
			consultaFiniquitoLiqAnticipada();
		}
		});


	$('#amortiza').click(function(){
		consultaGridAmortizaciones();
	});

	$('#movimientos').click(function(){
		consultaGridMovimientos();
	});

	$('#creditoID').blur(function(){
		if(isNaN($('#creditoID').val()) ){
			$('#creditoID').val("");
			$('#creditoID').focus();
		}
		else{
		 consultaCredito(this.id);
	 }
	});

	$('#creditoID').bind('keyup', function(e){
		lista('creditoID', '2', '9', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});

	$('#cuentaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#clienteID').val();
		listaAlfanumerica('cuentaID', '0', '2', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
	});

	$('#cuentaID').blur(function(){
		consultaCta(this.id);
	});

	$('#fechaSistema').val(parametroBean.fechaAplicacion);

	$('#totalAde').click(function(){
		if($('#exigible').is(':checked')){
			$('#exigible').attr('checked',false);
		}
		$('#totalAde').attr('checked',true);
		$('#prepagoCredito').attr('checked',false);
		$('#finiquito').val('S');

		if($('#grupoID').val() > 0){
			$('#labelPagoExiGrupoPC').hide();
			$('#montoTotExigiblePC').hide();
			$('#labelTotalAdeGrupalPC').show();
			$('#montoTotDeudaPC').show();

			$('#exigibleAlDiaG').hide();
			$('#montoProyectadoG').hide();
			$('#lblExigibleAlDiaG').hide();
			$('#lblMontoProyectadoG').hide();

			$('#lblexigibleAlDia').hide();
			$('#exigibleAlDia').hide();
			$('#exigibleAlDia').hide();
			$('#montoProyectado').hide();
		}else{
		}
		$('#labelTotalAdeudoPC').show();
		$('#adeudoTotal').show();

		$('#labelPagoExiGrupoPC').hide();
		$('#montoTotExigiblePC').hide();
		$('#labelPagoExigiblePC').hide();
		$('#pagoExigible').hide();

		$('#exigibleAlDiaG').hide();
		$('#montoProyectadoG').hide();
		$('#lblExigibleAlDiaG').hide();
		$('#lblMontoProyectadoG').hide();

		$('#lblexigibleAlDia').hide();
		$('#exigibleAlDia').hide();
		$('#montoProyectado').hide();
		$('#lblmontoProyectado').hide();

		$('#labelTotalAdeudoPrepago').hide();
		$('#adeudoTotalPrepago').hide();
		$('#lblmontoTotGrupalDeudaPrepago').hide();
		$('#montoTotGrupalDeudaPrepago').hide();

		$('#labelCuotaProyec').hide();
		$('#cuotasProyectadas').hide();

		$('#divTipoPrepago').hide();
		$('#divTipoPrepago1').hide();
		ocultaPagoCuotas();
		consultaGrupoDeudaTotalFiniquito();
		consultaFiniquitoLiqAnticipada();
	});

	$('#exigible').click(function(){
		if($('#totalAde').is(':checked')){
			$('#totalAde').attr('checked',false);
		}
		$('#prepagoCredito').attr('checked',false);
		consultaExigible();
		$('#labelPagoExigiblePC').show();
		$('#pagoExigible').show();

		$('#labelTotalAdeGrupalPC').hide();
		$('#montoTotDeudaPC').hide();
		$('#labelTotalAdeudoPC').hide();
		$('#adeudoTotal').hide();

		$('#lblexigibleAlDia').show();
		$('#exigibleAlDia').show();
		$('#montoProyectado').show();
		$('#lblmontoProyectado').show();

		//----- prepago
		$('#labelTotalAdeudoPrepago').hide();
		$('#adeudoTotalPrepago').hide();
		$('#lblmontoTotGrupalDeudaPrepago').hide();
		$('#montoTotGrupalDeudaPrepago').hide();

		$('#labelCuotaProyec').hide();
		$('#cuotasProyectadas').hide();

		$('#divTipoPrepago').hide();
		$('#divTipoPrepago1').hide();

		if($('#totalAde').is(':checked')){
			$('#totalAde').attr('checked',false);
			$('#prepagoCredito').attr('checked',false);
			$('#finiquito').val('N');
			consultaExigible();
		}

		if($('#grupoID').val() > 0){
			consultaGrupoTotalExigible();
			$('#labelPagoExiGrupoPC').show();
			$('#montoTotExigiblePC').show();
			$('#exigibleAlDiaG').show();
			$('#montoProyectadoG').show();
			$('#lblExigibleAlDiaG').show();
			$('#lblMontoProyectadoG').show();

		}else{
			$('#labelPagoExiGrupoPC').hide();
			$('#montoTotExigiblePC').hide();
			$('#exigibleAlDiaG').hide();
			$('#montoProyectadoG').hide();
			$('#lblExigibleAlDiaG').hide();
			$('#lblMontoProyectadoG').hide();
		}

		if($('#pagoExigible').asNumber()==0 && $('#estatus').val()!= 'PAGADO'){
			mensajeSis("El Crédito No Presenta Adeudo.");
			$('#montoPagar').focus();
			$('#montoPagar').val('');
		}
	});

	$('#prepagoCredito').click(function(){
		$('#exigible').attr('checked',false);
		$('#totalAde').attr('checked',false);

		$('#labelPagoExigiblePC').hide();
		$('#pagoExigible').hide();

		$('#labelTotalAdeGrupalPC').hide();
		$('#montoTotDeudaPC').hide();
		$('#labelTotalAdeudoPC').hide();
		$('#adeudoTotal').hide();

		$('#lblexigibleAlDia').hide();
		$('#exigibleAlDia').hide();
		$('#montoProyectado').hide();
		$('#lblmontoProyectado').hide();

		$('#labelPagoExiGrupoPC').hide();
		$('#montoTotExigiblePC').hide();
		$('#exigibleAlDiaG').hide();
		$('#montoProyectadoG').hide();
		$('#lblExigibleAlDiaG').hide();
		$('#lblMontoProyectadoG').hide();

		$('#labelTotalAdeudoPrepago').show();
		$('#adeudoTotalPrepago').show();

		$('#divTipoPrepago').show();
		$('#divTipoPrepago1').show();
		ocultaPagoCuotas();
		consultaGrupoDeudaTotalPrepago();

		if ($('#estatus').val() != 'PAGADO') {
			var tipoPrep = $('#tipoPrepago').val();
			if(tipoPrep != 'P'){
			consultaCreditoPrepago();
			}else{
				$('#labelCuotaProyec').show();
				$('#cuotasProyectadas').show();
				consultaCuotas();
				$('#cuotasProyectadas').focus();
			}
			consultaPagoExigible();
		}else{
			mensajeSis("No se puede realizar un Prepago, Crédito Pagado.");
			$('#creditoID').focus();
		}


		if($('#grupoID').val() > 0){
			if($('#prorrateoPago').val() == 'S'){
				$('#tipoTransaccion').val(catTipoTranCredito.prepagoCreditoGrupal);

			}else{
				$('#tipoTransaccion').val(catTipoTranCredito.prepagoCredito);
			}
			$('#lblmontoTotGrupalDeudaPrepago').show();
			$('#montoTotGrupalDeudaPrepago').show();
		}else{
			$('#tipoTransaccion').val(catTipoTranCredito.prepagoCredito);

		}
	});
	$('#cuotasProyectadas').blur(function(){
		var numCuotas = $('#cuotasProyectadas').asNumber();
		if(numCuotas == 0){
			$('#cuotasProyectadas').val(1);
			numCuotas = 1;
		}
		if(numCuotas > 0 && numCuotas <= cuotasMaxProyectar && !isNaN(numCuotas)){
			consultaProyeccionCredPrepago();
		}else{
			mensajeSis('El Maximo de Cuotas a Proyectar es ' + cuotasMaxProyectar);
			$('#cuotasProyectadas').val('');
			$('#cuotasProyectadas').focus();
		}
	});



	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			creditoID: {
				required: true
			}
		},
		messages: {
			creditoID: {
				required: 'Especificar Número de  Crédito'
			}
		}
	});

	//-------------Validaciones de controles---------------------
	function consultaCredito(controlID){  // cccc
		$('#divTipoPrepago').hide();
		$('#divTipoPrepago1').hide();
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito)){
			$('#exigible').removeAttr('disabled');
			var creditoBeanCon = {
					'creditoID':$('#creditoID').val(),
					'fechaActual':$('#fechaSistema').val()
			};
			$('#gridAmortizacion').hide();
  			$('#gridMovimientos').hide();
  			$('#impTicket').hide();
  			$('#totalAde').attr('checked',false);
  			$('#prepagoCredito').attr('checked',false);
  			$('#exigible').attr('checked',true);
   			creditosServicio.consulta(18,creditoBeanCon,{ async: false, callback: function(credito) {//catTipoConsultaCredito.saldos
				if(credito!=null){
					listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
					consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);
				
					if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
						if(credito.esAgropecuario == Enum_Constantes.NO){
							esTab=true;
							dwr.util.setValues(credito);
							consultaCreditoPrincipal();
							$('#tipoPrepago').val(credito.tipoPrepago);
							if(credito.fechaProxPago == '1900-01-01'){
		   						$('#fechaProxPago').val("");
		   					}
							consultaCliente('clienteID');
							consultaMoneda('monedaID');
							consultaLineaCredito('lineaCreditoID');
							consultaCta('cuentaID');
							consultaProducCredito('producCreditoID');
							var estatus = credito.estatus;
							validaEstatusCredito(estatus);
							habilitaBoton('amortiza', 'submit');
							habilitaBoton('movimientos', 'submit');
							muestraCamposTasa(credito.calcInteresID);
							$('#grupoID').val(credito.grupoID);
							if(credito.grupoID > 0){
								$('#cicloID').val(credito.cicloGrupo);
								consultaGrupo(credito.grupoID,'grupoID','grupoDes','cicloID');
								consultaGrupoTotalExigible();
								consultaGrupoDeudaTotalFiniquito(); // consultamos para realizar la validacion.
								consultaGrupoDeudaTotalPrepago();
								// Pago cuota grupo
								$('#labelPagoExiGrupoPC').show();
								$('#montoTotExigiblePC').show();
			   					$('#exigibleAlDiaG').show();
			   					$('#montoProyectadoG').show();
			   					$('#lblExigibleAlDiaG').show();
			   					$('#lblMontoProyectadoG').show();
			   					consultaExigible();
			   					$('#tdGrupoCicloCredlabel').show();
			   					$('#tdGrupoCicloCredinput').show();
			   					$('#tdGrupoGrupoCredinput').show();
			   					$('#tdGrupoGrupoCredlabel').show();
	
			   					$('#tdlblProrrateoPago').show();
			   					$('#tdProrrateoPago').show();
	
							}else{
								consultaExigible();
			   					$('#tdGrupoGrupoCredinput').hide();
			   					$('#tdGrupoGrupoCredlabel').hide();
			   					$('#tdGrupoCicloCredlabel').hide();
			   					$('#tdGrupoCicloCredinput').hide();
			   					$('#grupoID').val("");
								$('#cicloID').val("");
								$('#grupoDes').val("");
								$('#labelPagoExiGrupoPC').hide();
								$('#montoTotExigiblePC').hide();
								// Pago cuota grupo
								$('#labelPagoExiGrupoPC').hide();
								$('#montoTotExigiblePC').hide();
								$('#exigibleAlDiaG').hide();
			   					$('#montoProyectadoG').hide();
			   					$('#lblExigibleAlDiaG').hide();
			   					$('#lblMontoProyectadoG').hide();
	
			   					$('#tdlblProrrateoPago').hide();
			   					$('#tdProrrateoPago').hide();
	
			   					$('#lblUltCuotaPagada').hide();
								$('#ultCuotaPagada').hide();
								$('#lblFechaUltCuotaPagada').hide();
								$('#fechaUltCuotaPagada').hide();
								$('#lblCuotasAtraso').hide();
								$('#cuotasAtraso').hide();
								$('#lblMontoNoCartVencida').hide();
								$('#montoNoCartVencida').hide();
	
	
							}
							consultaFiniquitoLiqAnticipadaSoloAdeudo();  // consultamos para realizar la validacion.
							//Adeudo total
							$('#labelTotalAdeGrupalPC').hide();
							$('#montoTotDeudaPC').hide();
							$('#labelTotalAdeudoPC').hide();
							$('#adeudoTotal').hide();
	
							// Pago cuota
							$('#labelPagoExigiblePC').show();
							$('#pagoExigible').show();
							$('#lblexigibleAlDia').show();
							$('#exigibleAlDia').show();
							$('#montoProyectado').show();
							$('#lblmontoProyectado').show();
	
							//----prepago
		   					$('#labelTotalAdeudoPrepago').hide();
		   					$('#adeudoTotalPrepago').hide();
		   					$('#lblmontoTotGrupalDeudaPrepago').hide();
		   					$('#montoTotGrupalDeudaPrepago').hide();
		   					$('#labelCuotaProyec').hide();
							$('#cuotasProyectadas').hide();
						} else {
							inicializaForma('formaGenerica','creditoID');
							mensajeSis('El Crédito es Agropecuario.<br>Favor de Consultarlo en el Módulo <i><u>Cartera Agro</u></i>.');
							deshabilitaBoton('pagar','submit');
							$('#creditoID').focus();
							$('#creditoID').select();
						}
				}else{
					inicializaForma('formaGenerica','creditoID');
					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
					deshabilitaBoton('pagar','submit');
					$('#creditoID').focus();
					$('#creditoID').select();
				}
				}else{
					inicializaForma('formaGenerica','creditoID');
					mensajeSis("No Existe el Credito");
					deshabilitaBoton('pagar','submit');
					$('#creditoID').focus();
					$('#creditoID').select();
				}
			}});
		}
	}

	



	function consultaFiniquitoLiqAnticipada(){
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) ){
			var Con_PagoCred = 17;
			var creditoBeanCon = {
					'creditoID':$('#creditoID').val(),
					'fechaActual':$('#fechaSistema').val()
					};
			$('#gridAmortizacion').hide();
			$('#gridMovimientos').hide();
			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,{ async: false, callback:function(credito) {//catTipoConsultaCredito.saldos
				if(credito!=null){
					$('#permiteFiniquito').val(credito.permiteFiniquito);
					if(credito.permiteFiniquito == "S"){
						$('#saldoCapVigent').val(credito.saldoCapVigent);
						$('#saldoCapAtrasad').val(credito.saldoCapAtrasad);
						$('#saldoCapVencido').val(credito.saldoCapVencido);
						$('#saldCapVenNoExi').val(credito.saldCapVenNoExi);
						$('#totalCapital').val(credito.totalCapital);
						$('#saldoInterOrdin').val(credito.saldoInterOrdin);
						$('#saldoInterAtras').val(credito.saldoInterAtras);
						$('#saldoInterAtras').val(credito.saldoInterAtras);
						$('#saldoInterVenc').val(credito.saldoInterVenc);
						$('#saldoInterProvi').val(credito.saldoInterProvi);
						$('#saldoIntNoConta').val(credito.saldoIntNoConta);
						$('#totalInteres').val(credito.totalInteres);
						$('#saldoIVAInteres').val(credito.saldoIVAInteres);
						$('#saldoMoratorios').val(credito.saldoMoratorios);
						$('#saldoIVAMorator').val(credito.saldoIVAMorator);
						$('#saldoComFaltPago').val(credito.saldoComFaltPago);
						$('#saldoOtrasComis').val(credito.saldoOtrasComis);
						$('#totalComisi').val(credito.totalComisi);
						$('#salIVAComFalPag').val(credito.salIVAComFalPag);
						$('#saldoIVAComisi').val(credito.saldoIVAComisi);
						$('#totalIVACom').val(credito.totalIVACom);
						$('#adeudoTotal').val(credito.adeudoTotal);
						//SEGURO CUOTA
						$('#saldoSeguroCuota').val(credito.saldoSeguroCuota);
						$('#saldoIVASeguroCuota').val(credito.saldoIVASeguroCuota);
						//FIN SEGURO CUOTA
						//COMISION ANUAL
						$('#saldoComAnual').val(credito.saldoComAnual);
						$('#saldoComAnualIVA').val(credito.saldoComAnualIVA);
						//FIN COMISION ANUAL
						$('#saldoAdmonComis').val(credito.saldoAdmonComis);
						$('#saldoIVAAdmonComisi').val(credito.saldoIVAAdmonComisi);
						$('#permiteFiniquito').val(credito.permiteFiniquito);
						$('#pagoExigible').val("");
						consultaPagoExigible();
						if($('#grupoID').val() > 0){
							$('#labelTotalAdeGrupalPC').show();
							$('#montoTotDeudaPC').show();
						}
						$('#labelTotalAdeudoPC').show();
						$('#adeudoTotal').show();
					} else{
						mensajeSis("El Producto de Crédito No Permite Finiquitos o Liquidaciones Anticipadas.");
						$('#totalAde').attr('checked',false);
						$('#exigible').attr('checked',true);

						// Pago cuota
						$('#labelPagoExigiblePC').show();
						$('#pagoExigible').show();
						$('#lblexigibleAlDia').show();
						$('#exigibleAlDia').show();
						$('#montoProyectado').show();
						$('#lblmontoProyectado').show();
						//total Adeudo
						$('#labelTotalAdeGrupalPC').hide();
						$('#montoTotDeudaPC').hide();
						$('#labelTotalAdeudoPC').hide();
						$('#adeudoTotal').hide();

						if($('#grupoID').val() > 0){
							$('#labelPagoExiGrupoPC').show();
							$('#montoTotExigiblePC').show();
		   					$('#exigibleAlDiaG').show();
		   					$('#montoProyectadoG').show();
		   					$('#lblExigibleAlDiaG').show();
		   					$('#lblMontoProyectadoG').show();
						}

					}
				}else{
					mensajeSis("No Existe");
				}
			}
			});
		}
	}

	// Consulta el PagoExigible del crédito para validar que el credito
	// no presenta adeudo cuando se seleccione la opcion Pago Cuota
	function consultaPagoExigible(){
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito)){
			var Con_PagoCred = 8;
			var creditoBeanCon = {
					'creditoID':$('#creditoID').val(),
					'fechaActual':$('#fechaSistema').val()
			};
			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,{ async: false, callback:function(credito) {
				if(credito!=null){
				$('#pagoExigible').val(credito.pagoExigible);
				}
			}});
		 }
	}

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConPagoCred = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConPagoCred,numCliente,{async: false, callback:function(cliente) {
				if(cliente!=null){
					$('#clienteID').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
					$('#pagaIVA').val(cliente.pagaIVA);
					varSucurCli = cliente.sucursalOrigen;
				}else{
					mensajeSis("No Existe el Cliente.");
					$('#clienteID').focus();
					$('#clienteID').select();
				}
			}});
		}
	}

	function consultaMoneda(idControl) {
		var jqMoneda = eval("'#" + idControl + "'");
		var numMoneda = $(jqMoneda).val();
		var conMoneda=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMoneda != '' && !isNaN(numMoneda)){
			monedasServicio.consultaMoneda(conMoneda,numMoneda,{ async: false, callback:function(moneda) {
				if(moneda!=null){
					$('#monedaDes').val(moneda.descripcion);
				}else{
					mensajeSis("No Existe el Tipo de Moneda.");
					$('#monedaDes').val('');
					$(jqMoneda).focus();
				}
			}});
		}
	}


	function consultaLineaCredito(idControl) {
		var jqLinea  = eval("'#" + idControl + "'");
		var lineaCred = $(jqLinea).val();
		var lineaCreditoBeanCon = {
			'lineaCreditoID'	:lineaCred
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(lineaCred != '' && !isNaN(lineaCred) && esTab){
			lineasCreditoServicio.consulta(catTipoConsultaCredito.principal,lineaCreditoBeanCon,{
				async : false,
				callback:function(linea) {
				if(linea!=null){
					var estatus = linea.estatus;
					$('#saldoDisponible').val(linea.saldoDisponible);
					$('#dispuesto').val(linea.dispuesto);
					$('#numeroCreditos').val(linea.numeroCreditos);
					$('#comAnual').val(linea.comisionAnual);
					validaIVAComAnualLin();
					validaEstatusLineaCred(estatus);
				}
			}});
		}
	}

	function validaIVAComAnualLin(){
		var pagaIVA = $('#pagaIVA').val();

		if(varSucurCli!=0 && pagaIVA=='S'){
			sucursalesServicio.consultaSucursal(1,varSucurCli,{
				async: false,
				callback: function(sucursal) {
					if (sucursal!=null) {
						$('#IVAComAnual').val( $('#comAnual').asNumber() * sucursal.IVA );
						$('#IVAComAnual').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n',
							roundToDecimalPlace: 2
						});
					}
				}
			});
		}
	}

	function consultaProducCredito(idControl) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var numProdCre = $(jqProdCred).val();

		var conTipoCta=2;
		var ProdCredBeanCon = {
  			'producCreditoID':numProdCre
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProdCre != '' && !isNaN(numProdCre)){
			productosCreditoServicio.consulta(conTipoCta, ProdCredBeanCon,{ async: false, callback:function(prodCred) {
				if(prodCred!=null){
					$('#descripProducto').val(prodCred.descripcion);
					$('#prorrateoPago').val(prodCred.prorrateoPago);
					if(prodCred.permitePrepago != 'S'){
						$('#tdPrepagoCredito').hide();

					}else{
						$('#tdPrepagoCredito').show();
					}
				}else{
					$('#'+id).focus();
				}
			}});
		}
	}

	//Grid Amortizaciones
	function consultaGridAmortizaciones(){
		var params = {};
		params['creditoID'] = $('#creditoID').val();
		params['tipoLista'] = 2;
		params['cobraSeguroCuota'] 	= $('#cobraSeguroCuota option:selected').val();
		params['cobraAccesorios'] = cobraAccesorios;

		$('#gridMovimientos').hide();
		$.post("consultaCredAmortiGridVista.htm", params, function(data){
				if(data.length >0) {
					$('#gridAmortizacion').html(data);
					$('#gridAmortizacion').show();
					agregaFormatoControles('gridDetalle');
					agregaFormatoControles('gridDetalleMov');
					agregaFormatoControles('formaGenerica2');
					if ($('#siguiente').is(':visible') && $('#anterior').is(':visible')==false){
						$('#filaTotales').hide();
					}

					if ($('#siguiente').is(':visible')==false && $('#anterior').is(':visible')==false){
						$('#filaTotales').show();
					}

					if (tipoCalInteres == '2' && cobraAccesorios == 'S') {
						console.log("si entra");
						desgloseOtrasComisiones();
					}
				}else{
					$('#gridAmortizacion').html("");
					$('#gridAmortizacion').show();
				}
				muestraDescTasaVar('calcInteres');
		});
		agregaFormatoControles('formaGenerica');
	}

//Grid movimientos
	function consultaGridMovimientos(){
		var params = {};
		params['creditoID'] = $('#creditoID').val();
		params['tipoLista'] = 1;
		$('#gridAmortizacion').hide();
		$.post("creditoConsulMovsGridVista.htm", params, function(data){
				if(data.length >0) {
					$('#gridMovimientos').html(data);
					$('#gridMovimientos').show();
					agregaFormatoControles('gridDetalle');
					agregaFormatoControles('gridDetalleMov');
					agregaFormatoControles('formaGenerica3');
				}else{
					$('#gridMovimientos').html("");
					$('#gridMovimientos').show();
				}
		});
		agregaFormatoControles('formaGenerica');
	}

	function validaEstatusCredito(var_estatus) {
		var estatusInactivo 	="I";
		var estatusAutorizado 	="A";
		var estatusVigente		="V";
		var estatusPagado		="P";
		var estatusCancelada 	="C";
		var estatusVencido		="B";
		var estatusCastigado 	="K";
		var estatusSuspendido	="S";

		if(var_estatus == estatusInactivo){
			$('#estatus').val('INACTIVO');
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusAutorizado){
			$('#estatus').val('AUTORIZADO');
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusVigente){
			$('#estatus').val('VIGENTE');
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusPagado){
			$('#estatus').val('PAGADO');
			deshabilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusCancelada){
			$('#estatus').val('CANCELADO');
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusVencido){
			$('#estatus').val('VENCIDO');
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusCastigado){
			$('#estatus').val('CASTIGADO');
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusSuspendido){
			$('#estatus').val('SUSPENDIDO');
			habilitaBoton('pagar', 'submit');
		}
	}

	function validaEstatusLineaCred(var_estatus) {
		var estatusActivo 		="A";
		var estatusBloqueado 	="B";
		var estatusCancelada 	="C";
		var estatusInactivo 	="I";
		var estatusRegistrada	="R";

		if(var_estatus == estatusActivo){
			 $('#estatusLinCred').val('ACTIVO');
		}
		if(var_estatus == estatusBloqueado){
			 $('#estatusLinCred').val('BLOQUEADO');
		}
		if(var_estatus == estatusCancelada){
			 $('#estatusLinCred').val('CANCELADO');
		}
		if(var_estatus == estatusInactivo){
			 $('#estatusLinCred').val('INACTIVO');
		}
		if(var_estatus == estatusRegistrada){
			 $('#estatusLinCred').val('REGISTRADO');
		}
	}

	function consultaCta(idControl) {
		var jqnumCta  = eval("'#" + idControl + "'");
		var numCta = $(jqnumCta).val();
        var conCta = 3;
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteID').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if(numCta != '' && !isNaN(numCta)){
            cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,{ async: false, callback:function(cuenta) {
            	if(cuenta!=null){
            		$('#nomCuenta').val(cuenta.tipoCuentaID);
                	consultaTipoCta('nomCuenta');
					consultaSaldoCta('cuentaID');
            	}else{
            		mensajeSis("No Existe la Cuenta de Ahorro.");
            	}
            }});
        }
	}

	function consultaTipoCta(idControl) {
		var jqTipoCta = eval("'#" + idControl + "'");
		var numTipoCta = $(jqTipoCta).val();
		var conTipoCta=2;
		var TipoCuentaBeanCon = {
  			'tipoCuentaID':numTipoCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoCta != '' && !isNaN(numTipoCta)){
			tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,{ async: false, callback:function(tipoCuenta) {
				if(tipoCuenta!=null){
					$('#nomCuenta').val(tipoCuenta.descripcion);
				}else{
					$(jqTipoCta).focus();
				}
			}});
		}
	}

	function consultaSaldoCta(idControl) {
		var jqnumCta  = eval("'#" + idControl + "'");
		var numCta = $(jqnumCta).val();
        var conCta = 33;
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteID').val(),
        		'numMensaje':$('#creditoID').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if(numCta != '' && !isNaN(numCta)){
       		cuentasAhoServicio.consultaCuentasAho(conCta,CuentaAhoBeanCon,{ async: false, callback:function(cuenta) {
                	if(cuenta!=null){
						$('#saldoCta').val(cuenta.saldoDispon);
                	}else{
                		mensajeSis("No Existe la Cuenta de Ahorro.");
                	}
                }});
        }
	}

	// funcion para validar finiquito
	function validaFiniquito(){
    	var adeudo;
    	var montoPag =$('#montoPagar').asNumber();
    	if($('#grupoID').val() > 0){
     		if($('#prorrateoPago').val()  == 'S'){
				adeudo = $('#montoTotDeudaPC').asNumber();
				$('#tipoTransaccion').val(catTipoTranCredito.pagoCreditoGrupal);
     		}else{
     			adeudo = $('#adeudoTotal').asNumber();
     			$('#tipoTransaccion').val(catTipoTranCredito.pagoCredito);
     		}
		}else{
			adeudo = $('#adeudoTotal').asNumber();
			$('#tipoTransaccion').val(catTipoTranCredito.pagoCredito);
		}

    	if($('#totalAde').is(':checked') ){
			if($('#permiteFiniquito').val()== "S"){
				$('#finiquito').val('S');
				if($('#grupoID').val()>0){
					if( montoPag < adeudo ){
						agregaFormatoControles('formaGenerica');
						mensajeSis('En Liquidación Anticipada el Monto a Pagar debe ser el Monto Adeudado.');
						procedePago = 2;
					}else{
			    		if(montoPag == 0 && $('#finiquito').val() != 'S'){
				    		agregaFormatoControles('formaGenerica');
				    		mensajeSis('El Monto debe ser Mayor a Cero.');
				    		procedePago = 2;
				    	}else{
				    		procedePago = 1;
				    	}
			    		if($('#prorrateoPago').val()!="S"){
							if( montoPag > adeudo ){
								mensajeSis('En una Liquidación Anticipada el Monto a Pagar debe ser el Monto Adeudado: $'+$('#adeudoTotal').val());
								procedePago = 2;
							}
						}
					}

				}else{
					if( montoPag < adeudo ){
						agregaFormatoControles('formaGenerica');
						mensajeSis('En Liquidación Anticipada el Monto a Pagar debe ser el Monto Adeudado.');
						procedePago = 2;
					}else{
						if(montoPag == 0 && $('#finiquito').val() != 'S'){
				    		agregaFormatoControles('formaGenerica');
				    		mensajeSis('El Monto debe ser Mayor a Cero.');
				    		procedePago = 2;
				    	}else{
				    		procedePago = 1;
				    	}
					}
					$('#tipoTransaccion').val(catTipoTranCredito.pagoCredito);
				}
			}else{
	    		procedePago = 2;
	    		mensajeSis("El Producto de Crédito No Permite Finiquitos o Liquidaciones Anticipadas.");
			}
		}else{
			$('#finiquito').val('N');
			 if(montoPag > adeudo ){
				procedePago = 1;
	    	}else{
	    		if(montoPag == 0 && $('#finiquito').val() != 'S'){
		    		agregaFormatoControles('formaGenerica');
		    		mensajeSis('El Monto debe ser Mayor a Cero.');
		    		procedePago = 2;
		    	}else{
		    		procedePago = 1;
		    	}
		    }
			if($('#grupoID').val() > 0){
				if($('#prorrateoPago').val() == 'S'){
					$('#tipoTransaccion').val(catTipoTranCredito.pagoCreditoGrupal);
				}else{
					$('#tipoTransaccion').val(catTipoTranCredito.pagoCredito);
				}
			}else{
				$('#tipoTransaccion').val(catTipoTranCredito.pagoCredito);
			}
		}



		return procedePago;
	}

	// Consulta de grupos
	function consultaGrupo(valID, id, desGrupo,idCiclo) {
		var jqDesGrupo  = eval("'#" + desGrupo + "'");
		var jqIDGrupo  = eval("'#" + id + "'");
		var numGrupo = valID;
		var tipConGrupo= 1;
		var grupoBean = {
			'grupoID'	:numGrupo
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numGrupo != '' && !isNaN(numGrupo) ){
			gruposCreditoServicio.consulta(tipConGrupo, grupoBean,{ async: false, callback:function(grupo) {
				if(grupo!=null){
					$(jqIDGrupo).val(grupo.grupoID);
					$(jqDesGrupo).val(grupo.nombreGrupo);
					$('#prorrateoPago').val(grupo.prorrateaPago);
					if(grupo.prorrateaPago != 'S'){
						$('#tdPrepagoCredito').hide();
					}else{
						$('#tdPrepagoCredito').show();
					}
				}
			}});
		}
	}

	// Consulta de grupos Total Exigible
	function consultaGrupoTotalExigible() {
		var numGrupo = $('#grupoID').val();
		var tipConTotalExigible= 2;
		var grupoBean = {
			'grupoID'	:numGrupo,
			'cicloActual':$('#cicloID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numGrupo != '' && !isNaN(numGrupo)){
			gruposCreditoServicio.consulta(tipConTotalExigible, grupoBean,{ async: false, callback:function(grupoDeudaTotalExi) {
				if(grupoDeudaTotalExi!=null){
					$('#montoTotExigiblePC').val(grupoDeudaTotalExi.montoTotDeuda);
					$('#montoProyectadoG').val(grupoDeudaTotalExi.totalCuotaAdelantada);
					$('#exigibleAlDiaG').val(grupoDeudaTotalExi.totalExigibleDia);


					$('#montoTotExigiblePC').formatCurrency({
						positiveFormat: '%n',
						negativeFormat: '%n',
						roundToDecimalPlace: 2
					});

					$('#montoProyectadoG').formatCurrency({
						positiveFormat: '%n',
						negativeFormat: '%n',
						roundToDecimalPlace: 2
					});
					$('#exigibleAlDiaG').formatCurrency({
						positiveFormat: '%n',
						negativeFormat: '%n',
						roundToDecimalPlace: 2
					});
				}
			}});
		}
		agregaFormatoControles('DivExigibleGrupal');
	}

	// Consulta de grupos Deuda Total
	function consultaGrupoDeudaTotalFiniquito() {
		var numGrupo = $('#grupoID').val();
		var tipConDeudaTotal= 10;
		var grupoBean = {
			'grupoID'	:numGrupo,
			'cicloActual':$('#cicloID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numGrupo != '' && !isNaN(numGrupo) ){
			gruposCreditoServicio.consulta(tipConDeudaTotal, grupoBean,{async: false, callback: function(grupoDeudaTotal) {
					if(grupoDeudaTotal!=null){
						$('#montoTotDeudaPC').val(grupoDeudaTotal.montoTotDeuda);
						$('#montoTotDeudaPC').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2

						});

					}
				}
			});
		}
	}

	function ocultaCamposAlCargar(){
		$('#labelPagoExigiblePC').hide();
		$('#pagoExigible').hide();

		$('#labelTotalAdeGrupalPC').hide();
		$('#montoTotDeudaPC').hide();
		$('#labelTotalAdeudoPC').hide();
		$('#adeudoTotal').hide();

		$('#lblexigibleAlDia').hide();
		$('#exigibleAlDia').hide();
		$('#montoProyectado').hide();
		$('#lblmontoProyectado').hide();

		$('#labelPagoExiGrupoPC').hide();
		$('#montoTotExigiblePC').hide();
		$('#exigibleAlDiaG').hide();
		$('#montoProyectadoG').hide();
		$('#lblExigibleAlDiaG').hide();
		$('#lblMontoProyectadoG').hide();

		$('#labelTotalAdeudoPrepago').hide();
		$('#adeudoTotalPrepago').hide();

		$('#lblmontoTotGrupalDeudaPrepago').hide();
		$('#montoTotGrupalDeudaPrepago').hide();

		$('#labelCuotaProyec').hide();
		$('#cuotasProyectadas').hide();

		$('#divTipoPrepago').hide();
		$('#divTipoPrepago1').hide();
	}

	function consultaCreditoPrepago(){
		var prorrateoPagoNO = 'N';
		var prorrateoPagoSI = 'S';
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) ){
			var Con_PagoCred = 7;
			var creditoBeanCon = {
						'creditoID':$('#creditoID').val(),
						'fechaActual':$('#fechaSistema').val()
						};
			$('#gridAmortizacion').hide();
			$('#gridMovimientos').hide();

			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,{ async: false, callback:function(credito) {
				if(credito!=null){
					$('#saldoCapVigent').val(credito.saldoCapVigent);
					$('#saldoCapAtrasad').val(credito.saldoCapAtrasad);
					$('#saldoCapVencido').val(credito.saldoCapVencido);
					$('#saldCapVenNoExi').val(credito.saldCapVenNoExi);
					$('#totalCapital').val(credito.totalCapital);
					$('#saldoInterOrdin').val(credito.saldoInterOrdin);
					$('#saldoInterAtras').val(credito.saldoInterAtras);
					$('#saldoInterVenc').val(credito.saldoInterVenc);
					$('#saldoInterProvi').val(credito.saldoInterProvi);
					$('#saldoIntNoConta').val(credito.saldoIntNoConta);
					$('#totalInteres').val(credito.totalInteres);
					$('#saldoIVAInteres').val(credito.saldoIVAInteres);
					$('#saldoMoratorios').val(credito.saldoMoratorios);
					$('#saldoIVAMorator').val(credito.saldoIVAMorator);
					$('#saldoComFaltPago').val(credito.saldoComFaltPago);
					$('#saldoOtrasComis').val(credito.saldoOtrasComis);
					$('#totalComisi').val(credito.totalComisi);
					$('#salIVAComFalPag').val(credito.salIVAComFalPag);
					$('#saldoIVAComisi').val(credito.saldoIVAComisi);
					$('#totalIVACom').val(credito.totalIVACom);
					//ADMON
					$('#saldoAdmonComis').val("0.00");
					$('#saldoIVAAdmonComisi').val("0.00");
					//FIN ADMON
					//SEGURO CUOTA
					$('#seguroCuota').val("0.00");
					$('#ivaSeguroCuota').val("0.00");
					//FIN SEGURO CUOTA
					//COMISION ANUAL
					$('#saldoComAnual').val("0.00");
					$('#saldoComAnualIVA').val("0.00");
					//FIN COMISION ANUAL

					$('#adeudoTotalPrepago').val(credito.adeudoTotal);
					if($('#saldoCapAtrasad').asNumber() > 0.00 || $('#saldoCapVencido').asNumber() > 0.00 ){
						mensajeSis("Antes de Realizar un PrePago, Por Favor Realice el Pago Exigible en Atraso. ");
						$('#totalAde').attr('checked',false);
						$('#exigible').attr('checked',true);
						$('#prepagoCredito').attr('checked',false);
						consultaExigible();
						// Pago cuota
						$('#labelPagoExigiblePC').show();
						$('#pagoExigible').show();
						$('#lblexigibleAlDia').show();
						$('#exigibleAlDia').show();
						$('#montoProyectado').show();
						$('#lblmontoProyectado').show();

						//total Adeudo
						$('#labelTotalAdeGrupalPC').hide();
						$('#montoTotDeudaPC').hide();
						$('#labelTotalAdeudoPC').hide();
						$('#adeudoTotal').hide();

						//prepago
						$('#labelTotalAdeudoPrepago').hide();
						$('#adeudoTotalPrepago').hide();
						$('#lblmontoTotGrupalDeudaPrepago').hide();
						$('#montoTotGrupalDeudaPrepago').hide();
						$('#labelCuotaProyec').hide();
						$('#cuotasProyectadas').hide();

						if($('#grupoID').val() > 0){
							$('#labelPagoExiGrupoPC').show();
							$('#montoTotExigiblePC').show();
		   					$('#exigibleAlDiaG').show();
		   					$('#montoProyectadoG').show();
		   					$('#lblExigibleAlDiaG').show();
		   					$('#lblMontoProyectadoG').show();
		   					consultaGrupoTotalExigible();
						}
					}else if($('#exigibleDiaPago').asNumber() > 0.00 ){
						mensajeSis("Antes de Realizar un PrePago, Por Favor Realice el Pago Exigible al Día. ");
						$('#totalAde').attr('checked',false);
						$('#exigible').attr('checked',true);
						$('#prepagoCredito').attr('checked',false);
						consultaExigible();
						// Pago cuota
						$('#labelPagoExigiblePC').show();
						$('#pagoExigible').show();
						$('#lblexigibleAlDia').show();
						$('#exigibleAlDia').show();
						$('#montoProyectado').show();
						$('#lblmontoProyectado').show();

						//total Adeudo
						$('#labelTotalAdeGrupalPC').hide();
						$('#montoTotDeudaPC').hide();
						$('#labelTotalAdeudoPC').hide();
						$('#adeudoTotal').hide();

						//prepago
						$('#labelTotalAdeudoPrepago').hide();
						$('#adeudoTotalPrepago').hide();
						$('#lblmontoTotGrupalDeudaPrepago').hide();
						$('#montoTotGrupalDeudaPrepago').hide();
						$('#labelCuotaProyec').hide();
						$('#cuotasProyectadas').hide();

						if($('#grupoID').val() > 0){
							$('#labelPagoExiGrupoPC').show();
							$('#montoTotExigiblePC').show();
		   					$('#exigibleAlDiaG').show();
		   					$('#montoProyectadoG').show();
		   					$('#lblExigibleAlDiaG').show();
		   					$('#lblMontoProyectadoG').show();
		   					consultaGrupoTotalExigible();
						}
					}
					else if(($('#prepagoCredito').is(':checked')) && $('#estatus').val()!= 'PAGADO'
						&& ($('#montoPagar').asNumber() >= $('#adeudoTotalPrepago').asNumber())
						&& $('#prorrateoPago').val() == prorrateoPagoNO && $('#tipoPrepago').val() != 'P'){
						mensajeSis("Para Liquidar el Crédito, Por Favor Seleccione la Opción Total Adeudo.");

						$('#totalAde').attr('checked',true);
						$('#prepagoCredito').attr('checked',false);
						$('#montoPagar').focus();

						if($('#grupoID').val() > 0){
							$('#labelPagoExiGrupoPC').hide();
							$('#montoTotExigiblePC').hide();
							$('#labelTotalAdeGrupalPC').show();
							$('#montoTotDeudaPC').show();

							$('#exigibleAlDiaG').hide();
							$('#montoProyectadoG').hide();
							$('#lblExigibleAlDiaG').hide();
							$('#lblMontoProyectadoG').hide();

							$('#lblexigibleAlDia').hide();
							$('#exigibleAlDia').hide();
							$('#exigibleAlDia').hide();
							$('#montoProyectado').hide();
						}else{

						}
						$('#labelTotalAdeudoPC').show();
						$('#adeudoTotal').show();

						$('#labelPagoExiGrupoPC').hide();
						$('#montoTotExigiblePC').hide();
						$('#labelPagoExigiblePC').hide();
						$('#pagoExigible').hide();

						$('#exigibleAlDiaG').hide();
						$('#montoProyectadoG').hide();
						$('#lblExigibleAlDiaG').hide();
						$('#lblMontoProyectadoG').hide();

						$('#lblexigibleAlDia').hide();
						$('#exigibleAlDia').hide();
						$('#montoProyectado').hide();
						$('#lblmontoProyectado').hide();

						$('#labelTotalAdeudoPrepago').hide();
						$('#adeudoTotalPrepago').hide();
						$('#lblmontoTotGrupalDeudaPrepago').hide();
						$('#montoTotGrupalDeudaPrepago').hide();
						$('#labelCuotaProyec').hide();
						$('#cuotasProyectadas').hide();
						$('#divTipoPrepago').hide();
						$('#divTipoPrepago1').hide();
						ocultaPagoCuotas();
						consultaGrupoDeudaTotalFiniquito();
						consultaFiniquitoLiqAnticipada();
					}

					else if(($('#prepagoCredito').is(':checked')) && $('#estatus').val()!= 'PAGADO'
						&& ($('#montoPagar').asNumber() >= $('#montoTotGrupalDeudaPrepago').asNumber())
						&& $('#prorrateoPago').val() == prorrateoPagoSI && $('#tipoPrepago').val() != 'P'){
					mensajeSis("Para Liquidar el Crédito, Por Favor Seleccione la Opción Total Adeudo.");

					$('#totalAde').attr('checked',true);
					$('#prepagoCredito').attr('checked',false);
					$('#montoPagar').focus();

					if($('#grupoID').val() > 0){
						$('#labelPagoExiGrupoPC').hide();
						$('#montoTotExigiblePC').hide();
						$('#labelTotalAdeGrupalPC').show();
						$('#montoTotDeudaPC').show();

						$('#exigibleAlDiaG').hide();
						$('#montoProyectadoG').hide();
						$('#lblExigibleAlDiaG').hide();
						$('#lblMontoProyectadoG').hide();

						$('#lblexigibleAlDia').hide();
						$('#exigibleAlDia').hide();
						$('#exigibleAlDia').hide();
						$('#montoProyectado').hide();
					}else{

					}
					$('#labelTotalAdeudoPC').show();
					$('#adeudoTotal').show();

					$('#labelPagoExiGrupoPC').hide();
					$('#montoTotExigiblePC').hide();
					$('#labelPagoExigiblePC').hide();
					$('#pagoExigible').hide();

					$('#exigibleAlDiaG').hide();
					$('#montoProyectadoG').hide();
					$('#lblExigibleAlDiaG').hide();
					$('#lblMontoProyectadoG').hide();

					$('#lblexigibleAlDia').hide();
					$('#exigibleAlDia').hide();
					$('#montoProyectado').hide();
					$('#lblmontoProyectado').hide();

					$('#labelTotalAdeudoPrepago').hide();
					$('#adeudoTotalPrepago').hide();
					$('#lblmontoTotGrupalDeudaPrepago').hide();
					$('#montoTotGrupalDeudaPrepago').hide();
					$('#labelCuotaProyec').hide();
					$('#cuotasProyectadas').hide();
					$('#divTipoPrepago').hide();
					$('#divTipoPrepago1').hide();
					ocultaPagoCuotas();
					consultaGrupoDeudaTotalFiniquito();
					consultaFiniquitoLiqAnticipada();
				}
				}else{
					mensajeSis("No Existe");
				}
			}});
		}
	}

	function consultaGrupoDeudaTotalPrepago() {
		var numGrupo = $('#grupoID').val();
		var tipConDeudaTotal= 3;
		var grupoBean = {
			'grupoID'	:numGrupo,
			'cicloActual':$('#cicloID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numGrupo != '' && !isNaN(numGrupo) ){
			gruposCreditoServicio.consulta(tipConDeudaTotal, grupoBean,{ async: false, callback:function(grupoDeudaTotal) {
				if(grupoDeudaTotal!=null){
					$('#montoTotGrupalDeudaPrepago').val(grupoDeudaTotal.montoTotDeuda);
					$('#montoTotGrupalDeudaPrepago').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 2
					});
				}
			}});
		}
	}

	/* *******  Funcion Usada para la Validacion del monto en el Pago de la Couta            */
	function consultaFiniquitoLiqAnticipadaSoloAdeudo(){
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) ){
			var Con_PagoCred = 17;
			var creditoBeanCon = {
					'creditoID':$('#creditoID').val(),
					'fechaActual':$('#fechaSistema').val()
					};
			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,{ async: false, callback: function(credito) {//catTipoConsultaCredito.saldos
				if(credito!=null){
					$('#adeudoTotal').val(credito.adeudoTotal);
				}
			}});
		}
	}

});


function funcionExitoPago(){
	imprimeTicketPago();
	deshabilitaBoton('amortiza', 'submit');
	deshabilitaBoton('movimientos', 'submit');
	deshabilitaBoton('pagar', 'submit');
	$('#impTicket').show();
}


function funcionFalloPago(){

}

$('#impTicket').click(function(){
	reimprimirTicket();
});

function imprimeTicketPago(){
	var tituloOperacion='';
	if($('#totalAde').is(':checked')){
		tituloOperacion='FINIQUITO DE CREDITO CON CARGO A CUENTA';
	}else if($('#exigible').is(':checked')){
		tituloOperacion='PAGO EXIGIBLE DE CREDITO CON CARGO A CUENTA';
	}else if($('#prepagoCredito').is(':checked')){
		tituloOperacion='PREPAGO DE CREDITO CON CARGO A CUENTA';
	}


	var productoCredito=$('#producCreditoID').val()+"   "+$('#descripProducto').val();
		window.open('RepTicketPagoCredito.htm?fechaSistemaP='+fechaSistemaTicket+
				'&monto='+$('#montoPagar').val()+'&nombreInstitucion='+parametroBean.nombreInstitucion+'&numeroSucursal='+
				parametroBean.sucursal+'&nombreSucursal='+ parametroBean.nombreSucursal+'&varCreditoID='+$('#creditoID').val()+
				'&numCopias='+1+'&varFormaPago='+"Cargo a Cuenta"+'&numTrans='+$('#numeroTransaccion').val()+
				'&moneda='+$('#monedaDes').val()+'&productoCred='+productoCredito+'&grupo='+$('#grupoDes').val()+'&ciclo='+
				$('#cicloID').val()+'&tituloOperacion='+tituloOperacion+'&edoMunSucursal='+parametroBean.edoMunSucursal, '_blank');
}


function reimprimirTicket(){
	var tituloOperacion='';
	if($('#totalAde').is(':checked')){
		tituloOperacion='FINIQUITO DE CREDITO CON CARGO A CUENTA';
	}else if($('#exigible').is(':checked')){
		tituloOperacion='PAGO EXIGIBLE DE CREDITO CON CARGO A CUENTA';
	}else if($('#prepagoCredito').is(':checked')){
		tituloOperacion='PREPAGO DE CREDITO CON CARGO A CUENTA';
	}

	var productoCredito=$('#producCreditoID').val()+"   "+$('#descripProducto').val();
	$('#enlaceTicket').attr('href','RepTicketPagoCredito.htm?fechaSistemaP='+fechaSistemaTicket+
				'&monto='+$('#montoPagar').val()+'&nombreInstitucion='+parametroBean.nombreInstitucion+'&numeroSucursal='+
				parametroBean.sucursal+'&nombreSucursal='+ parametroBean.nombreSucursal+'&varCreditoID='+$('#creditoID').val()+
				'&numCopias='+1+'&varFormaPago='+"Cargo a Cuenta"+'&numTrans='+$('#numeroTransaccion').val()+
				'&moneda='+$('#monedaDes').val()+'&productoCred='+productoCredito+'&grupo='+$('#grupoDes').val()+'&ciclo='+
				$('#cicloID').val()+'&tituloOperacion='+tituloOperacion+'&edoMunSucursal='+parametroBean.edoMunSucursal, '_blank');
}

function ocultaPagoCuotas(){
	$('#lblUltCuotaPagada').hide();
	$('#ultCuotaPagada').hide();
	$('#lblFechaUltCuotaPagada').hide();
	$('#fechaUltCuotaPagada').hide();
	$('#lblCuotasAtraso').hide();
	$('#cuotasAtraso').hide();
	$('#lblMontoNoCartVencida').hide();
	$('#montoNoCartVencida').hide();
	$('#ultCuotaPagada').val('');
	$('#fechaUltCuotaPagada').val('');
	$('#cuotasAtraso').val('');
	$('#montoNoCartVencida').val('');
}

function muestraPagoCuotas(){
	$('#lblUltCuotaPagada').show();
	$('#ultCuotaPagada').show();
	$('#lblFechaUltCuotaPagada').show();
	$('#fechaUltCuotaPagada').show();
	$('#lblCuotasAtraso').show();
	$('#cuotasAtraso').show();
	$('#lblMontoNoCartVencida').show();
	$('#montoNoCartVencida').show();
}


function totalizaCap(){
	 var suma=0;
		$('input[name=capital]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var totalCap = eval("'capital" + numero+ "'");
			var capital=$('#'+totalCap).asNumber();
				suma = suma+capital;
			});
				return suma;
		}

function totalizaInteres(){
	 var suma=0;
		$('input[name=interes]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var totalCap = eval("'interes" + numero+ "'");
			var capital=$('#'+totalCap).asNumber();
				suma = suma+capital;
			});
				return suma;
		}
function totalizaIva(){
	 var suma=0;
		$('input[name=ivaInteres]').each(function() {
			var numero= this.id.substr(10,this.id.length);
			var totalCap = eval("'interes" + numero+ "'");
			var capital=$('#'+totalCap).asNumber();
				suma = suma+capital;
			});
				return suma;
		}

// Funcion que llena el combo de calcInteres
function consultaComboCalInteres() {
	dwr.util.removeAllOptions('calcInteres');
	formTipoCalIntServicio.listaCombo(catFormTipoCalInt.principal,function(formTipoCalIntBean){
		dwr.util.addOptions('calcInteres', {'':'SELECCIONAR'});
		dwr.util.addOptions('calcInteres', formTipoCalIntBean, 'formInteresID', 'formula');
	});
}

// Funcion que consulta la tasa base
function consultaTasaBase(idControl) {
	var jqTasa = eval("'#" + idControl + "'");
	var tasaBase = $(jqTasa).asNumber();
	var TasaBaseBeanCon = {
			'tasaBaseID' : tasaBase
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if (tasaBase > 0) {
		tasasBaseServicio.consulta(1, TasaBaseBeanCon, { async: false, callback:function(tasasBaseBean) {
			if (tasasBaseBean != null) {
				$('#desTasaBase').val(tasasBaseBean.nombre);
				$('#tasaBaseValor').val(tasasBaseBean.valor+'%');
				$('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
				$('#tasaBaseValor').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
			} else {
				$('#desTasaBase').val('');
				$('#tasaBaseValor').val('');
			}
		}});
	}
}

// Funcion que muestra los campos de la tasa variable
function muestraCamposTasa(calcInteresID){
	calcInteresID = Number(calcInteresID);
	$('#calcInteres').val(calcInteresID);
	// Si el calculo de interes es por tasaFija se ocultan campos de tasa variable
	if(calcInteresID <= TasaFijaID){
		VarTasaFijaoBase = 'Tasa Fija';
		$('tr[name=tasaBase]').hide();
		$('td[name=tasaPisoTecho]').hide();
		$('#tasaBase').val('');
		$('#desTasaBase').val('');
		$('#pisoTasa').val('');
		$('#techoTasa').val('');
	} else if(calcInteresID != TasaFijaID){
		// Si es por tasa variable, se consulta y se muestra
		VarTasaFijaoBase = 'Tasa Base Actual';
		consultaTasaBase('tasaBase');
		$('tr[name=tasaBase]').show();
		$('td[name=tasaPisoTecho]').hide();
		if(calcInteresID == TasaBasePisoTecho){
			$('td[name=tasaPisoTecho]').show();
		}
	}
	$('#lbltasaFija').text(VarTasaFijaoBase+': ');
	agregaFormatoControles('formaGenerica');
}


function consultaCreditoPrincipal() {
			var numCredito = $('#creditoID').val();
			setTimeout("$('#cajaLista').hide();", 200);

			if(numCredito != '' && !isNaN(numCredito) ){
				var creditoBeanCon = {
						'creditoID':$('#creditoID').val()
				};
				creditosServicio.consulta(1,creditoBeanCon,{ async: false, callback:function(credito) {
					if(credito!=null){
						cobraAccesorios = credito.cobraAccesorios;
						tipoCalInteres = credito.tipoCalInteres;
					}else{
							mensajeSis("No Existe el Crédito.");
							$('#creditoID').focus();
							$('#creditoID').val("");

					}
				}});
			}
		}




function consultaCobraGarantiaFinanciada(){
	var tipoConsulta = 26;
	var bean = {
			'empresaID'		: 1
		};

	paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
			if (parametro != null){
				cobraGarantiaFinanciada = parametro.valorParametro;

			}else{
				cobraGarantiaFinanciada = 'N';
			}

	}});
}
function consultaCuotas(){
	var tipoConsulta = 10; //Consulta Cuotas AMORTICREDITO

	var creditoBeanCon = {
		'creditoID': $('#creditoID').val()
	};
	amortizacionCreditoServicio.consulta(tipoConsulta,creditoBeanCon,{ async: false, callback:function(numCuotas){
		if(numCuotas != null){
			cuotasMaxProyectar = numCuotas.totalCuotas - numCuotas.cuotasPagadas;
			}
	}});
}

function consultaProyeccionCredPrepago(){
	var prorrateoPagoNO = 'N';
	var prorrateoPagoSI = 'S';
	var numCredito = $('#creditoID').val();
	setTimeout("$('#cajaLista').hide();", 200);

	if(numCredito != '' && !isNaN(numCredito) ){
		var Con_ProyeccionCuota = 1;
		var creditoBeanCon = {
			'creditoID':$('#creditoID').val(),
			'cuotasProyectadas':$('#cuotasProyectadas').val()
		};


		$('#gridAmortizacion').hide();
		$('#gridMovimientos').hide();

		creditosServicio.proyeccionCuotas(Con_ProyeccionCuota,creditoBeanCon,{ async: false, callback:function(credito) {
			if(credito!=null){
				habilitaBoton('pagar', 'submit');
				if (parseFloat(credito.adeudoTotal) <= 0 && $('#cuotasProyectadas').asNumber() > 0) {
					$('#totalAde').attr('checked',false);
					$('#exigible').attr('checked',true);
					$('#prepagoCredito').attr('checked',false);
					// Pago cuota
					$('#labelPagoExigiblePC').show();
					$('#pagoExigible').show();
					$('#lblexigibleAlDia').show();
					$('#exigibleAlDia').show();
					$('#montoProyectado').show();
					$('#lblmontoProyectado').show();

					//total Adeudo
					$('#labelTotalAdeGrupalPC').hide();
					$('#montoTotDeudaPC').hide();
					$('#labelTotalAdeudoPC').hide();
					$('#adeudoTotal').hide();

					//prepago
					$('#labelTotalAdeudoPrepago').hide();
					$('#adeudoTotalPrepago').hide();
					$('#lblmontoTotGrupalDeudaPrepago').hide();
					$('#montoTotGrupalDeudaPrepago').hide();
					$('#labelCuotaProyec').hide();

					if($('#grupoID').val() > 0){
						$('#labelPagoExiGrupoPC').show();
						$('#montoTotExigiblePC').show();
	   					$('#exigibleAlDiaG').show();
	   					$('#montoProyectadoG').show();
	   					$('#lblExigibleAlDiaG').show();
	   					$('#lblMontoProyectadoG').show();
	   					consultaGrupoTotalExigible();
					}
					deshabilitaBoton('pagar', 'submit');
					mensajeSis('El saldo exigible del número de cuotas indicado es cero, especifique otro número de cuotas.');
					$('#cuotasProyectadas').focus();
					return;
				}

				$('#saldoCapVigent').val(credito.saldoCapVigent);
				$('#saldoCapAtrasad').val(credito.saldoCapAtrasad);
				$('#saldoCapVencido').val(credito.saldoCapVencido);
				$('#saldCapVenNoExi').val(credito.saldCapVenNoExi);
				$('#totalCapital').val(credito.totalCapital);
				$('#saldoInterOrdin').val(credito.saldoInterOrdin);
				$('#saldoInterAtras').val(credito.saldoInterAtras);
				$('#saldoInterVenc').val(credito.saldoInterVenc);
				$('#saldoInterProvi').val(credito.saldoInterProvi);
				$('#saldoIntNoConta').val(credito.saldoIntNoConta);
				$('#totalInteres').val(credito.totalInteres);
				$('#saldoIVAInteres').val(credito.saldoIVAInteres);
				$('#saldoMoratorios').val(credito.saldoMoratorios);
				$('#saldoIVAMorator').val(credito.saldoIVAMorator);
				$('#saldoComFaltPago').val(credito.saldoComFaltPago);
				$('#saldoOtrasComis').val(credito.saldoOtrasComis);
				$('#totalComisi').val(credito.totalComisi);
				$('#salIVAComFalPag').val(credito.salIVAComFalPag);
				$('#saldoIVAComisi').val(credito.saldoIVAComisi);
				$('#totalIVACom').val(credito.totalIVACom);
				//ADMON
				$('#saldoAdmonComis').val("0.00");
				$('#saldoIVAAdmonComisi').val("0.00");
				//FIN ADMON
				//SEGURO CUOTA
				$('#seguroCuota').val("0.00");
				$('#ivaSeguroCuota').val("0.00");
				//FIN SEGURO CUOTA
				//COMISION ANUAL
				$('#saldoComAnual').val("0.00");
				$('#saldoComAnualIVA').val("0.00");
				//FIN COMISION ANUAL

				$('#adeudoTotalPrepago').val(credito.adeudoTotal);
				
				if($('#saldoCapAtrasad').asNumber() > 0.00 || $('#saldoCapVencido').asNumber() > 0.00 ){
					mensajeSis("Antes de Realizar un PrePago, Por Favor Realice el Pago Exigible en Atraso. ");
					$('#totalAde').attr('checked',false);
					$('#exigible').attr('checked',true);
					$('#prepagoCredito').attr('checked',false);
					consultaExigible();
					// Pago cuota
					$('#labelPagoExigiblePC').show();
					$('#pagoExigible').show();
					$('#lblexigibleAlDia').show();
					$('#exigibleAlDia').show();
					$('#montoProyectado').show();
					$('#lblmontoProyectado').show();

					//total Adeudo
					$('#labelTotalAdeGrupalPC').hide();
					$('#montoTotDeudaPC').hide();
					$('#labelTotalAdeudoPC').hide();
					$('#adeudoTotal').hide();

					//prepago
					$('#labelTotalAdeudoPrepago').hide();
					$('#adeudoTotalPrepago').hide();
					$('#lblmontoTotGrupalDeudaPrepago').hide();
					$('#montoTotGrupalDeudaPrepago').hide();
					$('#labelCuotaProyec').hide();
					$('#cuotasProyectadas').hide();

					if($('#grupoID').val() > 0){
						$('#labelPagoExiGrupoPC').show();
						$('#montoTotExigiblePC').show();
	   					$('#exigibleAlDiaG').show();
	   					$('#montoProyectadoG').show();
	   					$('#lblExigibleAlDiaG').show();
	   					$('#lblMontoProyectadoG').show();
	   					consultaGrupoTotalExigible();
					}
				}else if($('#exigibleDiaPago').asNumber() > 0.00 ){
					mensajeSis("Antes de Realizar un PrePago, Por Favor Realice el Pago Exigible al Día. ");
					$('#totalAde').attr('checked',false);
					$('#exigible').attr('checked',true);
					$('#prepagoCredito').attr('checked',false);
					consultaExigible();
					// Pago cuota
					$('#labelPagoExigiblePC').show();
					$('#pagoExigible').show();
					$('#lblexigibleAlDia').show();
					$('#exigibleAlDia').show();
					$('#montoProyectado').show();
					$('#lblmontoProyectado').show();

					//total Adeudo
					$('#labelTotalAdeGrupalPC').hide();
					$('#montoTotDeudaPC').hide();
					$('#labelTotalAdeudoPC').hide();
					$('#adeudoTotal').hide();

					//prepago
					$('#labelTotalAdeudoPrepago').hide();
					$('#adeudoTotalPrepago').hide();
					$('#lblmontoTotGrupalDeudaPrepago').hide();
					$('#montoTotGrupalDeudaPrepago').hide();
					$('#labelCuotaProyec').hide();
					$('#cuotasProyectadas').hide();

					if($('#grupoID').val() > 0){
						$('#labelPagoExiGrupoPC').show();
						$('#montoTotExigiblePC').show();
	   					$('#exigibleAlDiaG').show();
	   					$('#montoProyectadoG').show();
	   					$('#lblExigibleAlDiaG').show();
	   					$('#lblMontoProyectadoG').show();
	   					consultaGrupoTotalExigible();
					}
				}
				else if(($('#prepagoCredito').is(':checked')) && $('#estatus').val()!= 'PAGADO'
					&& ($('#montoPagar').asNumber() >= $('#adeudoTotalPrepago').asNumber())
					&& $('#prorrateoPago').val() == prorrateoPagoNO && $('#tipoPrepago').val() != 'P'){
					mensajeSis("Para Liquidar el Crédito, Por Favor Seleccione la Opción Total Adeudo.");

					$('#totalAde').attr('checked',true);
					$('#prepagoCredito').attr('checked',false);
					$('#montoPagar').focus();

					if($('#grupoID').val() > 0){
						$('#labelPagoExiGrupoPC').hide();
						$('#montoTotExigiblePC').hide();
						$('#labelTotalAdeGrupalPC').show();
						$('#montoTotDeudaPC').show();

						$('#exigibleAlDiaG').hide();
						$('#montoProyectadoG').hide();
						$('#lblExigibleAlDiaG').hide();
						$('#lblMontoProyectadoG').hide();

						$('#lblexigibleAlDia').hide();
						$('#exigibleAlDia').hide();
						$('#exigibleAlDia').hide();
						$('#montoProyectado').hide();
					}else{

					}
					$('#labelTotalAdeudoPC').show();
					$('#adeudoTotal').show();

					$('#labelPagoExiGrupoPC').hide();
					$('#montoTotExigiblePC').hide();
					$('#labelPagoExigiblePC').hide();
					$('#pagoExigible').hide();

					$('#exigibleAlDiaG').hide();
					$('#montoProyectadoG').hide();
					$('#lblExigibleAlDiaG').hide();
					$('#lblMontoProyectadoG').hide();

					$('#lblexigibleAlDia').hide();
					$('#exigibleAlDia').hide();
					$('#montoProyectado').hide();
					$('#lblmontoProyectado').hide();

					$('#labelTotalAdeudoPrepago').hide();
					$('#adeudoTotalPrepago').hide();
					$('#lblmontoTotGrupalDeudaPrepago').hide();
					$('#montoTotGrupalDeudaPrepago').hide();
					$('#labelCuotaProyec').hide();
					$('#cuotasProyectadas').hide();
					$('#divTipoPrepago').hide();
					$('#divTipoPrepago1').hide();
					ocultaPagoCuotas();
					consultaGrupoDeudaTotalFiniquito();
					consultaFiniquitoLiqAnticipada();
				}

				else if(($('#prepagoCredito').is(':checked')) && $('#estatus').val()!= 'PAGADO'
					&& ($('#montoPagar').asNumber() >= $('#montoTotGrupalDeudaPrepago').asNumber())
					&& $('#prorrateoPago').val() == prorrateoPagoSI && $('#tipoPrepago').val() != 'P'){
				mensajeSis("Para Liquidar el Crédito, Por Favor Seleccione la Opción Total Adeudo.");

				$('#totalAde').attr('checked',true);
				$('#prepagoCredito').attr('checked',false);
				$('#montoPagar').focus();

				if($('#grupoID').val() > 0){
					$('#labelPagoExiGrupoPC').hide();
					$('#montoTotExigiblePC').hide();
					$('#labelTotalAdeGrupalPC').show();
					$('#montoTotDeudaPC').show();

					$('#exigibleAlDiaG').hide();
					$('#montoProyectadoG').hide();
					$('#lblExigibleAlDiaG').hide();
					$('#lblMontoProyectadoG').hide();

					$('#lblexigibleAlDia').hide();
					$('#exigibleAlDia').hide();
					$('#exigibleAlDia').hide();
					$('#montoProyectado').hide();
				}else{

				}
				$('#labelTotalAdeudoPC').show();
				$('#adeudoTotal').show();

				$('#labelPagoExiGrupoPC').hide();
				$('#montoTotExigiblePC').hide();
				$('#labelPagoExigiblePC').hide();
				$('#pagoExigible').hide();

				$('#exigibleAlDiaG').hide();
				$('#montoProyectadoG').hide();
				$('#lblExigibleAlDiaG').hide();
				$('#lblMontoProyectadoG').hide();

				$('#lblexigibleAlDia').hide();
				$('#exigibleAlDia').hide();
				$('#montoProyectado').hide();
				$('#lblmontoProyectado').hide();

				$('#labelTotalAdeudoPrepago').hide();
				$('#adeudoTotalPrepago').hide();
				$('#lblmontoTotGrupalDeudaPrepago').hide();
				$('#montoTotGrupalDeudaPrepago').hide();
				$('#labelCuotaProyec').hide();
				$('#cuotasProyectadas').hide();
				$('#divTipoPrepago').hide();
				$('#divTipoPrepago1').hide();
				ocultaPagoCuotas();
				consultaGrupoDeudaTotalFiniquito();
				consultaFiniquitoLiqAnticipada();
			}
			}else{
				mensajeSis("No Existe");
			}
		}});
	}
}

function consultaExigible(){
	var numCredito = $('#creditoID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	$('#exigibleDiaPago').val();
	if(numCredito != '' && !isNaN(numCredito)){
		var Con_PagoCred = 8;
		var creditoBeanCon = {
				'creditoID':$('#creditoID').val(),
				'fechaActual':$('#fechaSistema').val()
		};

		$('#gridAmortizacion').hide();
		$('#gridMovimientos').hide();
		creditosServicio.consulta(Con_PagoCred,creditoBeanCon,{ async: false, callback:function(credito) {//catTipoConsultaCredito.saldos
			if(credito!=null){
				$('#saldoCapVigent').val(credito.saldoCapVigent);
				$('#saldoCapAtrasad').val(credito.saldoCapAtrasad);
				$('#saldoCapVencido').val(credito.saldoCapVencido);
				$('#saldCapVenNoExi').val(credito.saldCapVenNoExi);
				$('#totalCapital').val(credito.totalCapital);
				$('#saldoInterOrdin').val(credito.saldoInterOrdin);
				$('#saldoInterAtras').val(credito.saldoInterAtras);
				$('#saldoInterAtras').val(credito.saldoInterAtras);
				$('#saldoInterVenc').val(credito.saldoInterVenc);
				$('#saldoInterProvi').val(credito.saldoInterProvi);
				$('#saldoIntNoConta').val(credito.saldoIntNoConta);
				$('#totalInteres').val(credito.totalInteres);
				$('#saldoIVAInteres').val(credito.saldoIVAInteres);
				$('#saldoMoratorios').val(credito.saldoMoratorios);
				$('#saldoIVAMorator').val(credito.saldoIVAMorator);
				$('#saldoComFaltPago').val(credito.saldoComFaltPago);
				$('#saldoOtrasComis').val(credito.saldoOtrasComis);
				$('#totalComisi').val(credito.totalComisi);
				$('#salIVAComFalPag').val(credito.salIVAComFalPag);
				$('#saldoIVAComisi').val(credito.saldoIVAComisi);
				$('#totalIVACom').val(credito.totalIVACom);
				$('#pagoExigible').val(credito.pagoExigible);

				$('#exigibleAlDia').val(credito.totalExigibleDia);
				$('#montoProyectado').val(credito.totalCuotaAdelantada);
				$('#exigibleDiaPago').val(credito.totalExigibleDia);
				//SEGURO CUOTA
				$('#saldoSeguroCuota').val(credito.saldoSeguroCuota);
				$('#saldoIVASeguroCuota').val(credito.saldoIVASeguroCuota);
				//FIN SEGURO CUOTA
				//COMISION ANUAL
				$('#saldoComAnual').val(credito.saldoComAnual);
				$('#saldoComAnualIVA').val(credito.saldoComAnualIVA);
				//FIN COMISION ANUAL

				$('#lblCuotasAtraso').hide();
				$('#cuotasAtraso').hide();
				$('#lblMontoNoCartVencida').hide();
				$('#montoNoCartVencida').hide();
				$('#cuotasAtraso').val('');
				$('#montoNoCartVencida').val('');

				if($('#prorrateoPago').val()=='S'){
					$('#ultCuotaPagada').val(credito.ultCuotaPagada);
					$('#fechaUltCuotaPagada').val(credito.fechaUltCuota);

					$('#lblUltCuotaPagada').show();
					$('#ultCuotaPagada').show();
					$('#lblFechaUltCuotaPagada').show();
					$('#fechaUltCuotaPagada').show();

					if($('#estatus').val()=='VIGENTE'){
						$('#lblCuotasAtraso').show();
						$('#cuotasAtraso').show();
						$('#cuotasAtraso').val(credito.cuotasAtraso);
						$('#lblMontoNoCartVencida').show();
						$('#montoNoCartVencida').show();
						if(credito.cuotasAtraso==0 || credito.cuotasAtraso==1){
							$('#montoNoCartVencida').val('0.00');
						}else if(credito.cuotasAtraso>1){
							$('#montoNoCartVencida').val(credito.totalPrimerCuota);
						}
					}
				}else if($('#prorrateoPago').val()=='N'){
					$('#lblUltCuotaPagada').hide();
					$('#ultCuotaPagada').hide();
					$('#lblFechaUltCuotaPagada').hide();
					$('#fechaUltCuotaPagada').hide();
					$('#ultCuotaPagada').val('');
					$('#fechaUltCuotaPagada').val('');
				}

				$('#exigibleAlDia').formatCurrency({
					positiveFormat: '%n',
					negativeFormat: '%n',
					roundToDecimalPlace: 2
				});
				$('#montoProyectado').formatCurrency({
					positiveFormat: '%n',
					negativeFormat: '%n',
					roundToDecimalPlace: 2
				});
				$('#montoNoCartVencida').formatCurrency({
					positiveFormat: '%n',
					negativeFormat: '%n',
					roundToDecimalPlace: 2
				});
				$('#saldoAdmonComis').val("0.00");
				$('#saldoIVAAdmonComisi').val("0.00");

				$('#labelPagoExigiblePC').show();
				$('#pagoExigible').show();
				if($('#grupoID').val() > 0){
					$('#labelPagoExiGrupoPC').show();
					$('#montoTotExigiblePC').show();
				}
				$('#labelTotalAdeGrupalPC').hide();
				$('#montoTotDeudaPC').hide();
				$('#labelTotalAdeudoPC').hide();
				$('#adeudoTotal').hide();

				habilitaBoton('amortiza', 'submit');
				habilitaBoton('movimientos', 'submit');

			}
			else{
				mensajeSis("No Existe");
				deshabilitaBoton('pagar', 'submit');
			}
		}});
	}
}

function desgloseOtrasComisiones(){
	var listaDesglose = 6;
	var beanEntrada = {
			'creditoID': $("#creditoID").val(),
			'numTransacSim':0
	};
	esquemaOtrosAccesoriosServicio.lista(listaDesglose, beanEntrada, function(resultado) {
		if (resultado != null && resultado.length > 0) {
			var numRegistros = resultado.length;
			var numAmorAcc = resultado[0].numAmortizacion;
			var numAccesorios = resultado[0].contadorAccesorios;

			if (parseInt(numRegistros) > 0){
				$('#lblOtrasComisionesTemporal').remove();
				$('#lblIVAOtrasComisionesTemporal').remove();
				$('#totalOtrasComisiones').remove();
				$('#totalIVAOtrasComisiones').remove();
			}

			var contadorItera = 0;

			// Itera por accesorio
			for (var contAcc = 0; contAcc < numAccesorios; contAcc++){

				var encabezadoLista = resultado[contadorItera].encabezadoLista;
				var encabezados = encabezadoLista.split(',');
				var numEncabezados = encabezados.length;

				// Se inserta el encabezado por comision
				for (var enc = 0; enc < numEncabezados; enc++){
					var elemento = encabezados[enc];
					var encabezado = '<td class="label" align="center"><label for="lblDesglose">'+ elemento +'</label></td>';
					$(encabezado).insertBefore("#tdEncabezadoAccesorios");
				}

				// Se insertan los montos por concepto y por cuota
				for (var amorAcc = 0; amorAcc < numAmorAcc; amorAcc++){

					var renglonID = amorAcc + 1;
					

					$('#otrasComisiones' + renglonID).remove();
					$('#IVAOtrasComisiones' + renglonID).remove();

					var montoCuotaAcc = resultado[contadorItera].montoCuota;
					var colMontoCuotaAcc = '<td><input id="montoCuotaAcc' + contadorItera +'"  size="18" style="text-align: right;" type="text" value="' + montoCuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
					$(colMontoCuotaAcc).insertBefore("#tdAccesoriosDetalles" + renglonID);
					var montoIVACuotaAcc = resultado[contadorItera].montoIVACuota;
					var colMontoIVACuotaAcc = '<td><input id="montoIVACuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoIVACuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
					$(colMontoIVACuotaAcc).insertBefore("#tdAccesoriosDetalles" + renglonID);

					if (resultado[contadorItera].generaInteres == 'S'){
						var montoIntCuotaAcc = resultado[contadorItera].montoIntCuota;
						var colMontoIntCuotaAcc = '<td><input id="montoIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoIntCuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
						$(colMontoIntCuotaAcc).insertBefore("#tdAccesoriosDetalles" + renglonID);
						var montoIvaIntCuotaAcc = resultado[contadorItera].montoIVAIntCuota;
						var colMontoIvaIntCuotaAcc = '<td><input id="montoIvaIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoIvaIntCuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
						$(colMontoIvaIntCuotaAcc).insertBefore("#tdAccesoriosDetalles" + renglonID);
					}

					// Insercion de totales
					if ((amorAcc + 1) == numAmorAcc) {
						var montoTotalAcc = resultado[contadorItera].montoAccesorio;
						var colTotalMontoCuotaAcc = '<td><input id="totalMontoCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
						$(colTotalMontoCuotaAcc).insertBefore("#tdTotalVacio");
						var ivaTotalAcc = resultado[contadorItera].montoIVAAccesorio;
						var colTotalMontoIVACuotaAcc = '<td><input id="totalMontoIVACuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + ivaTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
						$(colTotalMontoIVACuotaAcc).insertBefore("#tdTotalVacio");

						if (resultado[contadorItera].generaInteres == 'S'){
							var interesTotalAcc = resultado[contadorItera].montoInteres;
							var colTotalMontoIntCuotaAcc = '<td><input id="totalMontoIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + interesTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
							$(colTotalMontoIntCuotaAcc).insertBefore("#tdTotalVacio");
							var ivaInteresTotalAcc = resultado[contadorItera].montoIVAInteres;
							var colTotalMontoIvaIntCuotaAcc = '<td><input id="totalMontoIvaIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + ivaInteresTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
							$(colTotalMontoIvaIntCuotaAcc).insertBefore("#tdTotalVacio");
						}
					}

					contadorItera += 1;
				}	
			}
		}
	});
}