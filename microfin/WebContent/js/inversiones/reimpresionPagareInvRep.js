$(document).ready(function() {
	var esTab = true;
	var parametroBean = consultaParametrosSession();	
	deshabilitaBoton('autoriza', 'submit');
	deshabilitaBoton('imprime', 'submit');		
	agregaFormatoControles('formaGenerica');
		
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	var catTipoConsultaInversion = {
		'principal' : 1
	};	
	var catTipoTransaccion = {
		'autoriza':6
	};
	var catTipoConsultaCuenta = {
			'conSaldo': 5
	};
	var catTipoConsultaCliente = {
		'paraInversiones': 6
	};
	var catTipoConsultaTipoInversion = {
		'principal' : 1
	};
	var catTipoListaInversion = {
		'principal': 1
	};			
	var catStatusInversion = {
		'alta':		'A',
		'vigente': 	'N',
		'pagada': 	'P',
		'cancelada':'C'
	};
	
	$.validator.setDefaults({
		submitHandler: function(event) {
				grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','inversionID');

			}
	});


	
	$('#inversionID').focus();
	$('#fecha').html(parametroBean.fechaSucursal);
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	
	$('#inversionID').blur(function(){
		validaInversion(this.id);		
	});
	
	$('#inversionID').bind('keyup',function(e){
//		if(this.value.length >= 2){
			
			var camposLista = new Array();
			 var parametrosLista = new Array();
			 camposLista[0] = "nombreCliente";
			 camposLista[1] = "estatus";
			 parametrosLista[0] = $('#inversionID').val();			
			 parametrosLista[1] = catStatusInversion.vigente;
			
			lista('inversionID', 1, catTipoListaInversion.principal, camposLista,
					 parametrosLista, 'listaInversiones.htm');
//		}
	});
	
	$('#imprime').click(function() {
			var inversionID = $('#inversionID').val();
			var monedaID = $('#monedaID').val();
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			var monto =  ($('#monto').formatCurrency({
								positiveFormat: '%n', 
								roundToDecimalPlace: 2	
								})).asNumber();
			var fechaEmision = parametroBean.fechaSucursal;
			var dirInst = parametroBean.direccionInstitucion;
			var RFCInst = parametroBean.rfcInst;
			var telInst = parametroBean.telefonoLocal;
			var gerente	= parametroBean.gerenteGeneral;
			var presidente = parametroBean.presidenteConsejo;
			var usuario	= parametroBean.nombreUsuario;
			
			var liga = 'pagareInversionRep.htm?inversionID='+inversionID +
						  '&monedaID=' + monedaID + '&nombreInstitucion=' + nombreInstitucion + '&monto=' + monto
						  +'&direccionInstit='+dirInst+'&RFCInstit='+RFCInst+'&telefonoInst='+telInst+'&fechaActual='+fechaEmision
						  +'&nombreGerente='+gerente+'&nombrePresidente='+presidente+'&nombreUsuario='+usuario;
			$('#enlace').attr('href',liga);
		
	});
		
	function validaInversion(idControl){
		var jqInversion = eval("'#" + idControl + "'");
		var numInversion = $(jqInversion).val();			
		var InversionBean = {
			'inversionID' : numInversion
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numInversion != 0 && numInversion != ''){
			if(esTab){
				inicializaForma('formaGenerica','inversionID');
				inversionServicioScript.consulta(catTipoConsultaInversion.principal, InversionBean,
															 function(inversionCon){
				if(inversionCon!=null){
					var estatus = inversionCon.estatus;

					dwr.util.setValues(inversionCon);
					if(estatus == catStatusInversion.cancelada){														
						alert("La Inversión ha sido Cancelada");
						deshabilitaBoton('imprime', 'submit');
						$(jqInversion).focus();
					}
					
					else if(estatus == catStatusInversion.pagada){														
						alert("La Inversión fue Pagada (Abonada a Cuenta)");
						deshabilitaBoton('imprime', 'submit');
						$(jqInversion).focus();
					}
					else if(estatus == catStatusInversion.alta){
						if(inversionCon.fechaInicio != parametroBean.fechaSucursal){														

							alert("La Inversión debe ser Autorizada en la pantalla Autorización de Inversiones");		
							deshabilitaBoton('imprime', 'submit');
							$(jqInversion).focus();
						}else{
							
							alert("La Inversión debe ser Autorizada en la pantalla Autorización de Inversiones");		
							deshabilitaBoton('imprime', 'submit');
							$(jqInversion).focus();
							
						}
					}else {
						habilitaBoton('imprime', 'submit');
					}
								
					consultaCtaCliente(inversionCon.cuentaAhoID);
					$('#telefono').setMask('phone-us');
				}else{					
					alert("La Inversión no Existe.");
					$(jqInversion).focus();
					$(jqInversion).val('');
					inicializaForma('formaGenerica','inversionID');
					deshabilitaBoton('imprime', 'submit');
				}				
			});
			}
		}	
	}
	
	
	function consultaCliente(idControl) {
		var jqInversion = eval("'#" + idControl + "'");
		var numCliente = $(jqInversion).val();
		var conCliente = catTipoConsultaCliente.paraInversiones;
		var rfc = ' ';
		
		if(numCliente!='0'){
			setTimeout("$('#cajaLista').hide();", 200);		
			if(numCliente != '' && !isNaN(numCliente)){
				clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
							if(cliente!=null){
								$('#nombreCompleto').val(cliente.nombreCompleto);
								$('#telefono').val(cliente.telefonoCasa);
								$('#telefono').setMask('phone');
							}    						
					});
				}
		}		
	}
	
	function consultaDireccion(idControl) {
		var jqInversion = eval("'#" + idControl + "'");
		var numCliente = $(jqInversion).val();
		
		var conOficial = 3;
		var direccionCliente = {
  			'clienteID':numCliente
		};
		setTimeout("$('#cajaLista').hide();", 200);
			if(numCliente != '' && !isNaN(numCliente)){
				direccionesClienteServicio.consulta(conOficial,direccionCliente,function(direccion) {
						if(direccion!=null){	
							$('#direccion').val(direccion.direccionCompleta);
						}
				});
			}
	}
		
	function consultaTipoInversion(){
		var tipoInversion = $('#tipoInversionID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		var tipoInversionBean = {
                'tipoInvercionID':tipoInversion,
                'monedaId': $('#monedaID').val()
        };
		
			if(tipoInversion != 0){
				tipoInversionesServicio.consultaPrincipal(catTipoConsultaTipoInversion.principal,
																		 tipoInversionBean, function(tipoInver){
					if(tipoInver!=null){
						$('#descripcion').val(tipoInver.descripcion);
						calculaCondiciones();
					}				
				});
			}
	}
	
			
	function consultaCtaCliente(cuentaID) {
        var numCta = cuentaID;     
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteID').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);
        
        if(numCta != '' && !isNaN(numCta)){
	          cuentasAhoServicio.consultaCuentasAho(catTipoConsultaCuenta.conSaldo,
	          													CuentaAhoBeanCon,function(cuenta) {
	          	if(cuenta!=null){                		
						$('#totalCuenta').val(cuenta.saldoDispon);
	              	$('#totalCuenta').formatCurrency({colorize: true, positiveFormat: '%n', roundToDecimalPlace: -1});	
	              	$('#tipoMoneda').html(cuenta.descripcionMoneda);
	              	$('#monedaID').val(cuenta.monedaID);
						$('#tipoMonedaInv').html(cuenta.descripcionMoneda);                    	
	              	$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});                    	                		
	          		consultaCliente("clienteID");
	          		consultaDireccion("clienteID");
	              	consultaTipoInversion();
	          	}else{
	          		alert("No Existe la Cuenta de Ahorro");
	          	}
	  			});                                                                                                                        
        }
	}
			
	function calculaCondiciones(){
		var total;
		total = $('#monto').asNumber() + $('#interesRecibir').asNumber();
		$('#tasaNeta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4	});		
		$('#interesGenerado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#interesRetener').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#interesRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});		
		$('#granTotal').val(total);
		$('#granTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});		
	}
			
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			noCliente: 'required',
			cuentaAhoID: 'required',
			tipoInversionID: 'required',
			monto: 'required',
			plazo: 'required',
			fechaVencimiento: 'required'
				
		},
		
		messages: {
			noCliente: 'Especifique número de cliente',
			cuentaAhoID: 'Especifique la cuenta del cliente',
			tipoInversionID:'Especifique el tipo de Inversión',
			monto:'La cantidad a invertir esta vacía',
			plazo:'Indicar el plazo de la inversión',
			fechaVencimiento:'Indicar fecha de vencimiento'
		}
	});
	
	
});