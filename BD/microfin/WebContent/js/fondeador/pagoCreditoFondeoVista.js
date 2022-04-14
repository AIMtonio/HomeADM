var catTipoReport={
		'reporteExcel':1
};			
$(document).ready(function() {
				esTab = true;
				 
				//Definicion de Constantes, Variables  y Enums
				var catTipoTransaccionCre = {
			  		'pagar'		: '3',
			  		'prepago'	: '4'
				};
				
				var catTipoConsultaCtaNostro = {
						'resumen':4
				};	
				var catTipoConsultaCreditoFondeo={
						'principal':1
				};
				
				//------------ Metodos y Manejo de Eventos -----------------------------------------
				$('#tiposDivisa').hide();
				$('#exportarExcel').hide();
				inicializarCampos();
				$('#institutFondID').focus();
				$('#tipoTransaccion').val(catTipoTransaccionCre.pagar);
				
				$(':text').focus(function() {	
				 	esTab = false;
				});
			
				$.validator.setDefaults({
			      submitHandler: function(event) {
						habilitaControl('montoPagar');
			    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','creditoFondeoID','funcionExitoPagoCrePasivo','funcionFalloPagoCrePasivo');
			      }
			   });				
			
				$(':text').bind('keydown',function(e){
					if (e.which == 9 && !e.shiftKey){
						esTab= true;
					}
				});
				
				$('#institutFondID').bind('keyup',function(e){
					lista('institutFondID', '2', '1', 'nombreInstitFon', $('#institutFondID').val(), 'intitutFondeoLista.htm');
				});
			
				$('#institutFondID').blur(function() { 
					limpiaCajas();
					$('#nombreInstitFondeo').val("");
					$('#lineaFondeoID').val("");
			  		esTab=true;
					validaInstitucion(); 
					
				});
				
				$('#lineaFondeoID').bind('keyup',function(e){
					var camposLista = new Array();
					var parametrosLista = new Array();
			
					camposLista[0] = "descripLinea";
					camposLista[1] = "institutFondID";
			
			
					parametrosLista[0] = $('#lineaFondeoID').val();
					parametrosLista[1] = $('#institutFondID').val();
					
					lista('lineaFondeoID', '2', '2', camposLista, parametrosLista, 'listaLineasFondeador.htm');
				});
				
				$('#lineaFondeoID').blur(function() { 
					limpiaCajas();
					validaLineaFondeo(this.id); 
					$('#creditoFondeoID').focus();
				});
				
				$('#creditoFondeoID').bind('keyup',function(e){
					if(this.value.length >= 2){
						var camposLista = new Array();
						var parametrosLista = new Array();
						camposLista[0] = "nombreInstitFon";
						camposLista[1] = "lineaFondeoID";
						camposLista[2] = "institutFondID";
				      			
						parametrosLista[0] = $('#creditoFondeoID').val();
						parametrosLista[1] = $('#lineaFondeoID').val();
						parametrosLista[2] = $('#institutFondID').val();
						
						lista('creditoFondeoID', '1', '4', camposLista, parametrosLista, 'listaCreditoFondeo.htm');
					}				       
				});	
				
				$('#creditoFondeoID').blur(function(){
					validaCreditoFondeo();
					validaCreditoPasivo(this.id);
					$('#gridAmortiCredFonMovs').html("");
					$('#gridAmortiCredFonMovs').hide();
					$('#gridAmortiCredFonMovs').html("");
					$('#gridAmortiCredFonMovs').hide();

					consultaRelacion(this.id);
			
				});
				
				$('#institucionID').bind('keyup',function(e){
					listaAlfanumerica('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
				});
				
				$('#institucionID').blur(function() {
					if($('#institucionID').val()!=""){
						consultaInstitucion(this.id);  
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
			   		if($('#numCtaInstit').val()!="" && $('#institucionID').val()!=""){
			   			validaCtaNostroExiste('numCtaInstit','institucionID');
			   		}		
			   	});
			
				$('#creditoID').bind('keyup',function(e){
			       	var camposLista = new Array();
					var parametrosLista = new Array();
					camposLista[0] = "nombreCliente";
					camposLista[1] = "creditoFondeoID";
					parametrosLista[0] = $('#creditoID').val();
					parametrosLista[1] = $('#creditoFondeoID').val();
					listaAlfanumerica('creditoID', '2', '62', camposLista,parametrosLista, 'listaPagosCredito.htm');	       
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
				

				//Clic a boton pagar
				$('#pagar').click(function() {
					botonClicModificar = "0";
					$('#exportarExcel').hide();
				});
				
				$('#exigible').click(function(){
					$('#tipoTransaccion').val(catTipoTransaccionCre.pagar);
					$('#prepagoCredito').attr('checked',false);
					$('#totalAde').attr('checked',false);			
					$('#exigible').attr('checked',true);	
					$('#finiquito').val('N');
					consultaExigible();
					validaCreditoPasivo('creditoFondeoID');
					$('#divTipoPrepago').hide(); 
					$('#divTipoPrepago1').hide(); 
				});
				
			
				$('#totalAde').click(function(){
					$('#tipoTransaccion').val(catTipoTransaccionCre.pagar);
					$('#prepagoCredito').attr('checked',false);
					$('#totalAde').attr('checked',true);			
					$('#exigible').attr('checked',false);	
					$('#finiquito').val('S');		
					consultaTotalAdeudo();
					$('#montoPagar').val($('#adeudoTotal').val());
					deshabilitaControl('montoPagar');
					deshabilitaControl('pagosParciales');
					$('#pagosParciales').val('N');
					$('#divTipoPrepago').hide(); 
					$('#divTipoPrepago1').hide(); 
				});
			
				$('#prepagoCredito').click(function(){
					$('#tipoTransaccion').val(catTipoTransaccionCre.prepago);
					$('#prepagoCredito').attr('checked',true);
					$('#totalAde').attr('checked',false);			
					$('#exigible').attr('checked',false);	
					$('#finiquito').val('N');		
					consultaMontoPrepago();
					validaCreditoPasivo('creditoFondeoID');
					$('#divTipoPrepago').show();
					$('#divTipoPrepago1').show();
				});
				
				// evento para consultar amortizaciones
				$('#amortiza').click(function(){
					consultaGridAmortizaciones();
					$('#exportarExcel').hide();
				});
				
				// evento para consultar movimientos 
				$('#movimientos').click(function(){
					consultaGridMovimientos();
				});
			
				// evento para generar reporte de la poliza 
				$('#impPoliza').click(function(){
					$('#enlace').attr('href','RepPoliza.htm?polizaID='+numeroPoliza+'&fechaInicial='+parametroBean.fechaSucursal+
							'&fechaFinal='+parametroBean.fechaSucursal+'&nombreUsuario='+parametroBean.nombreUsuario);
				});
				$('#pagosParciales').change(function(){
					if($('#finiquito').val()=='N'){
						if($('#pagosParciales').val()=='N'){
							$('#montoPagar').val($('#pagoExigible').val());
							deshabilitaControl('montoPagar');
						}else{
							habilitaControl('montoPagar');
							$('#montoPagar').val('');
							habilitaControl('pagosParciales');
							
						}
					}else{
							$('#pagosParciales').val('N');
							$('#montoPagar').val($('#adeudoTotal').val());
							deshabilitaControl('montoPagar');
							deshabilitaControl('pagosParciales');
						
					}
				});
				$('#montoPagar').blur(function(){
					var Monto=$('#montoPagar').asNumber();
					var PagoExigible=$('#pagoExigible').asNumber();
					var TotalAdeudo=$('#adeudoTotal').asNumber();
					
					if($('#monedaID').asNumber() > 1){
						var tipCamFixCom = $('#tipCamFixCom').asNumber();
						var montoPagoMNX = tipCamFixCom * Monto; 
						$('#montoPagoMNX').val(formatoMoneda(roundToTwo(montoPagoMNX)));
					}
								
					if($('#prepagoCredito').is(':checked')){
						if(Monto>TotalAdeudo){
							mensajeSis("El Monto a Pagar no debe de ser Mayor al Adeudo Total.");
							$('#montoPagar').val('');
							$('#montoPagar').focus();
						}
					} else if($('#finiquito').val()=='N'){
						if(Monto>PagoExigible){
							mensajeSis("El Monto a Pagar no debe de ser Mayor al Pago Exigible.");
							$('#montoPagar').val('');
							$('#montoPagar').focus();
						}
					}else{
						if(Monto>TotalAdeudo){
							mensajeSis("El Monto a Pagar no debe de ser Mayor al Adeudo Total.");
							$('#montoPagar').val('');
							$('#montoPagar').focus();
						}
					}
			   				
			   	});
				//------------ Validaciones de la Forma -------------------------------------
				$('#formaGenerica').validate({
					rules: {
						creditoFondeoID: 'required'	,
						
						institutFondID: {	number: true,
											required: true},
						lineaFondeoID: {	number: true,
											required: true},
						montoPagar: {	number: true,
										required: true}
																									
					},
					messages: {
						creditoFondeoID: 'Especifique Número de Crédito Pasivo',
						institutFondID: {	number: 'Soló números',
											required: 'Indique la Institución de Fondeo'},
						lineaFondeoID: {	number: 'Soló números',
											required: 'Indique la Linea de Fondeo'}	,	
						montoPagar: {	number: 'Soló números',
										required: 'Indique el monto a pagar'}																						
					}		
				});
				
				//------------ Validaciones de Controles -------------------------------------
			
				function validaInstitucion() {
					var numInst = $('#institutFondID').val();
					setTimeout("$('#cajaLista').hide();", 200);
					esTab=true;
					if(numInst != '' && !isNaN(numInst) && esTab){
						if(numInst=='0'){
							mensajeSis("No Existe la Institucion de Fondeo");
							$('#institutFondID').focus();
							$('#institutFondID').val('');
							limpiaCajas();
							
						} else {
							var instFondeoBeanCon = { 
								'institutFondID':numInst  				
							};
							fondeoServicio.consulta(1,instFondeoBeanCon,function(instFondeo) {
								if(instFondeo!=null){
									$('#nombreInstitFondeo').val(instFondeo.nombreInstitFon);
									$('#numCtaInstit').val("");
									$('#cuentaClabe').val("");
								}else{
									mensajeSis("No Existe la Institucion de Fondeo");
									$('#institutFondID').focus();
									$('#institutFondID').val('');
									$('#nombreInstitFondeo').val('');
									$('#gridAmortiCredFonMovs').hide();
									limpiaCajas();
									
								}
							});		
						}
					}										
				}
			
				function validaLineaFondeo(control) {
					var numLinea = $('#lineaFondeoID').val();
					setTimeout("$('#cajaLista').hide();", 200);
					var numInstitut = $('#institutFondID').val();
					esTab=true;
					if(numLinea != '' && !isNaN(numLinea) && esTab){
						if(numLinea=='0'){
							mensajeSis("No existe la linea de Fondeo");
							$('#lineaFondeoID').val("");
							$('#lineaFondeoID').focus();
							$('#descripLinea').val("");
							deshabilitaBoton('pagar','submit');
							}else {
							var lineaFondBeanCon = { 
									'lineaFondeoID':$('#lineaFondeoID').val()
							};
							lineaFonServicio.consulta(3,lineaFondBeanCon,function(lineaFond) {
								if(lineaFond!=null){
									var lineafondeo = lineaFond.institutFondID;
									if(lineafondeo==numInstitut){ 
										$('#descripLinea').val(lineaFond.descripLinea);
										$('#institucionID').val(lineaFond.institucionID);
										$('#numCtaInstit').val(lineaFond.numCtaInstit);
										$('#cuentaClabe').val(lineaFond.cuentaClabe);
										consultaInstitucionCredito('institucionID');
										ocultarBotonPoliza();
									}else{
										mensajeSis("La linea de Fondeo no Corresponde con la Institución");
										$('#lineaFondeoID').val("");
				   						$('#lineaFondeoID').focus();
				   						$('#descripLinea').val("");
				   						$('#gridAmortiCredFonMovs').hide();
										ocultarBotonPoliza();
									}
								}else{
									mensajeSis("No Existe la Linea Fondeador");
			   						$('#lineaFondeoID').val("");
			   						$('#lineaFondeoID').focus();
			   						$('#descripLinea').val("");
			   						$('#gridAmortiCredFonMovs').hide();
								}
							});
						}
					}
				}
				
				function validaCreditoFondeo(){
					var numCredito = $('#creditoFondeoID').val();
					var numInstitut = $('#institutFondID').val();
					var numLinea = $('#lineaFondeoID').val();
					var ajuste = 3;
					setTimeout("$('#cajaLista').hide();", 200);
					esTab=true;
					if(numCredito != '' && !isNaN(numCredito) && esTab){
						if(numCredito=='0'){
							mensajeSis("No existe el Crédito Pasivo");
							$('#creditoFondeoID').focus();
							$('#creditoFondeoID').val("");
							inicializarCampos();
							$('#pagaIVA').val("");
							$('#cobraISR').val("");
							$('#monedaID').val("");
							$('#monedaDes').val("");
							$('#estatus').val("");
							$('#montoPagar').val("");
	
							}else {
							var creditoFondBeanCon = { 
									'creditoFondeoID':numCredito
							};
							creditoFondeoServicio.consulta(ajuste,creditoFondBeanCon,function(creditoFond) {
								if(creditoFond!=null){
									var lineaFon = creditoFond.lineaFondeoID;
									var institfon = creditoFond.institutFondID;
									if(lineaFon==numLinea && numInstitut == institfon){
										$('#monedaID').val(creditoFond.monedaID);
					   					consultaMoneda('monedaID');
					   					divisaCon(creditoFond.monedaID);
										if(creditoFond.pagaIva == "S"){
											$('#pagaIVA').val('SI');
																}
										else if(creditoFond.pagaIva == "N"){
											$('#pagaIVA').val('NO');
										}
										if(creditoFond.cobraISR == "S"){
											$('#cobraISR').val('SI');
																}
										else if(creditoFond.cobraISR == "N"){
											$('#cobraISR').val('NO');
										}
										var estatus = creditoFond.estatus;
										if(estatus == "N"){
											$('#estatus').val('VIGENTE');
											habilitaBoton('pagar', 'submit');
										}else if(estatus == "P"){
											$('#estatus').val('PAGADO');
											deshabilitaBoton('pagar', 'submit');
										}else{
											habilitaBoton('pagar', 'submit');
										}
										consultaExigible();
										consultaSaldoExigible();
										$('#exigible').attr('checked',true);
										$('#prepagoCredito').attr('checked',false);
										$('#totalAde').attr('checked',false);
									}else{
										mensajeSis("El Crédito no Corresponde con la Institución y la Linea de Fondeo");
										$('#creditoFondeoID').focus();
										$('#creditoFondeoID').val("");
										inicializarCampos();
										$('#pagaIVA').val("");
										$('#cobraISR').val("");
										$('#monedaID').val("");
										$('#monedaDes').val("");
										$('#estatus').val("");
										$('#montoPagar').val("");
										$('#gridAmortiCredFonMovs').hide();
									}
									if(botonClicModificar != "0" ){
										ocultarBotonPoliza();
									}
									
								}else{
									mensajeSis("No Existe el Crédito de Fondeo");
									$('#creditoFondeoID').focus();
									$('#creditoFondeoID').val("");
									inicializarCampos();
									$('#pagaIVA').val("");
									$('#cobraISR').val("");
									$('#monedaID').val("");
									$('#monedaDes').val("");
									$('#estatus').val("");
									$('#montoPagar').val("");
									$('#gridAmortiCredFonMovs').hide();
								}
							});
						}
					}
				}
			
				function consultaExigible(){
					var numCredito = $('#creditoFondeoID').val();
					setTimeout("$('#cajaLista').hide();", 200);
					if(numCredito != '' && !isNaN(numCredito)){
						var Con_PagoExigible = 4;
						var creditoBeanCon = { 
							'creditoFondeoID':$('#creditoFondeoID').val()
			  			};
						creditoFondeoServicio.consulta(Con_PagoExigible,creditoBeanCon,function(creditoFond) {
			  				if(creditoFond!=null){ 
								$('#pagoExigible').val(creditoFond.pagoExigible);
								
								$('#montoPagar').val(creditoFond.pagoExigible);
								$('#saldoCapVigent').val(creditoFond.saldoCapVigente);
								$('#saldoCapAtrasad').val(creditoFond.saldoCapAtrasad);
								$('#totalCapital').val(creditoFond.totalCapital);
								$('#saldoInterOrdin').val(creditoFond.saldoInteres);
								$('#saldoInterAtras').val(creditoFond.saldoInteresAtra);
								$('#saldoInterProvi').val(creditoFond.provisionAcum);
								$('#totalInteres').val(creditoFond.totalInteres);
								
								$('#saldoIVAInteres').val(creditoFond.saldoIVAInteres);
								$('#saldoMoratorios').val(creditoFond.saldoMoratorio);
								$('#saldoIVAMorator').val(creditoFond.saldoIVAMora);
								
								$('#saldoComFaltPago').val(creditoFond.saldoComFaltPag);
								$('#saldoOtrasComis').val(creditoFond.saldoOtrasComis);
								$('#totalComisi').val(creditoFond.totalComisi);
								$('#salIVAComFalPag').val(creditoFond.saldoIVAComFal);
								$('#saldoIVAComisi').val(creditoFond.saldoIVAComisi);
								$('#totalIVACom').val(creditoFond.totalIVACom);
								$('#saldoRetencion').val(creditoFond.saldoRetencion);
								
								consultaSaldoAdeudo();
								agregaFormatoControles('formaGenerica');
			  				}else{
			  					deshabilitaBoton('pagar', 'submit');
			  					$('#montoTotExigible').val("0.00");
			  					$('#pagoExigible').val("0.00");
			  					$('#saldoCapVigent').val("0.00");
			  					$('#saldoCapAtrasad').val("0.00");
			  					$('#saldoCapVencido').val("0.00");
			  					$('#saldCapVenNoExi').val("0.00");
			  					$('#totalCapital').val("0.00");
			  					$('#saldoInterOrdin').val("0.00");
			  					$('#saldoInterAtras').val("0.00");
			  					$('#saldoInterVenc').val("0.00");
			  					$('#saldoInterProvi').val("0.00");
			  					$('#saldoIntNoConta').val("0.00");
			  					$('#totalInteres').val("0.00");
			  					$('#saldoIVAInteres').val("0.00");
			  					$('#saldoMoratorios').val("0.00");
			  					$('#saldoIVAMorator').val("0.00");
			  					$('#saldoComFaltPago').val("0.00");
			  					$('#saldoOtrasComis').val("0.00");
			  					$('#totalComisi').val("0.00");
			  					$('#salIVAComFalPag').val("0.00");
			  					$('#saldoIVAComisi').val("0.00");
			  					$('#totalIVACom').val("0.00");  
								$('#saldoRetencion').val("0.00");						
			  				}
			  			});
					}
				}
				
				function consultaSaldoExigible(){
					var numCredito = $('#creditoFondeoID').val();
					setTimeout("$('#cajaLista').hide();", 200);
					if(numCredito != '' && !isNaN(numCredito)){
						var Con_PagoExigible = 4;
						var creditoBeanCon = { 
							'creditoFondeoID':$('#creditoFondeoID').val()
			  			};
						creditoFondeoServicio.consulta(Con_PagoExigible,creditoBeanCon,function(credito) {
			  				if(credito!=null){ 
								$('#pagoExigible').val(credito.pagoExigible);	
								agregaFormatoControles('formaGenerica');
			  				}else{
			  					deshabilitaBoton('pagar', 'submit');
			  					
			  					if($('#totalAde').is(':checked')){
									var TotalAdeudo=$('#adeudoTotal').asNumber();
									if(TotalAdeudo > 0){
										habilitaBoton('pagar', 'submit');
									}
								}
			  					
			  					$('#montoTotExigible').val("0.00");
			  					$('#pagoExigible').val("0.00");
			  					$('#saldoCapVigent').val("0.00");
			  					$('#saldoCapAtrasad').val("0.00");
			  					$('#saldoCapVencido').val("0.00");
			  					$('#saldCapVenNoExi').val("0.00");
			  					$('#totalCapital').val("0.00"); 
			  					$('#saldoInterOrdin').val("0.00");
			  					$('#saldoInterAtras').val("0.00");
			  					$('#saldoInterVenc').val("0.00");
			  					$('#saldoInterProvi').val("0.00");
			  					$('#saldoIntNoConta').val("0.00");
			  					$('#totalInteres').val("0.00");
			  					$('#saldoIVAInteres').val("0.00");
			  					$('#saldoMoratorios').val("0.00");
			  					$('#saldoIVAMorator').val("0.00");
			  					$('#saldoComFaltPago').val("0.00");
			  					$('#saldoOtrasComis').val("0.00");
			  					$('#totalComisi').val("0.00");
			  					$('#salIVAComFalPag').val("0.00");
			  					$('#saldoIVAComisi').val("0.00");
			  					$('#totalIVACom').val("0.00");  	
								$('#saldoRetencion').val("0.00");				
			  				}
			  			});
					}
				}

				function consultaMontoPrepago(){
					var numCredito = $('#creditoFondeoID').val();
					setTimeout("$('#cajaLista').hide();", 200);
					if(numCredito != '' && !isNaN(numCredito)){
						var ConsultaPrepago = 6;
						var creditoBeanCon = { 
							'creditoFondeoID':$('#creditoFondeoID').val()
			  			};
						creditoFondeoServicio.consulta(ConsultaPrepago,creditoBeanCon,function(creditoFond) {
			  				if(creditoFond!=null){ 
								$('#adeudoTotal').val(creditoFond.pagoExigible);
								
								$('#montoPagar').val('0.00');
								$('#saldoCapVigent').val(creditoFond.saldoCapVigente);
								$('#saldoCapAtrasad').val(creditoFond.saldoCapAtrasad);
								$('#totalCapital').val(creditoFond.totalCapital);
								$('#saldoInterOrdin').val(creditoFond.saldoInteres);
								$('#saldoInterAtras').val(creditoFond.saldoInteresAtra);
								$('#saldoInterProvi').val(creditoFond.provisionAcum);
								$('#totalInteres').val(creditoFond.totalInteres);
								
								$('#saldoIVAInteres').val(creditoFond.saldoIVAInteres);
								$('#saldoMoratorios').val(creditoFond.saldoMoratorio);
								$('#saldoIVAMorator').val(creditoFond.saldoIVAMora);
								
								$('#saldoComFaltPago').val(creditoFond.saldoComFaltPag);
								$('#saldoOtrasComis').val(creditoFond.saldoOtrasComis);
								$('#totalComisi').val(creditoFond.totalComisi);
								$('#salIVAComFalPag').val(creditoFond.saldoIVAComFal);
								$('#saldoIVAComisi').val(creditoFond.saldoIVAComisi);
								$('#totalIVACom').val(creditoFond.totalIVACom);
								$('#saldoRetencion').val(creditoFond.saldoRetencion);

								$('#pagoExigible').val('0.00');
								habilitaBoton('pagar', 'submit');
								if(creditoFond.existeAtraso == 'S'){
									mensajeSis('Primero Pague el Exigible Antes de Realizar un Prepago.');
									$('#exigible').click();
								}
								
								agregaFormatoControles('formaGenerica');
			  				}else{
			  					deshabilitaBoton('pagar', 'submit');
			  					$('#montoTotExigible').val("0.00");
			  					$('#pagoExigible').val("0.00");
			  					$('#saldoCapVigent').val("0.00");
			  					$('#saldoCapAtrasad').val("0.00");
			  					$('#saldoCapVencido').val("0.00");
			  					$('#saldCapVenNoExi').val("0.00");
			  					$('#totalCapital').val("0.00");
			  					$('#saldoInterOrdin').val("0.00");
			  					$('#saldoInterAtras').val("0.00");
			  					$('#saldoInterVenc').val("0.00");
			  					$('#saldoInterProvi').val("0.00");
			  					$('#saldoIntNoConta').val("0.00");
			  					$('#totalInteres').val("0.00");
			  					$('#saldoIVAInteres').val("0.00");
			  					$('#saldoMoratorios').val("0.00");
			  					$('#saldoIVAMorator').val("0.00");
			  					$('#saldoComFaltPago').val("0.00");
			  					$('#saldoOtrasComis').val("0.00");
			  					$('#totalComisi').val("0.00");
			  					$('#salIVAComFalPag').val("0.00");
			  					$('#saldoIVAComisi').val("0.00");
			  					$('#totalIVACom').val("0.00");  
								$('#saldoRetencion').val("0.00");						
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
								$('#gridAmortiCredFonMovs').hide();
							}
						});
					}
				}
				
				//Funcion de consulta para obtener el nombre de la institucion	
				function consultaInstitucion(idControl) {
					var jqInstituto = eval("'#" + idControl + "'");
					var numInstituto = $(jqInstituto).val();
					setTimeout("$('#cajaLista').hide();", 200);	
					var InstitutoBeanCon = {
						'institucionID':numInstituto
					};
					if(numInstituto != '' && !isNaN(numInstituto)){
						institucionesServicio.consultaInstitucion(2,InstitutoBeanCon,function(instituto){		
							if(instituto!=null){							
								$('#descripcionInstitucion').val(instituto.nombre);
								$('#numCtaInstit').val("");
								$('#cuentaClabe').val("");
							}else{
								mensajeSis("No existe la Institución"); 
								$('#institucionID').val('');	
								$('#institucionID').focus();	
								$('#descripcionInstitucion').val("");
								$('#numCtaInstit').val("");
								$('#cuentaClabe').val("");					
							}    						
						});
					}
				}
				
				//Funcion de consulta para obtener el nombre de la institucion	
				function consultaInstitucionCredito(idControl) {
					var jqInstituto = eval("'#" + idControl + "'");
					var numInstituto = $(jqInstituto).val();
					setTimeout("$('#cajaLista').hide();", 200);	
					var InstitutoBeanCon = {
						'institucionID':numInstituto
					};
					if(numInstituto != '' && !isNaN(numInstituto)){
						institucionesServicio.consultaInstitucion(2,InstitutoBeanCon,function(instituto){		
							if(instituto!=null){							
								$('#descripcionInstitucion').val(instituto.nombre);
							}else{
								mensajeSis("No existe la Institución"); 
								$('#institucionID').val('');	
								$('#institucionID').focus();	
								$('#descripcionInstitucion').val("");
								$('#numCtaInstit').val("");
								$('#cuentaClabe').val("");					
							}    						
						});
					}
				}
				
				function validaCtaNostroExiste(numCta,institID){
			  		var jqNumCtaInstit = eval("'#" + numCta + "'");
			  		var jqInstitucionID = eval("'#" + institID + "'");
			  		var numCtaInstit = $(jqNumCtaInstit).val();
			  		var institucionID = $(jqInstitucionID).val();
			  		var CtaNostroBeanCon = {
			  				'institucionID':institucionID,
			  				'numCtaInstit':numCtaInstit
			  		};
					setTimeout("$('#cajaLista').hide();", 200);
					if(numCtaInstit != '' && !isNaN(numCtaInstit) && institucionID != '' && !isNaN(institucionID) ){
						cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.resumen,CtaNostroBeanCon, function(ctaNostro){
							if(ctaNostro!=null){
								if(ctaNostro.estatus =='A'){
									$('#cuentaClabe').val(ctaNostro.cuentaClabe);
								}else{
				  					mensajeSis("El Número de Cuenta Bancaria esta Inactiva.");
									$('#numCtaInstit').focus();
								}
			  				}else{
			  					mensajeSis("El Número de Cuenta Bancaria no existe.");
								$('#numCtaInstit').focus();
								$('#cuentaClabe').val("");
			  				}
			  			});
			  		}
			  	}
				
			
				function consultaTotalAdeudo(){
					var numCredito = $('#creditoFondeoID').val();
					var numInstitut = $('#institutFondID').val();
					var numLinea = $('#lineaFondeoID').val();
					var ajuste = 3;
					setTimeout("$('#cajaLista').hide();", 200);
					esTab=true;
					if(numCredito != '' && !isNaN(numCredito) && esTab){
						if(numCredito=='0'){
							mensajeSis("No existe el Crédito Pasivo");
							$('#creditoFondeoID').focus();
							$('#creditoFondeoID').val("");
							inicializarCampos();
							}else {
							var creditoFondBeanCon = { 
									'creditoFondeoID':numCredito
							};
							creditoFondeoServicio.consulta(ajuste,creditoFondBeanCon,{ async: false, callback:function(creditoFond) {
								if(creditoFond!=null){
									var lineaFon = creditoFond.lineaFondeoID;
									var institfon = creditoFond.institutFondID;
									if(lineaFon==numLinea && numInstitut == institfon){
										$('#saldoCapVigent').val(creditoFond.saldoCapVigente);
										$('#saldoCapAtrasad').val(creditoFond.saldoCapAtrasad);
										$('#totalCapital').val(creditoFond.totalCapital);
										$('#saldoInterOrdin').val(creditoFond.saldoInteres);
										$('#saldoInterAtras').val(creditoFond.saldoInteresAtra);
										$('#saldoInterProvi').val(creditoFond.provisionAcum);
										$('#totalInteres').val(creditoFond.totalInteres);
										
										$('#saldoIVAInteres').val(creditoFond.saldoIVAInteres);
										$('#saldoMoratorios').val(creditoFond.saldoMoratorio);
										$('#saldoIVAMorator').val(creditoFond.saldoIVAMora);
										
										$('#saldoComFaltPago').val(creditoFond.saldoComFaltPag);
										$('#saldoOtrasComis').val(creditoFond.saldoOtrasComis);
										$('#totalComisi').val(creditoFond.totalComisi);
										$('#salIVAComFalPag').val(creditoFond.saldoIVAComFal);
										$('#saldoIVAComisi').val(creditoFond.saldoIVAComisi);
										$('#totalIVACom').val(creditoFond.totalIVACom);
										$('#adeudoTotal').val(creditoFond.adeudoTotal);
										$('#saldoRetencion').val(creditoFond.saldoRetencion);
										consultaSaldoExigible();
									}else{
										mensajeSis("El Crédito no Corresponde con la Institución y la Linea de Fondeo");
										$('#creditoFondeoID').focus();
										$('#creditoFondeoID').val("");
										inicializarCampos();
										$('#gridAmortiCredFonMovs').hide();
									}
								}else{
									mensajeSis("No Existe el Crédito de Fondeo");
									$('#creditoFondeoID').focus();
									$('#creditoFondeoID').val("");
									inicializarCampos();
									$('#gridAmortiCredFonMovs').hide();
								}
								}
							});
						}
					}
				}
				
				function consultaSaldoAdeudo(){
					var numCredito = $('#creditoFondeoID').val();
					var numInstitut = $('#institutFondID').val();
					var numLinea = $('#lineaFondeoID').val();
					var ajuste = 3;
					setTimeout("$('#cajaLista').hide();", 200);
					esTab=true;
					if(numCredito != '' && !isNaN(numCredito) && esTab){
						if(numCredito=='0'){
							mensajeSis("No existe el Crédito Pasivo");
							$('#creditoFondeoID').focus();
							$('#creditoFondeoID').val("");
							inicializarCampos();
							}else {
							var creditoFondBeanCon = { 
									'creditoFondeoID':numCredito
							};
							creditoFondeoServicio.consulta(ajuste,creditoFondBeanCon,function(creditoFond) {
								if(creditoFond!=null){
									var lineaFon = creditoFond.lineaFondeoID;
									var institfon = creditoFond.institutFondID;
									if(lineaFon==numLinea && numInstitut == institfon){
										$('#adeudoTotal').val(creditoFond.adeudoTotal);
									}else{
										mensajeSis("El Crédito no Corresponde con la Institución y la Linea de Fondeo");
										$('#creditoFondeoID').focus();
										$('#creditoFondeoID').val("");
										inicializarCampos();
										$('#gridAmortiCredFonMovs').hide();
									}
								}else{
									mensajeSis("No Existe el Crédito de Fondeo");
									$('#creditoFondeoID').focus();
									$('#creditoFondeoID').val("");
									inicializarCampos();
									$('#gridAmortiCredFonMovs').hide();
								}
							});
						}
					}
				}
				
				/* funcion para consultar las amortizaciones del credito pasivo */
				function consultaGridAmortizaciones(){
					var params = {};
					params['creditoFondeoID'] = $('#creditoFondeoID').val();
					params['tipoLista'] = 1;
					$('#gridAmortiCredFonMovs').html("");
					$.post("amortizaGridMovimiento.htm", params, function(data){		
							if(data.length >0) {
								$('#gridAmortiCredFonMovs').html(data);
								$('#gridAmortiCredFonMovs').show();
								agregaFormatoControles('gridAmortiCredFonMovs');
							}else{
								$('#gridAmortiCredFonMovs').html("");
								$('#gridAmortiCredFonMovs').hide();
							}
					});
					agregaFormatoControles('formaGenerica');
				}
				
				/* funcion para consultar los movimientos del credito pasivo */
				function consultaGridMovimientos(){
					var params = {};
					params['creditoFondeoID'] = $('#creditoFondeoID').val();
					params['tipoLista'] = 1;
					$('#gridAmortiCredFonMovs').html("");
					$.post("movimientosCreditoFondeoGrid.htm", params, function(data){		
							if(data.length >0) {
								$('#gridAmortiCredFonMovs').html(data);
								$('#gridAmortiCredFonMovs').show();
								$('#exportarExcel').show();
								agregaFormatoControles('gridAmortiCredFonMovs');
							}else{
								$('#gridAmortiCredFonMovs').html("");
								$('#gridAmortiCredFonMovs').hide();
							}
					});
					agregaFormatoControles('formaGenerica');
				}	
				
				function validaCreditoPasivo(controlID){ 
					var jqCreditoID = eval("'#" + controlID + "'");
					var varCreditoPasivo = $(jqCreditoID).val();
					setTimeout("$('#cajaLista').hide();", 200);
					if(varCreditoPasivo != '' && !isNaN(varCreditoPasivo)){
							var creditoBeanCon = {
									'creditoFondeoID':varCreditoPasivo
							};
				  			creditoFondeoServicio.consulta(catTipoConsultaCreditoFondeo.principal, creditoBeanCon,{ async: false, callback: function(creditoPasivo) {
								if(creditoPasivo!=null){
									//inicializarCampos();
									$('#pagosParciales').val(creditoPasivo.pagosParciales);
									if(creditoPasivo.pagosParciales=='N'){
										if($('#finiquito').val()=='N'){
											$('#montoPagar').val($('#pagoExigible').val());
											deshabilitaControl('montoPagar');
											deshabilitaControl('pagosParciales');
											$('#montoPagar').focus();
										}else{
											$('#montoPagar').val($('#totalAdeudo').val());
											deshabilitaControl('montoPagar');
											deshabilitaControl('pagosParciales');
										}
									}else{
										if($('#finiquito').val()=='N'){
											habilitaControl('montoPagar');
											$('#montoPagar').val('');
											deshabilitaControl('pagosParciales');
											$('#montoPagar').focus();
										}else{
											$('#montoPagar').val($('#totalAdeudo').val());
											deshabilitaControl('montoPagar');
											deshabilitaControl('pagosParciales');
										}
									}
								}else{
									mensajeSis("No Existe el Crédito Pasivo");
								}
							}});
						}
					}
				
				function consultaCredito(){ 
					var numCredito = $('#creditoID').val();
					setTimeout("$('#cajaLista').hide();", 200);
					if(numCredito != '' && !isNaN(numCredito)){
						var creditoBeanCon = { 
								'creditoID':$('#creditoID').val()
						};
						   creditosServicio.consulta(29,creditoBeanCon,function(credito) {
							if(credito!=null){
								if(credito.esAgropecuario == "S"){
									esTab=true;	
									$('#creditoID').val(credito.creditoID); 
									$('#clienteID').val(credito.clienteID); 
									consultaCliente('clienteID');			
							
									
								} else {
									mensajeSis('El Crédito NO Es Agropecuario.');
									$('#creditoID').focus();
									$('#creditoID').select();
									$('#creditoID').val("");
								}
							}else{
								mensajeSis("No Existe el Credito");
								$('#creditoID').focus();
								$('#creditoID').select();
								$('#creditoID').val("");
							}
						});
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
							}else{
								mensajeSis("No Existe el Cliente.");
								$('#clienteID').focus();
								$('#clienteID').select();	
							}    	 						
						}});
					}
				}

				//Funcion de consulta para obtener el nombre de la institucion	
				function consultaRelacion(idControl) {
					var jqcreditoFondeoID = eval("'#" + idControl + "'");
					var numCredito = $(jqcreditoFondeoID).val();
					$('#creditoID').val("");
					$('#clienteID').val("");
					$('#nombreCliente').val("");
					setTimeout("$('#cajaLista').hide();", 200);	
					var creditoBeanCon = {
						'creditoFondeoID':numCredito
					};
					if(numCredito != '' && !isNaN(numCredito)){
						creditoFondeoServicio.consulta(7, creditoBeanCon,{ async: false, callback: function(creditoPasivo) {
							if(creditoPasivo!=null){						
								$('#creditoActivo').show();
							}else{
								$('#creditoActivo').hide();			
							}    						
						}});
					}
				}
				

			
				
					function limpiaCajas(){
						$('#montoPagar').val("");
						$('#monedaID').val("");
						$('#monedaDes').val("");
						$('#cobraISR').val("");
						$('#pagaIVA').val("");
						$('#cuentaClabe').val("");
						$('#creditoFondeoID').val("");
						$('#numCtaInstit').val("");
						$('#institucionID').val("");
						$('#descripcionInstitucion').val("");
						$('#descripLinea').val("");
						$('#estatus').val("");
						deshabilitaBoton('pagar','submit');
						inicializaForma('formagenerica');
						inicializarCampos();
						$('#gridAmortiCredFonMovs').html("");
						$('#gridAmortiCredFonMovs').hide();
						$('#gridAmortiCredFonMovs').html("");
						$('#gridAmortiCredFonMovs').hide();
					}
					
					$('#exportarExcel').click(function() {
						generaMovsExcel();
					});
			});
			
			function divisaCon(divisaId) {
				if (divisaId > 1) {
					$('#tiposDivisa').show();
					var divisaBean = {
						'monedaId' : divisaId
					};
					divisasServicio.consultaExisteDivisa(3, divisaBean, function(divisa) {
						if (divisa != null) {
							$('#tipCamFixCom').val(divisa.tipCamFixCom);
							$('#tipCamFixVen').val(divisa.tipCamFixVen);
							$('#tipCambioDof').val(divisa.tipCamDof);
						} else {
							mensajeSis("No Existe la Divisa.");
						}
					});
				}
			}
			
			var numeroPoliza;
			var botonClicModificar = 0;
			
			function inicializarCampos() {
				agregaFormatoControles('formaGenerica');
				$('#adeudoTotal').val("0.00");
				$('#montoTotDeuda').val("0.00");
				$('#montoTotExigible').val("0.00");
				$('#pagoExigible').val("0.00");
				$('#saldoCapVigent').val("0.00");
				$('#saldoCapAtrasad').val("0.00");
				$('#totalCapital').val("0.00");
				$('#saldoInterOrdin').val("0.00");
				$('#saldoInterAtras').val("0.00");
				$('#totalInteres').val("0.00");
				$('#saldoIVAInteres').val("0.00");
				$('#saldoMoratorios').val("0.00");
				$('#saldoIVAMorator').val("0.00");
				$('#saldoComFaltPago').val("0.00");
				$('#saldoOtrasComis').val("0.00");
				$('#totalComisi').val("0.00");
				$('#salIVAComFalPag').val("0.00");
				$('#saldoIVAComisi').val("0.00");
				$('#saldoRetencion').val("0.00");
				$('#totalIVACom').val("0.00");
				
				$('#totalAde').attr('checked',false);			
				$('#exigible').attr('checked',true);
				$('#prepagoCredito').attr('checked',false);	
				$('#divTipoPrepago').hide(); 
				$('#divTipoPrepago1').hide(); 
				$('#finiquito').val('N');
				deshabilitaControl('tipoPrepago');
				deshabilitaBoton('pagar', 'submit');
				ocultarBotonPoliza();
			}
			
			function funcionExitoPagoCrePasivo(){
				if(botonClicModificar == "0" ){
					numeroPoliza = $('#campoGenerico').val(); // se obtiene el numero de poliza generado en el proceso
					if(numeroPoliza>0){
						$('#impPoliza').show();
						$('#enlace').attr('href');
						habilitaBoton('impPoliza', 'submit');
					}
				}else{
					if(botonClicModificar == "1" ){
						ocultarBotonPoliza();
					}
				}
			
				$('#gridAmortiCredFonMovs').html("");
				$('#gridAmortiCredFonMovs').hide();
				$('#montoPagar').val("");
				$('#creditoID').val("");
				$('#creditoID').focus();
				$('#clienteID').val("");
				$('#nombreCliente').val("");

				
			}
			
			function funcionFalloPagoCrePasivo(){
				ocultarBotonPoliza();
			}
			
			
			//funcion para ocultar poliza
			function ocultarBotonPoliza(){
				botonClicModificar = "1";
				$('#impPoliza').hide();
				$('#enlace').removeAttr('href');
				deshabilitaBoton('impPoliza', 'submit');
				numeroPoliza = 0;
			}

			function cargaValorListaFondeo(control, valor, transaccion) {
				consultaSesion();
				jqControl = eval("'#" + control + "'");
				$(jqControl).val(valor);
				$(jqControl).focus();

				$('#folioPagoActivo').val(transaccion);

				setTimeout("$('#cajaLista').hide();", 200);
			}
			
			function roundToTwo(num) {    
			    return +(Math.round(num + "e+2")  + "e-2");
			}
			
			function generaMovsExcel() {
				var tr= catTipoReport.reporteExcel; 
				
				nombreInstitucionFon = $('#nombreInstitFondeo').val();
				creditoFondeoID = $('#creditoFondeoID').val();
				
				var pagina = 'carCreditoFondeMovsReporte.htm?tipoReporte='+tr+'&tipoLista='+
								3+'&institucionFon='+nombreInstitucionFon+'&creditoFondeoID='+creditoFondeoID;
			    $('#ligaGenerar').attr('href',pagina);
			    window.open(pagina,'_blank');
			}
			function formatoMoneda(numero){
				numero = Number(numero);
				return (numero.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
			}