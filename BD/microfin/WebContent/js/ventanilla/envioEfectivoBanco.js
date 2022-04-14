var cont = 0;
var Var_SaldoCaja=parseFloat(0);
$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();
	var mil = parseFloat(1000);
	var quinientos = parseFloat(500);
	var doscientos = parseFloat(200);
	var cien = parseFloat(100);
	var cincuenta = parseFloat(50);
	var veinte = parseFloat(20);
	var monedaValor = parseFloat(1);
	Var_SaldoCaja = parametros.saldoEfecMN;
	cont = 0;
	var catTipoLisSucursal={
		'principal' : 1	
	};
	var catTipoConsultaCta = {
			'resumen':4
	};
	var catTipoConsultaInstituciones= {
			'foranea':2
	};
	var catTipoTransEfec = {
			'alta' : 1
	};
	var catTipoListaMoneda = {
			'principal': 3
	};


	inicializaParametros();

	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$(':text').focus(function() {	
	 	esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$.validator.setDefaults({
	      submitHandler: function(event) {
	        $('#numerobanco').val($('#institucionID').val());
  			$('#nombreBanco').val($('#nombreInstitucion').val());
  			$('#cuenta').val($('#numCtaInstit').val());
	   		  if ($('#cantidad').asNumber() == 0){
	    		mensajeSis('Especificar Salidas de Efectivo.');
	    	  }else{
	    			
	    		  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','polizaID',
	    				  'funcionExitoEnvioBancos','funcionFalloEnvioBancos');
	    		  
	    		  
	    	  }
	      }
	});
	
	$('#sucursalID').val(parametros.sucursal);
	$('#descSucursal').val(parametros.nombreSucursal);
	$('#cajaID').val(parametros.cajaID);
	$('#descCaja').val(parametros.tipoCajaDes);
	$('#fecha').val(parametros.fechaSucursal);
	$('#institucionID').bind('keyup',function(e){
		var institucionID = $('#institucionID').val();
		lista('institucionID', '1', catTipoLisSucursal.principal, 'nombre', institucionID, 'listaInstituciones.htm');
	});
	
  	$('#institucionID').blur(function() {
  		if(esTab){	   		
  	  		if($('#institucionID').val() !=""){
  	   			consultaInstitucion(this.id);
  	  		}else{
  	  			$('#institucionID').val('');
  	            $('#nombreInstitucion').val("");
  	  		}
  		}   	
   	});
     	
	$('#numCtaInstit').bind('keyup',function(e){
        var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
	    parametrosLista[0] = $('#institucionID').val();
            
		listaAlfanumerica('numCtaInstit', '0', '3', camposLista,parametrosLista, 'ctaNostroLista.htm');	       
    });	
	
	$('#numCtaInstit').blur(function(){
		var numInstitucion = $('#institucionID').val();
		var numCtaInstit = $('#numCtaInstit').val();
		if(esTab){
			if(numCtaInstit !="" && !isNaN(numCtaInstit) && numInstitucion !="" && !isNaN(numInstitucion)){
	   			$('#cajaLista').hide();	  		     
	   			validaCtaInstitucion('numCtaInstit','institucionID');
	   		}else{
	   			if(numInstitucion =="" && numCtaInstit !=""){
	   				setTimeout("$('#cajaLista').hide();", 100);	
	   				mensajeSis('Especifique Primero la Institución.');
	   				$('#numCtaInstit').val('');
	   				$('#institucionID').focus();
	   			}else{
	   				if(isNaN(numCtaInstit) && !isNaN(numInstitucion)){
		   				setTimeout("$('#cajaLista').hide();", 100);	
	   					mensajeSis("La Cuenta Bancaria no Existe.");
	   					$('#numCtaInstit').val("");
	   					$('#numCtaInstit').focus();   					
	   				}
	   			}
	   		}
		}	
	});
	
	
	$('#referencia').blur(function(){
		$('#cantSalMil').focus();
	});
	
	

	$('#enviar').click(function(){
		quitaFormatoControles('formaGenerica');
		$('#tipoTransaccion').val(catTipoTransEfec.alta);
		var elementos = document.getElementsByName("cantSalida");
		for(var i=0; i < elementos.length; i++) {
			if (elementos[i].value != 0){
				cont++;
			}
		}
	});
	
	$('#impPoliza').click(function(){
		var poliza = $('#polizaID').val();	 
		var fecha = parametros.fechaSucursal;	
		window.open('RepPoliza.htm?polizaID='+poliza+'&fechaInicial='+fecha+
				'&fechaFinal='+fecha+'&nombreUsuario='+parametroBean.nombreUsuario);

	});	

	//----
	$('#cantSalMil').blur(function() {
		if($('#cantSalMil').asNumber()>0 && $('#cantSalMil').asNumber()> $('#disponSalMil').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalMil').focus();
			$('#cantSalMil').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalMil').asNumber()<=0){
				$('#cantSalMil').val("0");
			}
			cantidadPorDenominacionMilS(this.id);
		}	
		//totalEntradasSalidasDiferencia();	
	});
	$('#cantSalQui').blur(function() {
		if($('#cantSalQui').asNumber()>0 && $('#cantSalQui').asNumber()> $('#disponSalQui').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalQui').focus();
			$('#cantSalQui').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalQui').asNumber()<=0){
				$('#cantSalQui').val("0");
			}
			cantidadPorDenominacionQuiS(this.id);
		}				
		//totalEntradasSalidasDiferencia();
	});
	$('#cantSalDos').blur(function() {
		if($('#cantSalDos').asNumber()>0 && $('#cantSalDos').asNumber()> $('#disponSalDos').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalDos').focus();
			$('#cantSalDos').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalDos').asNumber()<=0){
				$('#cantSalDos').val("0");
			}
			cantidadPorDenominacionDosS(this.id);
		}
		//totalEntradasSalidasDiferencia();
	});
	$('#cantSalCien').blur(function() {
		if($('#cantSalCien').asNumber()>0 && $('#cantSalCien').asNumber()> $('#disponSalCien').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalCien').focus();
			$('#cantSalCien').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalCien').asNumber()<=0){
				$('#cantSalCien').val("0");
			}
			cantidadPorDenominacionCienS(this.id);
		}
		//totalEntradasSalidasDiferencia();
	});
	$('#cantSalCin').blur(function() {
		if($('#cantSalCin').asNumber()>0 && $('#cantSalCin').asNumber()> $('#disponSalCin').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalCin').focus();
			$('#cantSalCin').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalCin').asNumber()<=0){
				$('#cantSalCin').val("0");
			}
			cantidadPorDenominacionCinS(this.id);
		}
		//totalEntradasSalidasDiferencia();
	});
	$('#cantSalVei').blur(function() {
		if($('#cantSalVei').asNumber()>0 && $('#cantSalVei').asNumber()> $('#disponSalVei').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalVei').focus();
			$('#cantSalVei').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalVei').asNumber()<=0){
				$('#cantSalVei').val("0");
			}
			cantidadPorDenominacionVeiS(this.id);
		}
		//totalEntradasSalidasDiferencia();
	});
	
	$('#cantSalMon').blur(function() {
		if($('#cantSalMon').asNumber()>0 && $('#cantSalMon').asNumber()> $('#disponSalMon').asNumber()){
			mensajeSis("Efectivo insuficiente");
			$('#cantSalMon').focus();
			$('#cantSalMon').select();
			deshabilitaBoton('graba', 'submit');
		}else{
			if($('#cantSalMon').asNumber()<=0){
				$('#cantSalMon').val("0");
			}
			cantidadPorDenominacionMonS(this.id);
		}
		//totalEntradasSalidasDiferencia();
	});
	
	$('#formaGenerica').validate({
		rules: {
			institucionID : {
				required: true
			},
			numCtaInstit :{
				required: true	
			},
			cantidad : {
				required: true
			},
			referencia : {
				required: true
				,
				maxlength: 50
			}
		},
		
		messages: {
			institucionID : {
				required: 'Especifique No de Institución'
			},
			numCtaInstit :{
				required: 'Especifique No Cta Bancaria'	
			},
			cantidad : {
				required: 'Especifique Cantidad a Transferir'
			},
			referencia : {
				required: 'Especifique la Referencia'
					,
				maxlength: 'Maximo de 50 caracteres.'
			}
		}
	});

	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
  				'institucionID':numInstituto
		};
		if(numInstituto != '' && !isNaN(numInstituto)){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){
				if(instituto!=null){
					$('#nombreInstitucion').val(instituto.nombre);
					 $('#polizaID').val("");	
					 $('#impPoliza').hide();
					 $('#numCtaInstit').val("");	
				}else{
					mensajeSis("No existe la Institución");
                    $('#institucionID').val('');
                    $('#institucionID').focus();
                    $('#nombreInstitucion').val("");
				}
			});
		}else{
			mensajeSis("La Institución no existe.");
            $('#institucionID').val('');
            $('#institucionID').focus();
            $('#nombreInstitucion').val("");			
		}
	}
	
  	function validaCtaInstitucion(numCta,institID){
		var jqNumCtaInstit = eval("'#" + numCta + "'");
		var jqInstitucionID = eval("'#" + institID + "'");
		var numCtaInstit = $(jqNumCtaInstit).val();
		var institucionID = $(jqInstitucionID).val();
  		if(institucionID != '' && !isNaN(institucionID) ){
  			var CtaNostroBeanCon = {
  			        'institucionID':institucionID,
  			  		'numCtaInstit':numCtaInstit
  			};
  			cuentaNostroServicio.consultaExisteCta(catTipoConsultaCta.resumen,CtaNostroBeanCon, function(ctaNostro){              				
  				if(ctaNostro!=null){
  					dwr.util.setValues(ctaNostro);  					
  					$('#impPoliza').hide();
				}
				else{
					mensajeSis("La Cuenta Bancaria no Existe");
					$('#numCtaInstit').val('');
					deshabilitaBoton('enviar', 'submit');
                    $('#numCtaInstit').focus();
				}
  			});
  		}
  	}
  	
  	function cargaMonedas(){
		monedasServicio.listaCombo(catTipoListaMoneda.principal, function(monedas){
			dwr.util.removeAllOptions('monedaID');
			for (var i = 0; i < monedas.length; i++){
				$('#monedaID').append(new Option(monedas[i].descripcion, parseInt(monedas[i].monedaID), false, false));
			}
			$('#monedaID').val(1);
		});
	}
  	

	function cantidadPorDenominacionMil(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraMil').val(parseFloat(cantidad)*parseFloat(mil));	 
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionQui(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraQui').val(parseFloat(cantidad)*parseFloat(quinientos));	
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionDos(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraDos').val(parseFloat(cantidad)*parseFloat(doscientos));	
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionCien(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraCien').val(parseFloat(cantidad)*parseFloat(cien));
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionCin(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraCin').val(parseFloat(cantidad)*parseFloat(cincuenta));
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionVei(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraVei').val(parseFloat(cantidad)*parseFloat(veinte));
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionMon(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraMon').val(parseFloat(cantidad)*parseFloat(monedaValor));
			crearListaBilletesMonedasEntrada();
		}
	}
	
	// Para la multiplicacion de las cantidades por la denominacion
	function cantidadPorDenominacionMilS(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoSalMil').val(parseFloat(cantidad)*parseFloat(mil));
			sumaTotalSalidasEfectivo('cantSalMil','montoSalMil');
			crearListaBilletesMonedasSalida();
		}
	}
	function cantidadPorDenominacionQuiS(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoSalQui').val(parseFloat(cantidad)*parseFloat(quinientos));
			sumaTotalSalidasEfectivo('cantSalQui','montoSalQui');
			crearListaBilletesMonedasSalida();
		}
	}
	function cantidadPorDenominacionDosS(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoSalDos').val(parseFloat(cantidad)*parseFloat(doscientos));
			sumaTotalSalidasEfectivo('cantSalDos','montoSalDos');		
			crearListaBilletesMonedasSalida();
		}
	}
	function cantidadPorDenominacionCienS(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoSalCien').val(parseFloat(cantidad)*parseFloat(cien));
			sumaTotalSalidasEfectivo('cantSalCien','montoSalCien');
			crearListaBilletesMonedasSalida();
		}
	}
	
	function cantidadPorDenominacionCinS(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoSalCin').val(parseFloat(cantidad)*parseFloat(cincuenta));
			sumaTotalSalidasEfectivo('cantSalCin','montoSalCin');
			crearListaBilletesMonedasSalida();
		}
	}

	function cantidadPorDenominacionVeiS(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoSalVei').val(parseFloat(cantidad)*parseFloat(veinte));
			sumaTotalSalidasEfectivo('cantSalVei','montoSalVei');
			crearListaBilletesMonedasSalida();
		}
	}
	function cantidadPorDenominacionMonS(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).asNumber();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad >= 0 && !isNaN(cantidad)){
			$('#montoSalMon').val(parseFloat(cantidad)*parseFloat(monedaValor));
			sumaTotalSalidasEfectivo('cantSalMon','montoSalMon');
			crearListaBilletesMonedasSalida();
		}
	}	


	//para llevar el total de entradas de efectivo
	function sumaTotalSalidasEfectivo(control,controlMonto ) { 
		esTab= true;
		setTimeout("$('#cajaLista').hide();", 200);
		var jqControl  = eval("'#" + control + "'");
		var jqControlMonto= eval("'#" + controlMonto + "'");
		
		var suma = parseFloat(0);
		$('input[name=montoSalida]').each(function() {
			jqMontoSalida= eval("'#" + this.id + "'");
			montoSalida= $(jqMontoSalida).asNumber(); 
			if(montoSalida != '' && !isNaN(montoSalida)){
				suma = parseFloat(suma) + parseFloat(montoSalida);
				$(jqMontoSalida).formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});		
			}
			else {
				$(jqMontoSalida).val(0);
			}
		});
		
		if (suma > Var_SaldoCaja.replace(/\,/g,'')){
			mensajeSis("El Total es Mayor al Saldo de la Caja");// ERROR 8 saldo insuficiente de la caja
			deshabilitaBoton('enviar', 'submit');
			$(jqControl).val("0.0");
			$(jqControlMonto).val("0.0");
			$(jqControl).focus("");
		}else{
			$('#cantidad').val(suma);
			$('#cantidad').formatCurrency({
				positiveFormat: '%n', 
				roundToDecimalPlace: 2	
			});
			habilitaBoton('enviar', 'submit');
		}
	}

	
	
	 function crearListaBilletesMonedasSalida(){	
			$('#billetesMonedasSalida').val("");
			$('#billetesMonedasSalida').val($('#billetesMonedasSalida').val()+
			$('#denoSalMilID').val()+"-"+
			$('#cantSalMil').asNumber()+"-"+
			$('#montoSalMil').asNumber()+","+
			$('#denoSalQuiID').val()+"-"+
			$('#cantSalQui').asNumber()+"-"+
			$('#montoSalQui').asNumber()+","+
			$('#denoSalDosID').val()+"-"+
			$('#cantSalDos').asNumber()+"-"+
			$('#montoSalDos').asNumber()+","+
			$('#denoSalCienID').val()+"-"+
			$('#cantSalCien').asNumber()+"-"+
			$('#montoSalCien').asNumber()+","+
			$('#denoSalCinID').val()+"-"+
			$('#cantSalCin').asNumber()+"-"+
			$('#montoSalCin').asNumber()+","+
			$('#denoSalVeiID').val()+"-"+
			$('#cantSalVei').asNumber()+"-"+
			$('#montoSalVei').asNumber()+","+
			$('#denoSalMonID').val()+"-"+
			$('#cantSalMon').asNumber()+"-"+
			$('#montoSalMon').asNumber());
		}
	////inicializa parametros
	 function inicializaParametros(){
		 $('#polizaID').val("");	
	 	var parametros = consultaParametrosSession();
	 	if (parametros.tipoCaja == '' || parametros.tipoCaja == undefined){
	 		mensajeSis('El Usuario no tiene una Caja asignada.');
	 		deshabilitaItems();
	 	}else if (parametros.tipoCaja == 'CA' || parametros.tipoCaja == 'CP' || parametros.tipoCaja == 'BG'){
	 		estaAbiertaCaja($('#sucursalIDSesion').val(),$('#cajaIDSesion').val(),parametros.tipoCaja);
	 		
	 	}else{
	 		mensajeSis('El tipo de caja no esta definido correctamente');
	 		deshabilitaItems();
	 	}
	  }


	 //Consulta si la caja esta Actual esta abierta y si es CA cual es su el ID de su CP
	  function estaAbiertaCaja(sucursalID,cajaID,tipoCaja){
	 	 var CajasVentanillaBeanConCajSuc = {
	 	  			'cajaID': cajaID
	 			};
	 	 var conPrincipal = 3;
	 		cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanConCajSuc ,function(cajasVentanillaConCaja){
	 			if(cajasVentanillaConCaja != null)
	 			{
	 			if(cajasVentanillaConCaja.sucursalID != sucursalID){
	 				mensajeSis('No puede realizar esta operación ya que la sucursal del cajero no concuerda con la sucursal asignada a la caja.');
	 				deshabilitaItems();
	 			}else{

	 				var consultaCajaEO = 7;
	 				var parametrosBeanVentanilla = {
	 						'sucursalID':sucursalID,
	 						'cajaID':cajaID
	 				};
	 				//estan es para consultar la propia caja si esta cerrada, no importa si es BG pues nunca esta cerrada
	 				cajasVentanillaServicio.consulta(consultaCajaEO, parametrosBeanVentanilla , function(cajaVentanilla){
	 					if(cajaVentanilla != null)
	 					{
	 						if(cajaVentanilla.estatusOpera == 'C'){
	 							deshabilitaItems();
	 							mensajeSis('La caja se encuentra Cerrada. Apertura la Caja para Realizar Operaciones.');
	 							
	 						}else{
	 							habilitaItems();
	 							agregaFormatoControles('formaGenerica');
	 							cargaMonedas();
	 							consultaDisponibleDenominacion();
	 							limpiaGridSalida();
	 							$('#institucionID').focus();
	 							
	 						}	
	 					}
	 				});
	 			
	 			}
	 		}
	 	});
	  }
	  
	  function deshabilitaItems(){
	 	deshabilitaBoton('enviar','submit');
	 	$('#institucionID').attr('disabled',true);
	 	$('#numCtaInstit').attr('disabled',true);
	 	$('#monedaID').attr('disabled',true);
	 	$('#referencia').attr('disabled',true);
	 	limpiaGridSalida();
	 	$('#cantEntraMil').attr('disabled',true);
		$('#cantEntraQui').attr('disabled',true);
		$('#cantEntraDos').attr('disabled',true);
		$('#cantEntraCien').attr('disabled',true);
		$('#cantEntraCin').attr('disabled',true);
		$('#cantEntraVei').attr('disabled',true);
		$('#cantEntraMon').attr('disabled',true);
		$('#cantSalMil').attr('disabled',true);
		$('#cantSalQui').attr('disabled',true);
		$('#cantSalDos').attr('disabled',true);
		$('#cantSalCien').attr('disabled',true);
		$('#cantSalCin').attr('disabled',true);
		$('#cantSalVei').attr('disabled',true);
		$('#cantSalMon').attr('disabled',true);
	  }
	  function habilitaItems(){
	 	//habilitaBoton('enviar','submit');
	 	$('#institucionID').removeAttr('disabled');
	 	$('#numCtaInstit').removeAttr('disabled');
	 	$('#monedaID').removeAttr('disabled');
	 	$('#referencia').removeAttr('disabled');
		$('#cantEntraMil').removeAttr('disabled');
		$('#cantEntraQui').removeAttr('disabled');
		$('#cantEntraDos').removeAttr('disabled');
		$('#cantEntraCien').removeAttr('disabled');
		$('#cantEntraCin').removeAttr('disabled');
		$('#cantEntraVei').removeAttr('disabled');
		$('#cantEntraMon').removeAttr('disabled');
		$('#cantSalMil').removeAttr('disabled');
		$('#cantSalQui').removeAttr('disabled');
		$('#cantSalDos').removeAttr('disabled');
		$('#cantSalCien').removeAttr('disabled');
		$('#cantSalCin').removeAttr('disabled');
		$('#cantSalVei').removeAttr('disabled');
		$('#cantSalMon').removeAttr('disabled');
	  }
	  function limpiaGridSalida(){
	 		var extencion = '';
	 		for (var i = 1; i < 8; i++){
	 				var diponible = 0;
	 				var monto = parseFloat(0);
	 				var deno=0;
	 				switch(i)
	 				{
	 				case 1:	deno = 1000;
	 						extencion='Mil';
	 				break;
	 				case 2:	deno = 500;
	 						extencion='Qui';
	 				break;
	 				case 3:	deno = 200;
	 						extencion='Dos';
	 				break;
	 				case 4:	deno = 100;
	 						extencion='Cien';
	 				break;
	 				case 5:	deno = 50;
	 						extencion='Cin';
	 				break;
	 				case 6:deno = 20;
	 				extencion='Vei';
	 				break;
	 				case 7:deno = 1;
	 				extencion='Mon';
	 				break;
	 				}
	 				var jqMonto = eval("'#montoSal" + extencion + "'");
	 				var jqDisponible = eval("'#cantSal" + extencion + "'");
	 				monto = parseFloat(Number(diponible)*deno);
	 				$(jqDisponible).val(diponible);
	 				$(jqMonto).val(monto);
	 		}	
	 		$('#cantidad').val(0);
	 		$('#cantidad').formatCurrency({
	 			positiveFormat: '%n', 
	 			roundToDecimalPlace: 2	
	 		});	
	 	}
	
	 
});

