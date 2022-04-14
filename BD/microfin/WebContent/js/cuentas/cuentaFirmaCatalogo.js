
$(document).ready(function() {
	esTab = false;
    $('#cuentaAhoID').focus();
//	Definicion de Constantes y Enums  
	var catTipoTransaccionCtaAho = {
			'grabar':'1'
	};

	var catTipoConsultaCtaFirma = {
			'principal':1,
			'foranea':2
	};	


//	------------ Metodos y Manejo de Eventos -----------------------------------------

	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('consultar', 'submit');
	$(':text').focus(function() {	
		esTab = false;
	});

	$.validator.setDefaults({
		onclick:false,
		submitHandler: function(event) { 
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma',
					'mensaje', 'true','cuentaAhoID','funcionResultadoExitoso','funcionResultadoFallido');
		}
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#grabar').click(function(event) {		
		$('#tipoTransaccion').val(catTipoTransaccionCtaAho.grabar);	
		crearFirmantes();
		consultaFirmantes();
		$('#grabar').hide();
	});	


	$('#grabar').attr('tipoTransaccion', '1');

	$('#consultar').click(function() {		
		consultaFirmantes();		
	});	

	$('#cuentaAhoID').blur(function() {
		consultaCtaAho(this.id);
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


//	------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			cuentaAhoID: 'required'	
		},

		messages: {
			cuentaAhoID: 'Especifique la Cuenta de Ahorro'	
		}		
	});


