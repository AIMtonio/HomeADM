$(document).ready(function() {
	 parametros = consultaParametrosSession();
	
	
	var catTipoTransaccionChequeSBC = {
		'aplicaChequeSBCDeposito' : '1',
	};

		// ------------ Metodos y Manejo de Eventos
	deshabilitaBoton('guardar', 'submit');
	agregaFormatoControles('formaGenerica');
	$('#cuentaAhoID').focus();
	
	$.validator.setDefaults({									
	    submitHandler: function(event) {	 
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cuentaAhoID','exitoCheque','fallaCheque'); 
	      }
	 });
		   				
	$('#guardar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionChequeSBC.aplicaChequeSBCDeposito);
	});
	
	$('#cuentaAhoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#cuentaAhoID').val();		
			listaAlfanumerica('cuentaAhoID', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}				       
	});
	
	$('#cuentaAhoID').blur(function() {		
		if ($('#cuentaAhoID').val() == ''){		
			limpiaFormulario();
		}else{
			consultaCtaAhoChequeSBC(this.id);
		}
	});	
	
	$('#chequeSBCID').change(function() {
		if($('#chequeSBCID').val() > 0){
			consultaChequeSBC(this.id);		
		}else{
			mensajeSis("Seleccione una opción");
			limpiaCampos();
			$('#chequeSBCID').focus().select();
			deshabilitaBoton('guardar', 'submit');
			
		}
	});
	
	$('#bancoAplica').bind('keyup',function(e){	
		var institucionID = $('#bancoAplica').val();
		lista('bancoAplica', '1','1', 'nombre', institucionID, 'listaInstituciones.htm');
	});
	
	$('#cuentaBancoAplica').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "numCtaInstit";
		camposLista[1] = "institucionID";
		parametrosLista[0] = $('#cuentaBancoAplica').val();
		parametrosLista[1] = $('#bancoAplica').val();
		listaAlfanumerica('cuentaBancoAplica', '2', '7', camposLista,parametrosLista, 'ctaNostroLista.htm');	       
	});	
	
	
		
	$('#bancoAplica').blur(function() {
		if($('#bancoAplica').val() == ''){
			$('#cuentaBancoAplica').val('');
			$('#descripcionBanco').val('');
		}else{
			consultaInstitucion(this.id,'descripcionBanco');
			$('#cuentaBancoAplica').val('');
		}
	});	
	//------------ Validaciones de la Forma -------------------------------------
		$('#formaGenerica').validate({			
			rules: {			
				cuentaAhoID: {
					required: true,	
					numeroPositivo: true
				},	
				chequeSBCID: {
					required: true,										
				},					
				bancoAplica: {
					required: true,	
					numeroPositivo: true,
				},	
				cuentaBancoAplica: {
					required: true,	
					numeroPositivo: true
				},
			},		
			messages: {
				cuentaAhoID: {
					required: 'Especificar el número de cuenta',
					numeroPositivo: 'Sólo números'
				},		
				chequeSBCID: {
					required: 'seleccione un número de cheque'									
				},	
				bancoAplica: {
					required: 'Ingrese una institución',
					numeroPositivo: 'Sólo números'
				},	
				cuentaBancoAplica: {
					required: 'Ingrese la cuenta',	
					numeroPositivo: 'Sólo números'
				},					
				
			}		
		});
		