function consultaDisponibleDenominacion() {
	var bean = {
			'sucursalID': parametros.sucursal,
			'cajaID': parametros.cajaID,
			'denominacionID':0,
			'monedaID':1
	};	
	ingresosOperacionesServicio.listaConsulta(1, bean,function(disponDenom){
		for (var i = 0; i < disponDenom.length; i++){
			switch(parseInt(disponDenom[i].denominacionID))
			{
			case 1:$('#disponSalMil').val(parseInt(disponDenom[i].cantidadDenominacion));
			break;
			case 2:$('#disponSalQui').val(parseInt(disponDenom[i].cantidadDenominacion));
			break;
			case 3:$('#disponSalDos').val(parseInt(disponDenom[i].cantidadDenominacion));
			break;
			case 4:$('#disponSalCien').val(parseInt(disponDenom[i].cantidadDenominacion));
			break;
			case 5:$('#disponSalCin').val(parseInt(disponDenom[i].cantidadDenominacion));
			break;
			case 6:$('#disponSalVei').val(parseInt(disponDenom[i].cantidadDenominacion));
			break;
			case 7:	$('#disponSalMon').val(disponDenom[i].cantidadDenominacion);
			break;
			}
		}
		$('#saldoEfecMNSesion').val(
		parseFloat($('#disponSalMil').asNumber()*1000)+
		parseFloat($('#disponSalQui').asNumber()*500)+
		parseFloat($('#disponSalDos').asNumber()*200)+
		parseFloat($('#disponSalCien').asNumber()*100)+
		parseFloat($('#disponSalCin').asNumber()*50)+
		parseFloat($('#disponSalVei').asNumber()*20)+
		parseFloat($('#disponSalMon').asNumber()*1));
		
		$('#saldoEfecMNSesion').formatCurrency({
				positiveFormat: '%n',
				negativeFormat: '%n',
				roundToDecimalPlace: 2
			});	
	});
		
}

