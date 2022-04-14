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
    $('#institucionID').focus();
	consultaSaldosCaja();
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
			'recepcion' : 2
	};	
	var catTipoListaMoneda = {
			'principal': 3
	};
	var catTipoConsultaCentroCostos = {
			'foranea':2,			
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
	   		if ($('#cantidad').val() == 0){
	    			mensajeSis('No Existen Entradas de Efectivo');
	    	  }else{
	    		  $('#numerobanco').val($('#institucionID').val());
	    		  $('#nombreBanco').val($('#nombreInstitucion').val());
	    		  $('#cuenta').val($('#numCtaInstit').val());
	    		  $('#referen').val($('#referencia').val());
	    		  grabaFormaTransaccionRecepcion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','polizaID');
	    		 
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
	
	$('#cCostos').bind('keyup',function(e){
		lista('cCostos', '2', '1', 'descripcion', $('#cCostos').val(), 'listaCentroCostos.htm');
	});
	
  	$('#institucionID').blur(function() {
  		if(esTab){
  			limpiaGridEntrada();
	   		
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
	   			if(numInstitucion ==""  && numCtaInstit !=""){
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

	$('#aceptar').click(function(){
		quitaFormatoControles('formaGenerica');
		$('#tipoTransaccion').val(catTipoTransEfec.recepcion);
	});
	
	// Entrada de efectivo ------------------------------------
	//**** EVENTOS PARA LOS INPUTS DE ENTRADA DE EFECTIVO
	$('#cantEntraMil').blur(function() {
		if($('#cantEntraMil').asNumber()<=0){
			$('#cantEntraMil').val("0");
		}
		cantidadPorDenominacionMil(this.id);
		totalEntradasSalidasDiferencia();
	});
	$('#cantEntraQui').blur(function() {
		if($('#cantEntraQui').asNumber()<=0){
			$('#cantEntraQui').val("0");
		}
		cantidadPorDenominacionQui(this.id);
		totalEntradasSalidasDiferencia();
	});
	$('#cantEntraDos').blur(function() {
		if($('#cantEntraDos').asNumber()<=0){
			$('#cantEntraDos').val("0");
		}
		cantidadPorDenominacionDos(this.id);
		totalEntradasSalidasDiferencia();
	});
	$('#cantEntraCien').blur(function() {
		if($('#cantEntraCien').asNumber()<=0){
			$('#cantEntraCien').val("0");
		}
		cantidadPorDenominacionCien(this.id);
		totalEntradasSalidasDiferencia();
	});
	$('#cantEntraCin').blur(function() {
		if($('#cantEntraCin').asNumber()<=0){
			$('#cantEntraCin').val("0");
		}
		cantidadPorDenominacionCin(this.id);
		totalEntradasSalidasDiferencia();
	});
	$('#cantEntraVei').blur(function() {
		if($('#cantEntraVei').asNumber()<=0){
			$('#cantEntraVei').val("0");
		}
		cantidadPorDenominacionVei(this.id);
		totalEntradasSalidasDiferencia();
	});
	$('#cantEntraMon').blur(function() {
		if($('#cantEntraMon').asNumber()<=0){
			$('#cantEntraMon').val("0");
		}
		cantidadPorDenominacionMon(this.id);
		totalEntradasSalidasDiferencia();
	});
	$('#cCostos').blur(function(){
		if(esTab){
			consultaCentroCostos('cCostos');			
		}
		
	});
	// FIN EVENTOS PARA LOS INPUTS DE ENTRADA DE EFECTIVO

	//Fin entrada de efectivo-------------------------------------------------------------
	
	
	$('#formaGenerica').validate({
		rules: {
			institucionID : {
				required: true
			},
			numCtaInstit :{
				required: true,
				maxlength : 20	
			},
			cantidad : {
				required: true
			},
			referencia : {
				required: true
				,
				maxlength : 50
			},
			cCostos: {
				required: true
			}
		},
		
		messages: {
			institucionID : {
				required: 'Especifique No de Institución.'
			},
			numCtaInstit :{
				required: 'Especifique No Cta Bancaria.'	,
				maxlength: 'Máximo de 20 caracteres.'
			},
			cantidad : {
				required: 'Especifique Cantidad a Transferir.'
			},
			referencia : {
				required: 'Especifique la Referencia.'
					,
				maxlength: 'Máximo de 50 caracteres.'
			},
			cCostos: {
				required: 'Especifique Centro de Costos.'
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
		if(numInstituto != '' && !isNaN(numInstituto) ){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){
				if(instituto!=null){
					$('#nombreInstitucion').val(instituto.nombre);
					 $('#numCtaInstit').val("");	
				}else{
					mensajeSis("La Institución no existe.");
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
  					habilitaBoton('enviar', 'submit');
				}
				else{
					mensajeSis("La Cuenta Bancaria no Existe.");
					$('#numCtaInstit').val("");
                    $('#numCtaInstit').focus();
					deshabilitaBoton('enviar', 'submit'); 
					setTimeout("$('#cajaLista').hide();", 200);
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
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionQui(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraQui').val(parseFloat(cantidad)*parseFloat(quinientos));	
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionDos(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraDos').val(parseFloat(cantidad)*parseFloat(doscientos));	
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionCien(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraCien').val(parseFloat(cantidad)*parseFloat(cien));
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionCin(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraCin').val(parseFloat(cantidad)*parseFloat(cincuenta));
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionVei(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad != '' && !isNaN(cantidad)){
			$('#montoEntraVei').val(parseFloat(cantidad)*parseFloat(veinte));
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
		}
	}
	function cantidadPorDenominacionMon(idControl) {
		var jqCant  = eval("'#" + idControl + "'");
		var cantidad = $(jqCant).asNumber();	
		setTimeout("$('#cajaLista').hide();", 200);
		if(cantidad >=0 && !isNaN(cantidad)){
			$('#montoEntraMon').val(parseFloat(cantidad)*parseFloat(monedaValor));
			sumaTotalEntradasEfectivo();
			crearListaBilletesMonedasEntrada();
		}
	}
	//para llevar el total de entradas de efectivo
	function sumaTotalEntradasEfectivo() { 
		esTab= true;
		setTimeout("$('#cajaLista').hide();", 200);
		var suma = parseFloat(0);
		$('input[name=montoEntrada]').each(function() {
			jqMontoEntrada = eval("'#" + this.id + "'");
			montoEntrada= $(jqMontoEntrada).asNumber(); 
			if(montoEntrada != '' && !isNaN(montoEntrada) && esTab){
				suma = parseFloat(suma) + parseFloat(montoEntrada);
				$(jqMontoEntrada).formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});		
			}
			else {
				$(jqMontoEntrada).val(0);
			}
		});
		$('#cantidad').val(suma);
		$('#cantidad').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});		
	}
	function crearListaBilletesMonedasEntrada(){
		$('#billetesMonedasEntrada').val("");
		$('#billetesMonedasEntrada').val($('#billetesMonedasEntrada').val()+
		$('#denoEntraMilID').val()+"-"+
		$('#cantEntraMil').asNumber()+"-"+
		$('#montoEntraMil').asNumber()+","+
		$('#denoEntraQuiID').val()+"-"+
		$('#cantEntraQui').asNumber()+"-"+
		$('#montoEntraQui').asNumber()+","+
		$('#denoEntraDosID').val()+"-"+
		$('#cantEntraDos').asNumber()+"-"+
		$('#montoEntraDos').asNumber()+","+
		$('#denoEntraCienID').val()+"-"+
		$('#cantEntraCien').asNumber()+"-"+
		$('#montoEntraCien').asNumber()+","+
		$('#denoEntraCinID').val()+"-"+
		$('#cantEntraCin').asNumber()+"-"+
		$('#montoEntraCin').asNumber()+","+
		$('#denoEntraVeiID').val()+"-"+
		$('#cantEntraVei').asNumber()+"-"+
		$('#montoEntraVei').asNumber()+","+
		$('#denoEntraMonID').val()+"-"+
		$('#cantEntraMon').asNumber()+"-"+
		$('#montoEntraMon').asNumber());
	}
	
	function consultaDisponibleDenominacion() {	
		var bean = {
				'sucursalID':$('#numeroSucursal').val(),
				'cajaID':$('#numeroCaja').val(),
				'denominacionID':0,
				'monedaID':1
			};	
		ingresosOperacionesServicio.listaConsulta(1, bean,function(disponDenom){
			for (var i = 0; i < disponDenom.length; i++){
				switch(parseInt(disponDenom[i].denominacionID))
				{
				case 1:$('#disponSalMil').val(disponDenom[i].cantidadDenominacion);
				break;
				case 2:$('#disponSalQui').val(disponDenom[i].cantidadDenominacion);
				break;
				case 3:$('#disponSalDos').val(disponDenom[i].cantidadDenominacion);
				break;
				case 4:$('#disponSalCien').val(disponDenom[i].cantidadDenominacion);
				break;
				case 5:$('#disponSalCin').val(disponDenom[i].cantidadDenominacion);
				break;
				case 6:$('#disponSalVei').val(disponDenom[i].cantidadDenominacion);
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

//para llevar el total de entradas
	function totalEntradasSalidasDiferencia() {
		//consultarParametrosBean();
		controlQuitaFormatoMoneda('sumTotalSal');
		controlQuitaFormatoMoneda('sumTotalEnt');
		esTab= true;
		setTimeout("$('#cajaLista').hide();", 200);
		var sumaEntradas = parseFloat(0);
		var sumaSalidas = parseFloat(0);
		var diferencia = parseFloat(0);
		var sumTotalSal= $('#sumTotalSal').asNumber(); 
		var sumTotalEnt= $('#sumTotalEnt').asNumber(); 
		var montoCargar= $('#montoCargar').asNumber(); 
		var montoAbonar= $('#montoAbonar').asNumber(); 
		var montoPagar= $('#montoPagar').asNumber();
		var montoGarLiq= $('#montoGarantiaLiq').asNumber();
		var montoApCre= $('#totalDepAR').asNumber();
		var montoDesCre= $('#totalRetirarDC').asNumber();
		
		sumaEntradas= parseFloat(sumTotalEnt)+ parseFloat(montoCargar) +parseFloat(montoDesCre);
		
		sumaSalidas	= parseFloat(sumTotalSal)+ parseFloat(montoAbonar) + parseFloat(montoPagar)+parseFloat(montoGarLiq)+parseFloat(montoApCre);
	
		
		if(parseFloat(sumaEntradas)>=parseFloat(sumaSalidas)){
			diferencia = parseFloat(sumaEntradas)- parseFloat(sumaSalidas) ;
		}else{
			diferencia = parseFloat(sumaSalidas)- parseFloat(sumaEntradas) ;
		}
		
		$('#totalEntradas').val(sumaEntradas);
		$('#totalSalidas').val(sumaSalidas);
		$('#diferencia').val(diferencia);
		
	}
	 function grabaFormaTransaccionRecepcion(event, idForma, idDivContenedor, idDivMensaje, inicializaforma, idCampoOrigen) {
		 consultaSesion();
		 var jqForma = eval("'#" + idForma + "'");
		 var jqContenedor = eval("'#" + idDivContenedor + "'");
		 var jqMensaje = eval("'#" + idDivMensaje + "'");
		 var url = $(jqForma).attr('action');
		 var resultadoTransaccion = 0;	
		 
		 quitaFormatoControles(idForma);
		 //	No descomentar la siguiente linea
		 //event.preventDefault();
		 $(jqMensaje).html('<img src="images/barras.jpg" alt=""/>');   
		 $(jqContenedor).block({
			 message: $(jqMensaje),
			 css: {border:		'none',
				 background:	'none'}
		 });
		 // 	Envio de la forma
		 $.post( url, serializaForma(idForma), function( data ) {
			 if(data.length >0) {
				 $(jqMensaje).html(data);
				 var exitoTransaccion = $('#numeroMensaje').val();
				 resultadoTransaccion = exitoTransaccion; 
				 if (exitoTransaccion == 0 ){
					 consultaSaldosCaja();
					 deshabilitaBoton('enviar','submit');					
					 $('#institucionID').val('');
					 $('#nombreInstitucion').val('');
					 $('#referencia').val('');					
					 $('#numCtaInstit').val('');
					 $('#monedaID').val(1);
					 $("input[name='cantSalida']").val(0);
					 $("input[name='montoSalida']").val(0);
					 $('#cantidad').val(0);					
					 $('#cCostos').val('');
					 $('#nombrecCostos').val('');
					 
					 var parametroBean = consultaParametrosSession();
					$('#saldoMNSesionLabel').text(parametroBean.saldoEfecMN);
					$('#saldoMNSesionLabel').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});		
					 generaReporte($('#consecutivo').val() );
					 inicializaParametros();
				 }
				 var campo = eval("'#" + idCampoOrigen + "'");
				 if($('#consecutivo').val() != 0){
					 $(campo).val($('#consecutivo').val());
				 }					 }
		 });
		 return resultadoTransaccion;
	 }
	 function consultaSaldosCaja(){
		var numConsulta = 2;
		var beanCaja = {
				'cajaID'		: parametros.cajaID
		};
		cajasVentanillaServicio.consulta(numConsulta, beanCaja, function(saldo){
			if (saldo !=null){
				$('#saldoEfecMNSesion').val(saldo.saldoEfecMN);
				$('#saldoEfecMNSesion').formatCurrency({
					positiveFormat: '%n',
					negativeFormat: '%n',
					roundToDecimalPlace: 2
				});		
			}
		});
	}	 
	function inicializaParametros(){
		deshabilitaItems();
		limpiaForm('formaGenerica');
		agregaFormatoControles('formaGenerica');
		var parametros = consultaParametrosSession();
		if (parametros.tipoCaja == '' || parametros.tipoCaja == undefined){
			mensajeSis('El Usuario no tiene una Caja asignada.');
		}else if (parametros.tipoCaja == 'CA' || parametros.tipoCaja == 'CP' || parametros.tipoCaja == 'BG'){
			estaAbiertaCaja($('#sucursalIDSesion').val(),$('#cajaIDSesion').val(),parametros.tipoCaja);
			
		}else{
			mensajeSis('La caja no esta definida correctamente');
		}
		
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
						deshabilitaBoton('cierre','submit');
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
									cargaMonedas();
									limpiaGridEntrada();
									$('#institucionID').focus();
								}	
							}
						});
					
					}
				}
				
			});
		 }
	} 
	
	
	//Función para consultar el centro de  costos 
	  function consultaCentroCostos(idControl) {
	  	var jqCentro = eval("'#" + idControl + "'");
	  	var numCentro = $(jqCentro).val();
	  	setTimeout("$('#cajaLista').hide();", 200);	
	  	var centroBeanCon = {
	  		'centroCostoID' : $('#cCostos').val()
	  	};
	  	if(numCentro != '' && !isNaN(numCentro)){
	  		centroServicio.consulta(catTipoConsultaCentroCostos.foranea,centroBeanCon,function(centro) {
	  			if(centro!=null){
	  				$('#nombrecCostos').val(centro.descripcion);
	  				$('#cantEntraMil').focus();
	  			}else{
	  				mensajeSis("No Existe el Centro de Costos");
	  				$('#cCostos').val("");
	  				$('#nombrecCostos').val("");
                    $('#cCostos').focus();
	  			}
	  		});
	  	}else{
	  		if($('#cCostos').val() == ''){
  				$('#nombrecCostos').val("");
	  			$('#cantEntraMil').focus();
	  		}else{
		  		$('#cCostos').focus();
		  		$('#cCostos').val('');
		  		$('#nombrecCostos').val('');	  			
	  		}
	  	}
	  }	
	
	
	function deshabilitaItems(){
		deshabilitaBoton('aceptar', 'submit');
		$('#institucionID').attr('disabled',true);
		$('#numCtaInstit').attr('disabled',true);
		$('#monedaID').attr('disabled',true);
		$('#referencia').attr('disabled',true);
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
		$('#cCostos').attr('disabled',true);
	}
	function habilitaItems(){
		habilitaBoton('aceptar', 'submit');
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
		$('#cCostos').removeAttr('disabled');
	}
	function limpiaGridEntrada(){
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
				var jqMonto = eval("'#montoEntra" + extencion + "'");
				var jqDisponible = eval("'#cantEntra" + extencion + "'");
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
	
	function generaReporte(numTransaccion){
		quitaFormatoControles('formaGenerica');
		var fecha=parametros.fechaSucursal;
		var numeroBanco=$('#numerobanco').val();
		var nombreBanco=$('#nombreBanco').val();
		var cuenta=$('#cuenta').val();
		var estatus="R"; //Recepcion 
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
			'&referencia='+$('#referen').val()+
			'&tipoReporte='+tipoReporte+
			'&estatus='+estatus);
			$('#generar').click();
	}
});







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










