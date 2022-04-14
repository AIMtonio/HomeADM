var catFormTipoCalInt = { 
		'principal'	: 1,
};
var TasaFijaID = 1; // ID de la formula para tasa fija (FORMTIPOCALINT)
var TasaBasePisoTecho = 3; // ID de la formula para tasa base con piso y techo (FORMTIPOCALINT)
var VarTasaFijaoBase = 'Tasa Fija'; // Texto que indica si se trata de tasa fija o tasa base actual (alert)
var tipoInstitucion = 0; // Para determinar si es SOFIPO o SOFOM, SOCAP
var tipoSOFIPO		= 3; // Clave del Tipo de Institucion SOFIPO
var cobraAccesorios = 'N';

$(document).ready(function(){
	esTab = true;
	
	//Definición de constantes y Enums
	var catTipoConsultaCredito = { 
  		'principal'	: 1,
  		'foranea'	: 2
	};	
	 
	validaMonitorSolicitud();
	consultaTipoInstitucion();
			
	//-----------------------Métodos y manejo de eventos-----------------------
	deshabilitaBoton('amortiza', 'submit');
	deshabilitaBoton('movimientos', 'submit'); 
	deshabilitaControl('tipoPrepago');
		
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
                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID'); 
            }
    });	
		
   	$('#creditoID').focus().select();
	$('#amortiza').click(function(){
		consultaGridAmortizaciones();
			
	});

	// llena el combo para la Formula de Calculo de Interés 
	consultaComboCalInteres();
	muestraCamposTasa(0);

	$('#movimientos').click(function(){
		consultaGridMovimientos();
		});
	
		
	$('#creditoID').blur(function(){
		consultaCredito(this.id);		
	});		
		
	$('#creditoID').bind('keyup', function(e){
		lista('creditoID', '2', '47', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});

	$('#totalAde').click(function(){
		if($('#exigible').is(':checked')){   
			$('#exigible').attr('checked',false);
		}
		$('#totalAde').attr('checked',true);
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
		
		consultaGrupoDeudaTotalFiniquito();
		consultaFiniquitoLiqAnticipada();
	});
	
	$('#exigible').click(function(){ 
		if($('#totalAde').is(':checked')){  
			$('#totalAde').attr('checked',false);			
		}
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

		if($('#totalAde').is(':checked')){  
			$('#totalAde').attr('checked',false);
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
	});
	
//-------------Validaciones de controles---------------------
			
	
	
	function validaMonitorSolicitud() {
	
		// seccion para validar si la pantalla fue llamada desde la pantalla de Monitor de Solicitud 
		if ($('#monitorSolicitud').val() != undefined) {
			var credito = $('#numSolicitud').val();
			var creditoID = 'creditoID';
			$('#creditoID').val(credito);
			consultaCredito(creditoID);
		}
	}

		
	function consultaCredito(controlID){
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			var creditoBeanCon = { 
				'creditoID':$('#creditoID').val()
				};
  			$('#gridAmortizacion').hide();
  			$('#gridMovimientos').hide();
  			$('#totalAde').attr('checked',false); 
  			$('#exigible').attr('checked',true);  
			creditosServicio.consulta(18, creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
				if(credito!=null){
					esTab=true;	
					dwr.util.setValues(credito);
					$('#tipoPrepago').val(credito.tipoPrepago);
					consultaCliente('clienteID');			
					consultaMoneda('monedaID');							
					consultaLineaCredito('lineaCreditoID');	
					consultaProducCredito('producCreditoID');							
					var estatus = credito.estatus;
					muestraCamposTasa(credito.calcInteresID);
					validaEstatusCredito(estatus);
					if($('#lineaCreditoID').val()== '0'){
						$('#linea').hide();
					}
					habilitaBoton('amortiza', 'submit');
					habilitaBoton('movimientos', 'submit');	
					
					$('#grupoID').val(credito.grupoID);  
					if(credito.grupoID > 0){
						$('#cicloID').val(credito.cicloGrupo);
						consultaGrupo(credito.grupoID,'grupoID','grupoDes','cicloID');
						consultaGrupoTotalExigible();					
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
					}
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

				}else{
					inicializaForma('formaGenerica','creditoID');
					mensajeSis("No Existe el Crédito");
					deshabilitaBoton('desembolsar', 'submit');
					muestraCamposTasa(0);
					$('#creditoID').focus();
					$('#creditoID').select();	
				}
			});
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
			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
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
					/*SEGURO CUOTA*/
					$('#saldoSeguroCuota').val(credito.saldoSeguroCuota);
					$('#saldoIVASeguroCuota').val(credito.saldoIVASeguroCuota);
					/*FIN SEGURO CUOTA*/
					/*COM ANUAL CRED*/
					$('#saldoComAnual').val(credito.saldoComAnual);
					$('#saldoComAnualIVA').val(credito.saldoComAnualIVA);
					/*FIN COM ANUAL CRED*/
					$('#totalComisi').val(credito.totalComisi);  
					$('#salIVAComFalPag').val(credito.salIVAComFalPag);
					$('#saldoIVAComisi').val(credito.saldoIVAComisi);
					$('#totalIVACom').val(credito.totalIVACom);
					$('#pagoExigible').val(credito.pagoExigible);
			
					$('#exigibleAlDia').val(credito.totalExigibleDia);
					$('#montoProyectado').val(credito.totalCuotaAdelantada);
					$('#exigibleDiaPago').val(credito.totalExigibleDia);
					
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
				}else{
					mensajeSis("No Existe");
					deshabilitaBoton('pagar', 'submit');
				}
			});
		}
	}
	
	function consultaFiniquitoLiqAnticipada(){
		try{
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
			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,{
				callback :function(credito) {//catTipoConsultaCredito.saldos
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
						/*SEGURO CUOTA*/
						$('#saldoSeguroCuota').val(credito.saldoSeguroCuota);
						$('#saldoIVASeguroCuota').val(credito.saldoIVASeguroCuota);
						/*FIN SEGURO CUOTA*/
						/*COM ANUAL CRED*/
						$('#saldoComAnual').val(credito.saldoComAnual);
						$('#saldoComAnualIVA').val(credito.saldoComAnualIVA);
						/*FIN COM ANUAL CRED*/

						$('#saldoAdmonComis').val(credito.saldoAdmonComis);	
						$('#saldoIVAAdmonComisi').val(credito.saldoIVAAdmonComisi);
						$('#permiteFiniquito').val(credito.permiteFiniquito);
						$('#pagoExigible').val("");
						
						if($('#grupoID').val() > 0){  						
							$('#labelTotalAdeGrupalPC').show();
							$('#montoTotDeudaPC').show();													
						}						
						$('#labelTotalAdeudoPC').show();
						$('#adeudoTotal').show();  	
					} else{
						mensajeSis("El Producto de Crédito no permite Finiquitos o Liquidaciones Anticipadas");
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
			},
			errorHandler : function(errorString,exception) {
				mensajeSis("Error en consulta de Total de Adeudo." 
				+ errorString);
			}
			});
		}
		}
		catch (err) {
			mensajeSis(err)
		}
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
			gruposCreditoServicio.consulta(tipConGrupo, grupoBean,function(grupo) {
				if(grupo!=null){	
					$(jqIDGrupo).val(grupo.grupoID);
					$(jqDesGrupo).val(grupo.nombreGrupo);	
				}
			});															
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
			gruposCreditoServicio.consulta(tipConTotalExigible, grupoBean,function(grupoDeudaTotalExi) {
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
			});															
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
			gruposCreditoServicio.consulta(tipConDeudaTotal, grupoBean,function(grupoDeudaTotal) {
				if(grupoDeudaTotal!=null){	
					$('#montoTotDeudaPC').val(grupoDeudaTotal.montoTotDeuda);	
					$('#montoTotDeudaPC').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});	 
				
				}
			});															
		}
	}
	
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
						if(cliente!=null){	
							$('#clienteID').val(cliente.numero);				
							$('#nombreCliente').val(cliente.nombreCompleto);
						}else{
							mensajeSis("No Existe el Cliente");
							$('#clienteID').focus();
							$('#clienteID').select();	
						}    	 						
				});
			}
		}
		
		
	function consultaMoneda(idControl) {
		var jqMoneda = eval("'#" + idControl + "'");
		var numMoneda = $(jqMoneda).val();	
		var conMoneda=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMoneda != '' && !isNaN(numMoneda)){
			monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
					if(moneda!=null){							
						$('#monedaDes').val(moneda.descripcion);										
					}else{
						mensajeSis("No Existe el Tipo de Moneda");
						$('#monedaDes').val('');
						$(jqMoneda).focus();
					}
			});
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
			lineasCreditoServicio.consulta(catTipoConsultaCredito.principal,lineaCreditoBeanCon,function(linea) {
			
					if(linea!=null){
						var estatus = linea.estatus;
						$('#saldoDisponible').val(linea.saldoDisponible);
						$('#dispuesto').val(linea.dispuesto);
						$('#numeroCreditos').val(linea.numeroCreditos);
						validaEstatusLineaCred(estatus);
							
					}						
			});																						
		}
	}
	
	
	//Grid Amortizaciones
	
		function consultaGridAmortizaciones(){
		var params = {};
		quitaFormatoControles('formaGenerica');
		params['creditoID'] = $('#creditoID').val();
		params['tipoLista'] = 2;
		params['cobraSeguroCuota'] 	= $('#cobraSeguroCuota option:selected').val();
		params['cobraAccesorios'] = cobraAccesorios;
		
		$('#gridMovimientos').hide();
		$.post("consultaCredAmortiGridVista.htm", params, function(data){		
				if(data.length >0) {
					$('#gridAmortizacion').html(data);
					$('#gridAmortizacion').show();
					agregaFormatoControles('gridDetalleMov');
					agregaFormatoControles('formaGenerica2');
					
						

					if ($('#siguiente').is(':visible') && $('#anterior').is(':visible')==false){
						$('#filaTotales').hide();	
					}

					if ($('#siguiente').is(':visible')==false && $('#anterior').is(':visible')==false){
						$('#filaTotales').show();	
					}
					muestraDescTasaVar('calcInteresID');
				}else{
					$('#gridAmortizacion').html("");
					$('#gridAmortizacion').show();
				}
		});
		agregaFormatoControles('formaGenerica');
	}
	