function funcionExitoEnvioBancos() {
	 generaReporte( $('#consecutivo').val());
	 consultaDisponibleDenominacion();
	 deshabilitaBoton('enviar','submit');
	 $('#institucionID').val('');
	 $('#nombreInstitucion').val('');
	 $('#referencia').val('');
	 $('#numCtaInstit').val('');
	 $('#monedaID').val(1);
	 $("input[name='cantSalida']").val(0.00);
	 $("input[name='montoSalida']").val(0.00);
	 $('#cantidad').val(0);
	 var parametroBean = consultaParametrosSession();
	 Var_SaldoCaja	= parametroBean.saldoEfecMN;
	$('#saldoMNSesionLabel').text(parametroBean.saldoEfecMN);
	$('#saldoMNSesionLabel').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});		 	
	$('#impPoliza').show();
	 $('#billetesMonedasEntrada').val('');
	 $('#billetesMonedasSalida').val('');
	 cont = 0;
	 $('#institucionID').focus();
}

function funcionFalloEnvioBancos(){
	$('#impPoliza').hide();
}

var parametros = consultaParametrosSession();


function generaReporte(numTransaccion){
	quitaFormatoControles('formaGenerica');
	var fecha=parametros.fechaSucursal;
	var numeroBanco=$('#numerobanco').val();
	var nombreBanco=$('#nombreBanco').val();
	var cuenta=$('#cuenta').val();
	var estatus="E"; //ENVIO 
	var tipoReporte		= 2;
	$('#ligaPDF').attr('href','RepTicketVentanillaEnvioEfectBanc.htm?fechaSistemaP='+fecha+
		'&nombreInstitucion='+parametros.nombreInstitucion+
		'&numeroSucursal='+parametros.sucursal+
		'&nombreSucursal='+parametros.nombreSucursal+
		'&varCaja='+parametros.cajaID+
		'&nomCajero='+parametros.nombreUsuario+
		'&numCopias=2&numTrans='+numTransaccion+
		'&monedaID=PESOS'+
		'&numeroBanco='+numeroBanco+
		'&nombreBanco='+nombreBanco+
		'&cuenta='+cuenta+
		'&folioID='+numTransaccion+
		'&referencia='+$('#referencia').val()+
		'&tipoReporte='+tipoReporte+
		'&estatus='+estatus);
		$('#generar').click();
}


//Función solo Enteros sin Puntos ni Caracteres Especiales
function validaSoloNumero(e,elemento){//Recibe al evento 
	var key;
	if(window.event){//Internet Explorer ,Chromium,Chrome
		key = e.keyCode; 
	}else if(e.which){//Firefox , Opera Netscape
			key = e.which;
	}
	
	 if (key > 31 && (key < 48 || key > 57)) //se valida, si son números los deja 
	    return false;
	 return true;
}