//-------------------- Métodos------------------										
		
		function consultaCtaAhoChequeSBC(idControl) {
			var numCta = eval("'#" + idControl + "'");				
			var valorCta=$(numCta).val();
			var ctaActiva='A';
			var tipConCampos= 4;
			var CuentaAhoBeanCon = {
				'cuentaAhoID'	:valorCta
			};
			if(valorCta != '' && !isNaN(valorCta)){
				setTimeout("$('#cajaLista').hide();", 200);
				cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
							if(cuenta != null){	
								limpiaCamposChequeSBC();
								if(cuenta.estatus != ctaActiva){
									mensajeSis("La Cuenta no se encuentra activa");
									$(numCta).focus();									
								}else{
									 $('#tipoCuentaSBCAplic').val(cuenta.descripcionTipoCta);
									 $('#clienteID').val(cuenta.clienteID);
									consultaSaldoCtaSBC(idControl,cuenta.clienteID);
									consultaClienteCtaSBC('clienteID','nombreReceptor');
									llenaComboCheques();
								}
								
							}else{
								mensajeSis("No Existe la cuenta de ahorro");
								$(numCta).val("");							
								$(numCta).focus();																
							}
					});														
			}
		}
		
		function consultaSaldoCtaSBC(idControl,numCte ) {
			var jqCta  = eval("'#" + idControl + "'");			
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
								$('#saldoDisponible').val(cuenta.saldoDispon);	
								$('#monedaID').val(cuenta.monedaID);
								$('#saldoSBC').val(cuenta.saldoSBC);	
								agregaFormatoMoneda('formaGenerica');
							}else{
								mensajeSis("No Existe la cuenta de ahorro o no corresponde a la persona indicada");
								$(jqCta).focus();
								$(jqCta).select();										
							}
					});															
			}
		}

		
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
				
	function llenaComboCheques(){
		var numeroCta=$('#cuentaAhoID').val();
		var chequeSBCBean = {
				'cuentaAhoID'	:numeroCta,
		};
		
  		
  		if(numeroCta != '' && !isNaN(numeroCta)){
  			abonoChequeSBCServicio.listaCombo(1,chequeSBCBean, function(cheque){
  				if(cheque != null){
  					dwr.util.removeAllOptions('chequeSBCID'); 
  					dwr.util.addOptions('chequeSBCID', {'0':'Selecciona'});
  					dwr.util.addOptions('chequeSBCID', cheque, 'chequeSBCID', 'numCheque');   					
  				}else{
  					mensajeSis("La cuenta no tiene cheques pendientes de cobro");
  					dwr.util.removeAllOptions('chequeSBCID');
  					dwr.util.addOptions('chequeSBCID', 'NO TIENE OPCIONES');
  					
  				}
  			});
  		}
		
	}
	function consultaChequeSBC(idControl){
		var jqControl=eval("'#"+idControl+"'");
		var valorControl=$(jqControl).val();		
		var consultaPrincipal = 1;
		
		setTimeout("$('#cajaLista').hide();", 200);	
		var chequeBean = {
  				'chequeSBCID':valorControl
		};
		if(valorControl != '' && !isNaN(valorControl)){
			abonoChequeSBCServicio.consulta(consultaPrincipal,chequeBean,function(cheque){
				if(cheque !=null){
					$('#bancoEmisor').val(cheque.bancoEmisor);					
					$('#nombreEmisorSBC').val(cheque.nombreEmisor);
					$('#cuentaEmisor').val(cheque.cuentaEmisor);
					$('#numCheque').val(cheque.numCheque);
					$('#monto').val(cheque.monto);
					$('#fechaCobro').val(cheque.fechaCobro);
					consultaInstitucion('bancoEmisor','nombreBancoEmisor');
					habilitaBoton('guardar', 'submit');
					$('#bancoAplica').focus();     
					agregaFormatoMoneda('formaGenerica');
					
				}else{
					mensajeSis("El cheque no existe");
					limpiaCampos();
                    $(jqControl).val('');
                    $(jqControl).focus();                    
				}
			});
		}

	}
	function consultaInstitucion(idControl,nombreBanco) {
		var catTipoConsultaInstituciones = 2;
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();		
		
		var jqNombreBanco = eval("'#" + nombreBanco + "'");
		
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
  				'institucionID':numInstituto
		};
		if(numInstituto != '' && !isNaN(numInstituto)){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones,InstitutoBeanCon,function(instituto){
				if(instituto!=null){
					$(jqNombreBanco).val(instituto.nombre);		
					if(idControl == 'bancoAplica' ){
						$('#cuentaBancoAplica').focus();
					}
				}else{
					mensajeSis("No existe la Institución");
                    $(jqInstituto).val('');
                    $(jqInstituto).focus();
                    $(jqNombreBanco).val("");
				}
			});
		}
	}
	
	function limpiaCamposChequeSBC(){
		dwr.util.removeAllOptions('chequeSBCID'); 
		$('#fechaCobro').val('');
		$('#bancoEmisor').val('');
		$('#nombreBancoEmisor').val('');
		$('#cuentaEmisor').val('');
		$('#nombreEmisorSBC').val('');
		$('#numCheque').val('');
		$('#monto').val('');
		$('#bancoAplica').val('');
		$('#descripcionBanco').val('');
		$('#cuentaBancoAplica').val('');
		
	}
	
	function limpiaCampos(){
		$('#fechaCobro').val('');
		$('#bancoEmisor').val('');
		$('#nombreBancoEmisor').val('');
		$('#cuentaEmisor').val('');
		$('#nombreEmisorSBC').val('');
		$('#numCheque').val('');
		$('#monto').val('');
		$('#bancoAplica').val('');
		$('#descripcionBanco').val('');
		$('#cuentaBancoAplica').val('');
		
	}
});

function exitoCheque(){
	limpiaFormulario();
	deshabilitaBoton('guardar', 'submit');
}

function fallaCheque(){
	
}

function limpiaFormulario(){	
	$('#fechaCobro').val('');
	$('#bancoEmisor').val('');
	$('#nombreBancoEmisor').val('');
	$('#cuentaEmisor').val('');
	$('#nombreEmisorSBC').val('');
	$('#numCheque').val('');
	$('#monto').val('');
	$('#bancoAplica').val('');
	$('#descripcionBanco').val('');
	$('#cuentaBancoAplica').val('');
	
	$('#tipoCuentaSBCAplic').val('');
	$('#clienteID').val('');
	$('#nombreReceptor').val('');
	$('#saldoDisponible').val('');
	$('#saldoSBC').val('');
	$('#chequeSBCID option[value="0"]').attr('selected','true');
	
	
}