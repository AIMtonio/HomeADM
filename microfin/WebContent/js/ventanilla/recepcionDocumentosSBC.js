//-----------------Recepcion de Documentos SBCCC ---------------
	$('#numeroCuentaRec').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "clienteID";
			camposLista[1] = "nombreCompleto";
			parametrosLista[0] = 0;
			parametrosLista[1] = $('#numeroCuentaRec').val();
				
			listaAlfanumerica('numeroCuentaRec', '2', '13', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}				       
	});	
	$('#bancoEmisorSBC').bind('keyup',function(e){	
		var institucionID = $('#bancoEmisorSBC').val();
		lista('bancoEmisorSBC', '1','1', 'nombre', institucionID, 'listaInstituciones.htm');
	});
	
	$('#bancoEmisorSBC').blur(function() {
		consultaInstitucion(this.id,'nombreBancoEmisorSBC');
	});	
	
	
	$('#numeroCuentaEmisorSBC').bind('keyup',function(e){
		if( $('#tipoCtaCheque').val() == Var_ChequeInterno ){
	       	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "numCtaInstit";
			camposLista[1] = "institucionID";
			parametrosLista[0] = $('#numeroCuentaEmisorSBC').val();
			parametrosLista[1] = $('#bancoEmisorSBC').val();
			listaAlfanumerica('numeroCuentaEmisorSBC', '2', '7', camposLista,parametrosLista, 'ctaNostroLista.htm');
		}
	});	
	
	$('#numeroCuentaEmisorSBC').blur(function() {
		if($('#tipoCtaCheque').val() == Var_ChequeInterno){
			if($('#numeroCuentaEmisorSBC').val() != '' ){
				cargaTipoChequera();	
				$('#tipoChequeraRecep').focus();
				
			} 
			
		}
		
		

	});
	
 	function cargaTipoChequera(){
		tipoChequeraBean = {
				'institucionID': $('#bancoEmisorSBC').val(),
				'numCtaInstit': $('#numeroCuentaEmisorSBC').val()
				};
		
			cuentaNostroServicio.listaCombo(15,tipoChequeraBean,function(tiposChe){
				if(tiposChe!=''){
					dwr.util.removeAllOptions('tipoChequeraRecep'); 
  			  		dwr.util.addOptions('tipoChequeraRecep', {'':'SELECCIONAR'});
  			  		dwr.util.addOptions('tipoChequeraRecep', tiposChe, 'tipoChequera', 'descripTipoChe');  
				}
			});	
		}
	
 	
	$('#tipoChequeraRecep').blur(function(){
		$('#numeroChequeSBC').focus();

	});
	
	$('#numeroChequeSBC').blur(function() {
		
		if($('#tipoCtaCheque').val() == Var_ChequeInterno){
			consultaDatosCheque(this.id);
		}

	});
	

	$('#tipoCtaCheque').change(function(){
		if($('#tipoCtaCheque').val() == 'I'){// INTERNA
			$('#idTrFormaCobro').show();
			$('#idTrtipoChequeraRecep').show();
			$('#idCuentaAhoCte').show();			
			$('#idDivCheque').show();			
			inicializaCamposRecepcion();
			soloLecturaDatosChequesInternos();
			$('#formaCobro1').attr('checked',true);
			$('#formaCobro2').attr('checked',false);
			$('#pagoServicioCheque').attr('checked',false);
			$('#lblBeneficiario').show();
			$('#inputBeneficiario').show();
			$('#lblTitularCta').hide();
			$('#inputTitularCta').hide();
		}else{								// EXTERNA
			$('#idTrFormaCobro').hide();
			$('#idTrtipoChequeraRecep').hide();
			$('#idCuentaAhoCte').show();
			$('#idDivCheque').show();
			inicializaCamposRecepcion();
			habilitaDatosChequesInternos();
			$('#lblBeneficiario').hide();
			$('#inputBeneficiario').hide();
			$('#lblTitularCta').show();
			$('#inputTitularCta').show();
			$('#entradaSalida').hide();
			$('#totales').hide();	
			$('#formaPagoOpera2').attr('checked',false);
			$('#formaPagoOpera1').attr('checked',true);
			$('#pagoServicioCheque').attr('checked',false);
		}		
	});
	$('#formaCobro1').click(function() { //DEPOSITO A CTA 
			$('#idCuentaAhoCte').show();
			$('#idDivCheque').show();			
			soloLecturaEntradasSalidasEfectivo();
			$('#formaCobro1').focus();
			limpiaCamposDepositoCta();
			limpiacamposCheque();
			totalEntradasSalidasGrid();
			inicializaCantidadEntradaSalida();
			$('#entradaSalida').hide();
			$('#totales').hide();		
			$('#formaPagoOpera2').attr('checked',false);
			$('#formaPagoOpera1').attr('checked',true);
			$('#pagoServicioCheque').attr('checked',false);

	});
	$('#formaCobro2').click(function() { // EFECTIVO 		
			$('#idCuentaAhoCte').hide();
			$('#idDivCheque').show();
			habilitaEntradasSalidasEfectivo(); 
			$('#formaCobro2').focus();
			limpiaCamposDepositoCta();
			limpiacamposCheque();
			totalEntradasSalidasGrid();
			inicializaCantidadEntradaSalida();
			$('#entradaSalida').show();
			$('#totales').show();
	});		

	
	//Consulta Datos de un Cheque Interno
	function consultaDatosCheque(idControl){  
		var jqCheque = eval("'#" + idControl + "'");
		var numCheque = $(jqCheque).val();
		var conChequeEmitidos = 1;		
	
		
		var chequesEmitidosBean = {
				'institucionID'	:$('#bancoEmisorSBC').val(),
				'cuentaInstitucion':$('#numeroCuentaEmisorSBC').val(),
				'tipoChequera': $('#tipoChequeraRecep').val(),
				'numeroCheque':numCheque,
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCheque != '' && !isNaN(numCheque) && numCheque >0){		
			chequesEmitidosServicio.consulta(conChequeEmitidos,chequesEmitidosBean,function(cheque) {
				if(cheque != null){	
					$('#beneficiarioSBC').val(cheque.beneficiario);
					$('#montoSBC').val(cheque.monto);
					if(cheque.estatus == 'P'){
						mensajeSis("El Cheque ya fue Pagado");
						$('#numeroChequeSBC').focus();
						$('#beneficiarioSBC').val('');
						$('#montoSBC').val('');
					}else if(cheque.estatus == 'C'){
						mensajeSis("El Cheque ya fue Cancelado");
						$('#numeroChequeSBC').focus();
						$('#beneficiarioSBC').val('');
						$('#montoSBC').val('');
					}else if(cheque.estatus == 'R'){
						mensajeSis("El Cheque ya fue Reemplazado");
						$('#numeroChequeSBC').focus();
						$('#beneficiarioSBC').val('');
						$('#montoSBC').val('');
					}else if(cheque.estatus == 'O'){
						mensajeSis("El Cheque ya fue Conciliado");
						$('#numeroChequeSBC').focus();
						$('#beneficiarioSBC').val('');
						$('#montoSBC').val('');
					}else{
						totalEntradasSalidasGrid();
						if($('#formaCobro2').attr('checked') == true ){
							$('#cantSalMil').focus();
						}
						if($('#formaCobro1').attr('checked') == true ){
							$('#graba').focus();
						}
						
					}
					
				}else{
					mensajeSis("El Cheque no Existe");
					$('#numeroChequeSBC').val('');
					$('#beneficiarioSBC').val('');
					$('#montoSBC').val('');					
					$(jqCheque).focus();
				}
			});
		}else{			
			$('#numeroChequeSBC').val('');
			$('#beneficiarioSBC').val('');
			$('#montoSBC').val('');					
		
		}
	}
	
	//---------- Recepcion de cheque SBC	y Aplicacion de Cheque SBC	
	function consultaCtaAhoChequeSBC(idControl,desccuenta,clienteID,saldoDisponibleSBC,saldoBloqueadoSBC,nombreClie) {
		var numCta = eval("'#" + idControl + "'");	
		var descCta= eval("'#" + desccuenta + "'");	
		var cliente= eval("'#" + clienteID + "'");	
		var valorCta=$(numCta).val();
		var ctaActiva='A';
		var tipConCampos= 4;
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:valorCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(valorCta != '' && !isNaN(valorCta) && esTab){
		
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){
							$(descCta).val(cuenta.descripcionTipoCta);
							$(cliente).val(cuenta.clienteID);
							var clienteNum = $(cliente).asNumber();
							if(clienteNum>0){
								listaPersBloqBean = consultaListaPersBloq(clienteNum, esCliente, valorCta, 0);
								consultaSPL = consultaPermiteOperaSPL(clienteNum,'LPB',esCliente);
								
								if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
									expedienteBean = consultaExpedienteCliente(clienteNum);
									if(expedienteBean.tiempo<=1){
										consultaSaldoCtaSBC(idControl,cuenta.clienteID,saldoDisponibleSBC,saldoBloqueadoSBC);
										consultaClienteCtaSBC(clienteID,nombreClie);
										
										if(cuenta.estatus != ctaActiva){
											mensajeSis("La Cuenta no se encuentra activa");
											soloLecturaEntradasSalidasEfectivo();
											$(numCta).focus();									
										}else{						
											if(idControl == 'numeroCuentaSBC'){//Aplicacion de cheque SBC  
												$('#clientechequeSBCAplic').focus();
												habilitaEntradasSalidasEfectivo();
											}
										}
									} else {
										mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar.');
										$(numCta).focus();
										$(descCta).val('');
										$(cliente).val('');
									}
								} else {
									mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
									$(numCta).focus();
									$(descCta).val('');
									$(cliente).val('');
								}
							}
						}else{
							mensajeSis("No Existe la cuenta de ahorro");
							$(numCta).focus();								
							//inicializarCampos();
						}
				});															
		}
	}
	// Consulta Datos generales de la cuenta a la cual se depositara el cheque
	function consultaSaldoCtaSBC(idControl,numCte, saldoDis, saldoSBC) {
		var jqCta  = eval("'#" + idControl + "'");
		var jqSaldoDis=eval("'#" + saldoDis + "'");
		var jqsaldoSBC=eval("'#" + saldoSBC + "'");
		
		var numCta = $(jqCta).val();
		var tipConCampos= 5;
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta,
			'clienteID'		:numCte
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){	
							$(jqSaldoDis).val(cuenta.saldoDispon);								
							$(jqsaldoSBC).val(cuenta.saldoSBC);	
						}else{
							mensajeSis("No Existe la cuenta de ahorro o no corresponde a la persona indicada");
							$(jqCta).focus();
							$(jqCta).select();										
						}
				});															
		}
	}
	// Consultamos el nombre del Cliente que se le depositara
	function consultaClienteCtaSBC(idControl,nombreCliente) {
		var jqCliente  = eval("'#" + idControl + "'");
		var jqnombreCliente = eval("'#" + nombreCliente + "'");
	
		var numCliente = $(jqCliente).val();	
		var conCliente =5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
						if(cliente!=null){		
							$(jqnombreCliente).val(cliente.nombreCompleto);
						}else{
							mensajeSis("No Existe el Cliente");
							$(jqCliente).focus();
						}    						
				});
			}
	}
			
	function consultaInstitucion(idControl,nombreInstitucion) {
		var catTipoConsultaInstituciones = 2;
		var jqInstituto = eval("'#" + idControl + "'");
		var jqNomInstituto=eval("'#" + nombreInstitucion + "'");
		var numInstituto = $(jqInstituto).val();			
		
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
  				'institucionID':numInstituto
		};
		if(numInstituto != '' && !isNaN(numInstituto)){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones,InstitutoBeanCon,function(instituto){
				if(instituto!=null){
					$(jqNomInstituto).val(instituto.nombre);
					$('#numeroCuentaEmisorSBC').focus();
					
				}else{
					mensajeSis("No existe la Institución");
                    $(jqInstituto).val('');
                    $(jqInstituto).focus();
                    $('#nombreBancoEmisorSBC').val("");
				}
			});
		}
	}
	
	function llenaComboTipoCuentaCheque(){
		$('#tipoCtaCheque').find('option').remove().end().append('<option value="">Selecciona </option>'+
				'<option value="I"> Interna-'+nombreCortoInstitucion+'</option>'+
				'<option value="E">Externa-Otros</option>') ;
			$('#tipoCtaCheque option[value="E"]').attr('selected','true');
			$('#idCuentaAhoCte').show();
			$('#idDivCheque').show();				
			$('#idTrFormaCobro').hide();
			$('#idTrtipoChequeraRecep').hide();
			habilitaDatosChequesInternos();
			$('#lblBeneficiario').hide();
			$('#inputBeneficiario').hide();
			$('#lblTitularCta').show();
			$('#inputTitularCta').show();
			
	}
	function inicializaCamposRecepcion(){
		limpiaCamposDepositoCta();
		$('#numeroChequeSBC').val('');
		limpiacamposCheque();
	}
	function limpiaCamposDepositoCta(){
		$('#numeroCuentaRec').val('');
		$('#tipoCuentaSBC').val('');
		$('#clienteIDSBC').val('');
		$('#nombreClienteSBC').val('');
		$('#saldoDisponibleSBC').val('');
		$('#saldoBloqueadoSBC').val('');
	}
	function limpiacamposCheque(){
		$('#bancoEmisorSBC').val('');
		$('#nombreBancoEmisorSBC').val('');
		$('#numeroCuentaEmisorSBC').val('');
		$('#tipoChequeraRecep').val('');
		$('#nombreEmisorSBC').val('');
		$('#montoSBC').val('');
		$('#numeroChequeSBC').val('');
		$('#beneficiarioSBC').val('');		
		
	}
	
	function soloLecturaDatosChequesInternos(){
		soloLecturaControl('nombreEmisorSBC');
		soloLecturaControl('montoSBC');
		
	}
	function habilitaDatosChequesInternos(){
		habilitaControl('nombreEmisorSBC');
		habilitaControl('montoSBC');
	}


	
	