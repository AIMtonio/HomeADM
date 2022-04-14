$(document).ready(function() {
	esTab = false;
	var resultadoTransaccion = 99;
	
	//Definicion de Constantes y Enums  
	var catTipoConsultaTipoCtaAho = {
  		'principal':1,
  		'foranea':2
	};	
	
	
	
	var catTipoConsultaCta = {
  		'saldoDispon':5,
  		'saldoDisponHis':12,
  		'prinAct':15
	};

	
	var catTipoTransaccionCtaAho = {
  		'actualiza':'1'
	};
	var catTipoConsultaTipoCuenta = {
	  		'principal':1,
	  		'foranea':2
		};	

	
	//------------ Metodos y Manejo de Eventos ----------------O------M------A------R-------
   deshabilitaBoton('grabar', 'submit');
   $('#cuentaAhoID').focus();
   inicializaForma('formaGenerica', 'cuentaAhoID');
   
   var parametroBean = consultaParametrosSession();

   
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cuentaAhoID',
					'funcionExito','funcionError');

		}
	});			

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#grabar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCtaAho.actualiza);
		


	});
	
	$('#cuentaAhoID').blur(function() {
		if(esTab){
			consultaCtaAho(this.id,'tipoCuenta','tipoCuentaID','clienteID','saldoDispon','nombreClienteSBC');
		 	llenaComboCheques();
			limpiaCamposChequeSBC();
			
		}		
	});
	
	

	
	$('#cuentaAhoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#cuentaAhoID').val();
			lista('cuentaAhoID', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}				       
	});	
	
	$('#chequeSBCID').change(function() {
		consultaChequeSBC(this.id);		
	
	});
	
	$('#clienteID').blur(function() {
  		consultaCliente(this.id);
  		
	});
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			clienteID: 	  'required',
			tipoCuenta:   'required',
			fechaRec: 	  'required',	
			comFalsoCobro:'required',
			montoIva:	  'required',
			saldoSBC:	  'required',
			bancoEmisor:  'required',					
			cuentaEmisor: 'required',
			nombreEmisor: 'required',
			montoCheque:  'required',
			
			saldoDispon:  'required'
				},
		
		messages: {
			clienteID: 	 	'Especifique Cliente',
			tipoCuenta:  	'Especifique  tipo de Cuenta',
			comFalsoCobro:	'Especifique la comisión',
			montoIva:	 	'Especifique iva de comisión',
			saldoSBC:	 	'Especifique el saldoSBC ',
			bancoEmisor: 	'Especifique el Banco Emisor',					
			cuentaEmisor:	'Especifique Cuenta del Emisor',
			nombreEmisor:	'Especifique nombre de Emisor ',
			montoCheque: 	'Especifique el monto',
			fechaRec:	 	'Especifique Fecha de Recepción',
			saldoDispon:	'Especifique Saldo',
				 }		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	//la consulta principal dependiendo de la Cuenta de Ahorro
	function consultaCtaAho(control,cliente) {
			var numCta = $('#cuentaAhoID').val();
			var tipConCampos= 4;
			var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){	
									$('#clienteID').val(cuenta.clienteID);
									$('#tipoCuenta').val(cuenta.descripcionTipoCta);
									$('#tipoCuentaID').val(cuenta.tipoCuentaID);
									$('#cuentaAhoID').val(cuenta.cuentaAhoID);
									$('#status').val(cuenta.estatus);
									 consultaCliente('clienteID');
									 consultaSaldoDisp('cuentaAhoID');
									 comisionFalsoCobro('tipoCuentaID');
								     $('#chequeSBCID').focus();			
						
								 
								 
						}else{
							mensajeSis("No Existe la cuenta de ahorro");
							$('#cuentaAhoID').focus();
							$('#cuentaAhoID').val("");
					
						}
			});															
		}else{
			if(isNaN(numCta) && esTab){
				mensajeSis("No Existe la cuenta de ahorro");
				$('#cuentaAhoID').focus();
				$('#cuentaAhoID').val("");				
			}
		}
	}
	
	//Consulta el Saldo Disponible del Cliente
	function consultaSaldoDisp(control) {
			var jqnumCta = eval("'#" + control + "'");
			var	numCta = $(jqnumCta).val();  
			var cliente =  $('#clienteID').val();   
			var CuentaAhoBeanCon = {
                'cuentaAhoID':numCta,
                'clienteID':cliente
		};
		setTimeout("$('#cajaLista').hide();", 200);    
		if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(catTipoConsultaCta.saldoDispon, CuentaAhoBeanCon, function(cuenta) {
				if(cuenta!=null){
					$('#saldoDispon').val(cuenta.saldoDispon);
	          		$('#saldoSBC').val(cuenta.saldoSBC); 
	      		}else{
					mensajeSis('El cliente especificado no tiene saldo disponible ');
				}
			});                                                                                                                        
		};
	}
	//consulta la institucion del emisor 
	function consultaInstitucion(idControl,nombreInstitucion) {
			var catTipoConsultaInstituciones = 2;
			var jqInstituto = eval("'#" + idControl + "'");
			var jqNomInstituto=eval("'#" + nombreInstitucion + "'");
			var numInstituto = $(jqInstituto).val();			
		
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
  				'institucionID':numInstituto,
		};
		if(numInstituto != '' && !isNaN(numInstituto)){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones,InstitutoBeanCon,function(instituto){
				if(instituto!=null){
					$(jqNomInstituto).val(instituto.nombre);
					var comision=$('#comFalsoCobro').asNumber();
					var iva=$('#montoIva').asNumber();
					var saldo=$('#saldoDispon').asNumber();
					var suma=comision+iva;
					if (saldo>=suma){
					 		habilitaBoton('grabar','submit');
					if ($('#descbancoEmisor').val()== ""){
	  						    deshabilitaBoton('grabar','submit');
	  					}else{	habilitaBoton('grabar','submit');}
					}else{
						deshabilitaBoton('grabar','submit');
						mensajeSis('La cuenta debe de tener saldo suficiente para el cobro de la comisión.');
						
					};
					
				}else{
					mensajeSis("No existe la Institución");
                    $(jqInstituto).val('');
                    $(jqInstituto).focus();
                    $('#descbancoEmisor').val("");
				}
			});
		};
	}
	

	// consulta y llena el combox de chequeSBC
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
  					deshabilitaBoton('grabar','submit');
  					dwr.util.removeAllOptions('chequeSBCID');
  					dwr.util.addOptions('chequeSBCID', 'NO TIENE OPCIONES');
  					
  				}
  				
  			});
  		};
	}
	//consulta cheques 
	function consultaChequeSBC(idControl){
			var jqControl=eval("'#"+idControl+"'");
			var valorControl=$(jqControl).val();		
			var consultaPrincipal = 1;
		
		setTimeout("$('#cajaLista').hide();", 200);	
		var chequeBean = {
  				'chequeSBCID':valorControl,
		};
		if(valorControl != '' && !isNaN(valorControl)){
			abonoChequeSBCServicio.consulta(consultaPrincipal,chequeBean,function(cheque){
				if(cheque !=null){
					$('#bancoEmisor').val(cheque.bancoEmisor);					
					$('#cuentaEmisor').val(cheque.cuentaEmisor);
					$('#nombreEmisor').val(cheque.nombreEmisor);
					$('#montoCheque').val(cheque.monto);
					$('#fechaRec').val(cheque.fechaCobro);
					actualizaFormatosMoneda('formaGenerica');
					consultaInstitucion('bancoEmisor','descbancoEmisor');
				
				}else{
					deshabilitaBoton('grabar','submit');
					mensajeSis("El cheque no existe");
					$('#descbancoEmisor').val("");
					$('#bancoEmisor').val("");
					$('#nombreEmisor').val("");
					$('#cuentaEmisor').val("");
					$('#montoCheque').val("");
					$('#fechaRec').val("");
                    $(jqControl).val('');
                    $(jqControl).focus();                    
				}
			});
		}

	}

	//Hace la llamada al cliente segun su Cuenta de ahorro
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =1;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
						if(cliente!=null){							
							$('#nombreCte').val(cliente.nombreCompleto);	
						
						}else{
							mensajeSis("No Existe el Cliente");
							$(jqCliente).focus();
						}    						
				});
			}
	}
	//funcion que limpia campos de la pantalla 
	function limpiaCamposChequeSBC(){
		$('#tipoCuenta').val("");
		$('#clienteID').val("");
		$('#nombreCliente').val("");
		$('#saldoDispon').val("");
		$('#bancoEmisor').val("");
		$('#nombreEmisor').val("");
		$('#cuentaEmisor').val("");
		$('#montoCheque').val("");
		$('#comFalsoCobro').val("");
		$('#nombreCte').val("");
		$('#saldoSBC').val("");
		$('#tipoCuentaID').val("");
		$('#montoIva').val("");
		$('#descbancoEmisor').val("");
		dwr.util.removeAllOptions('chequeSBCID'); 
		$('#fechaRec').val("");
		deshabilitaBoton('grabar','submit');
	}
		
	//función para traer la comision y asu vez para calcularle el iva
	function comisionFalsoCobro(control) {
		var numCta = $('#tipoCuentaID').val();
		var TipoCuentaBeanCon = {
  			'tipoCuentaID':numCta,
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCta != '' && !isNaN(numCta) ){
			if(numCta=='0'){
				inicializaForma('formaGenerica','tipoCuentaID');
			
			} else {
				tiposCuentaServicio.consulta(1, TipoCuentaBeanCon,function(tipoCuenta) {
						if(tipoCuenta!=null){
							dwr.util.setValues(tipoCuenta);
							$('#comFalsoCobro').val(tipoCuenta.comFalsoCobro);
							var ivaSucursal = parametroBean.ivaSucursal ;
							if ($('#comFalsoCobro').asNumber() == '0'){
								$('#montoIva').val('0.00');
							}else{
								$('#montoIva').val($('#comFalsoCobro').asNumber()*ivaSucursal);
								actualizaFormatosMoneda('formaGenerica');
								 }
							
						}else{
							limpiaForm($('#formaGenerica'));
							mensajeSis("No Existe el comisión");

							
							 }
				});
			}
		}
	}


});


//funcion que se ejecuta cuando el resultado fue exito
function funcionExito(){
	deshabilitaBoton('grabar', 'submit');
	$('#tipoCuenta').val("");
	$('#clienteID').val("");
	$('#nombreCliente').val("");
	$('#saldoDispon').val("");
	$('#bancoEmisor').val("");
	$('#nombreEmisor').val("");
	$('#cuentaEmisor').val("");
	$('#montoCheque').val("");
	$('#comFalsoCobro').val("");
	$('#nombreCte').val("");
	$('#saldoSBC').val("");
	$('#tipoCuentaID').val("");
	$('#montoIva').val("");
	dwr.util.removeAllOptions('chequeSBCID'); 
	$('#fechaRec').val("");
	$('#cuentaAhoID').val("");
	$('#cuentaAhoID').focus();
	$('#descbancoEmisor').val("");
}
//funcion que se ejecuta cuando el resultado fue error
//diferente de cero
function funcionError(){
	
	
	
}