//	------------ Validaciones de Controles -------------------------------------

	function consultaCtaAho(control) {
		var numCta = $('#cuentaAhoID').val();
		var tipConCampos= 4;
		var CuentaAhoBeanCon = {
				'cuentaAhoID'	:numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCta != '' && !isNaN(numCta) ){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
				if(cuenta!=null){	
					$('#tipoCuenta').val(cuenta.descripcionTipoCta);
					$('#cuentaAhoID').val(cuenta.cuentaAhoID);
					$('#numCliente').val(cuenta.clienteID);
					consultaClientePantalla('numCliente');
					consultaSaldoCtaAho(control,cuenta.clienteID);
					habilitaBoton('consultar', 'submit');

				}else{
					mensajeSis("No Existe la cuenta de ahorro");
					$('#tipoCuenta').val("");
					$('#numCliente').val("");
					$('#nombreCliente').val("");
					$('#saldoDispon').val("");	
					$('#moneda').val("");
					$('#gridFirmantes').html("");
					$('#gridFirmantes').hide();
					$('#cuentaAhoID').val("");
					$('#cuentaAhoID').focus();
					$('#cuentaAhoID').select();	
					$('#imprimir').hide();
					$('#grabar').hide();
					deshabilitaBoton('consultar', 'submit');
				}
			});															
		}else{
			if(isNaN(numCta) && esTab){
				mensajeSis("No Existe la cuenta de ahorro");
				$('#tipoCuenta').val("");
				$('#numCliente').val("");
				$('#nombreCliente').val("");
				$('#saldoDispon').val("");	
				$('#moneda').val("");
				$('#gridFirmantes').html("");
				$('#gridFirmantes').hide();
				$('#cuentaAhoID').val("");
				$('#cuentaAhoID').focus();
				$('#cuentaAhoID').select();	
				$('#imprimir').hide();
				$('#grabar').hide();
				deshabilitaBoton('consultar', 'submit');
				
			}
		}
	}

	function consultaSaldoCtaAho(control,numCte) {
		var numCta = $('#cuentaAhoID').val();
		var tipConCampos= 5;
		var CuentaAhoBeanCon = {
				'cuentaAhoID'	:numCta,
				'clienteID'		:numCte
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
				if(cuenta!=null){	
					$('#saldoDispon').val(cuenta.saldoDispon);	
					$('#moneda').val(cuenta.descripcionMoneda);																	
				}else{
					mensajeSis("No Existe la cuenta de ahorro o no corresponde a ese cliente");
					$('#saldoDispon').val("");	
					$('#moneda').val("");	
					$('#cuentaAhoID').focus();
					$('#cuentaAhoID').select();										
				}
			});															
		}
	}


	function consultaClientePantalla(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =5;
		var rfc = ' ';
		var tipoFisica = 'FISICA';
		var tipoMoral	= 'MORAL';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
				if(cliente!=null){		

					$('#gridFirmantes').html("");
					$('#gridFirmantes').show();
					deshabilitaBoton('grabar', 'submit');
					$('#imprimir').hide();
					var tipo = (cliente.tipoPersona);
					if(tipo=="F"){
						$('#nombreCliente').val(cliente.nombreCompleto);
					}
					if(tipo=="M"){
						$('#nombreCliente').val(cliente.razonSocial);	
					}	
					if(tipo=="A"){
						$('#nombreCliente').val(cliente.nombreCompleto);	
					}

				}else{
					mensajeSis("No Existe el Cliente");
					$('#nombreCliente').val("");
					$(jqCliente).focus();
				}    						
			});
		}
	}

	function consultaFirmantes(){	
		var params = {};
		params['tipoLista'] = 2;
		params['cuentaAhoID'] = $('#cuentaAhoID').val();

		$.post("gridPersonaFirmante.htm", params, function(data){
			if(data.length >0) {
				$('#gridFirmantes').html(data);
				$('#gridFirmantes').show();
				$('#grabar').show();
				// si la lista devolvio personas relacionadas, se muestra el boton de imprimir
				if($('#numeroPersonasRegistradas').asNumber()>0 && $('#varInstruccion').val()!=""){
					habilitaBoton('imprimir', 'submit');
					$('#imprimir').show();
					habilitaBoton('grabar', 'submit');
				}else{
					if($('#numeroPersonasRegistradas').asNumber()==0){
						$('#imprimir').hide();
						deshabilitaBoton('grabar', 'submit');
					}else{
						$('#imprimir').hide();
						habilitaBoton('grabar', 'submit');
					}
				}
			}else{
				$('#gridFirmantes').html("");
				$('#gridFirmantes').show();
				$('#grabar').hide();
			}

		});
	}

	function crearFirmantes(){	
		var numFirmas = $('input[name=personaID]').length;
		$('#firmantes').val("");
		for(var i = 1; i <= numFirmas; i++){
			if(i == 1){
				$('#firmantes').val($('#firmantes').val() +
						document.getElementById("personaID"+i+"").value + '#@' +
						document.getElementById("nombreCompleto"+i+"").value + '#@' +
						document.getElementById("tipo"+i+"").value + '#@' + 
						document.getElementById("instrucEspecial"+i+"").value);
			}else{
				$('#firmantes').val($('#firmantes').val() + ',' +
						document.getElementById("personaID"+i+"").value + '#@' +
						document.getElementById("nombreCompleto"+i+"").value + '#@' +
						document.getElementById("tipo"+i+"").value + '#@' + 
						document.getElementById("instrucEspecial"+i+"").value);			
			}	
		}
	}

	$('#imprimir').click(function() {	
		var ctaAho = $('#cuentaAhoID').val();
		
		$('#enlace').attr('href','ImpresionFirmas.htm?cuentaAhoID='+ctaAho+'&sucursalID='+parametroBean.sucursal);
	});

});

//-- funciones de exito y fallido 

function funcionResultadoExitoso(){
	$('#imprimir').show();
	consultaFirmantesExito();
}

function funcionResultadoFallido(){
	$('#imprimir').hide();
}

function consultaFirmantesExito(){	
	var params = {};
	params['tipoLista'] = 2;
	params['cuentaAhoID'] = $('#cuentaAhoID').val();

	$.post("gridPersonaFirmante.htm", params, function(data){
		if(data.length >0) {
			$('#gridFirmantes').html(data);
			$('#gridFirmantes').show();
			$('#grabar').show();
			// si la lista devolvio personas relacionadas, se muestra el boton de imprimir
			if($('#numeroPersonasRegistradas').asNumber()>0 && $('#varInstruccion').val()!=""){
				$('#imprimir').show();
				habilitaBoton('grabar', 'submit');
			}else{
				if($('#numeroPersonasRegistradas').asNumber()==0){
					$('#imprimir').hide();
					deshabilitaBoton('grabar', 'submit');
				}else{
					$('#imprimir').hide();
					habilitaBoton('grabar', 'submit');
				}
			}
		}else{
			$('#gridFirmantes').html("");
			$('#gridFirmantes').show();
			$('#grabar').hide();
		}

	});
}


function validador(e){
	key=(document.all) ? e.keyCode : e.which;
		if (key == 44){
			return false;
		}
		else 
  		return true;
	}