////Grid movimientos
	function consultaGridMovimientos(){
		var params = {};
		quitaFormatoControles('formaGenerica');
		params['creditoID'] = $('#creditoID').val();
		params['tipoLista'] = 1;
		
		$('#gridAmortizacion').hide();
		$.post("creditoConsulMovsGridVista.htm", params, function(data){		
				if(data.length >0) {
					$('#gridMovimientos').html(data);
					$('#gridMovimientos').show(); 
					agregaFormatoControles('gridDetalle');
					agregaFormatoControles('formaGenerica2');
					 //alternaFilas('alternacolor');
				}else{
					$('#gridMovimientos').html("");
					$('#gridMovimientos').show();
				}
		});
		agregaFormatoControles('formaGenerica');
	}

		
		function validaEstatusCredito(var_estatus) {
		var estatusInactivo 		="I";		
		var estatusAutorizado 	="A";
		var estatusVigente		="V";
		var estatusPagado			="P";
		var estatusCancelada 	="C";		
		var estatusVencido		="B";
		var estatusCastigado 	="K";		
		
		if(var_estatus == estatusInactivo){
			 
			 $('#estatus').val('INACTIVO');
		}	
		if(var_estatus == estatusAutorizado){
			 
			 $('#estatus').val('AUTORIZADO');
		}
		if(var_estatus == estatusVigente){
			 
			 $('#estatus').val('VIGENTE');
		}
		if(var_estatus == estatusPagado){
			 
			 $('#estatus').val('PAGADO');
		}
		if(var_estatus == estatusCancelada){
			
			 $('#estatus').val('CANCELADO');
		}
		if(var_estatus == estatusVencido){
			 
			 $('#estatus').val('VENCIDO');
		}
		if(var_estatus == estatusCastigado){
			
			 $('#estatus').val('CASTIGADO');
		}		
	}
	
	function validaEstatusLineaCred(var_estatus) {
		var estatusActivo 	="A";
		var estatusBloqueado ="B";
		var estatusCancelada ="C";
		var estatusInactivo 	="I";
		var estatusRegistrada="R";
	
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

	function consultaProducCredito(idControl) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();			
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
				productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
					if(prodCred!=null){	
						cobraAccesorios = prodCred.cobraAccesorios;
						$('#descripProducto').val(prodCred.descripcion);
						if(prodCred.permitePrepago=='S'){
						$('#tipoPrepagoTD').show();
						$('#tipoPrepagoTD1').show();
						$('#separador').show();
						}
						else{
						$('#tipoPrepagoTD').hide();
						$('#tipoPrepagoTD1').hide();
						$('#separador').hide();
						}
						
					}else{							
						mensajeSis("No Existe el Producto de Crédito");																			
					}
			});
			}									
		}	
	});


	// Funcion que llena el combo de calcInteres
	function consultaComboCalInteres() {
		dwr.util.removeAllOptions('calcInteresID'); 
		formTipoCalIntServicio.listaCombo(catFormTipoCalInt.principal,function(formTipoCalIntBean){
			dwr.util.addOptions('calcInteresID', {'':'SELECCIONAR'});
			dwr.util.addOptions('calcInteresID', formTipoCalIntBean, 'formInteresID', 'formula');
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
			tasasBaseServicio.consulta(1, TasaBaseBeanCon, function(tasasBaseBean) {
				if (tasasBaseBean != null) {
					$('#desTasaBase').val(tasasBaseBean.nombre);
					$('#tasaBaseValor').val(tasasBaseBean.valor+'%');
					$('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
					$('#tasaBaseValor').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
				} else {
					$('#desTasaBase').val('');
					$('#tasaBaseValor').val('');
				}
			});
		}
	}

	// Funcion que muestra los campos de la tasa variable
	function muestraCamposTasa(calcInteresID){
		calcInteresID = Number(calcInteresID);
		$('#calcInteresID').val(calcInteresID);
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
	}



	// Consulta el tipo de institucion
	function consultaTipoInstitucion() {			
		var parametrosSisCon ={
	 		 	'empresaID' : 1
		};			
		parametrosSisServicio.consulta(15,parametrosSisCon, function(institucion) {
			if (institucion != null) {			
				tipoInstitucion = institucion.tipoInstitID;

				if(tipoInstitucion == tipoSOFIPO){
					$('.tipoSofipo').show();
				}else{
					$('.tipoSofipo').hide();
				}
			}
		});
	}
