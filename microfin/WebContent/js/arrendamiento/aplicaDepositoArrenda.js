$(document).ready(function() {
	esTab = true;
	var listaVisible=false;
	//Definicion de Constantes y Enums  
	var catTipoTransaccion = {   
			'procesa':'1'
	};
	var catTipoConsultaInstituciones = {
			'principal':1, 
			'foranea':2
	};

	var  catTipoConsultaEstatusFecha={
			'estatus' :4
	};	

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('procesar', 'submit');
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();
	$('#fechaAplica').val(parametroBean.fechaSucursal);
	$('#depRefereID').focus();
	
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
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'depRefereID',
					'funcionExito', 'funcionError');		
		}
	});

	$('#procesar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccion.procesa);
	});
	
	$('#procesar').blur(function() {
		if (esTab) {
			$("#depRefereID").focus();
		}
	});

	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});
	

	$('#depRefereID').bind('keyup',function(e){
		lista('depRefereID', '1', '1', 'depRefereID', $('#depRefereID').val(), 'depRefereArrendaLista.htm');
	});

	$('#depRefereID').blur(function() {
		consultaDepositos(this.id);
		if(isNaN($('#depRefereID').val()) || $('#depRefereID').val() == '' ){
			if (esTab) {
				$('#depRefereID').val("");
				$('#depRefereID').focus();
			}
		}
	});
	
	$('#institucionID').blur(function() {
		consultaInstitucion(this.id);
		if(isNaN($('#institucionID').val()) ){
			$('#institucionID').val("");
			$('#institucionID').focus();
		}
	});

	$('#cuentaBancaria').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionID').val();

		camposLista[1] = "cuentaAhoID";			
		parametrosLista[1] = $('#cuentaBancaria').val();

		lista('cuentaBancaria', '2', '2', camposLista,parametrosLista, 'tesoCargaMovLista.htm');	

	});

	$('#cuentaBancaria').blur(function() {
		if($('#cuentaBancaria').val() != '' ){
			consultaCuentaBan(this.id);	
		} 
		if(isNaN($('#cuentaBancaria').val()) ){
			$('#cuentaBancaria').val("");
			$('#cuentaBancaria').focus();
		}

	});
	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({		
		rules: {
			depRefereID: {
				required: true,	
			},
			depRefereID: {
				required: true,	
			}
		},
		messages: {		
			depRefereID : {
				required : 'Especificar deposito referenciado',
			},
			institucionID : {
				required : 'Especificar la institucion',
			}
		}
	});


	//Método de consulta de Institución
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
				'institucionID':numInstituto
		};

		if(numInstituto != '' && !isNaN(numInstituto)  ){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea, InstitutoBeanCon, function(instituto){
				if(instituto!=null){							
					$('#nombreInstitucion').val(instituto.nombre);
					$('#cuentaAhoID').val("");
					$('#nombreBanco').val("");
					$('#cuentaBancaria').val("");
					
				}else{
					mensajeSis("No se encontro la Institucion");
					$('#institucionID').focus();
					$('#institucionID').val("");
					$('#nombreInstitucion').val("");
					$('#cuentaAhoID').val("");
					$('#nombreBanco').val("");
					$('#cuentaBancaria').val("");
				}    						
			});
		}
	}
	
	//Método de consulta de Institución
	function consultaDepositos(idControl) {
		var jqDepositoID = eval("'#" + idControl + "'");
		var numeroDeposito = $(jqDepositoID).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var beanCon = {
				'depRefereID':numeroDeposito
		};

		if(numeroDeposito != '' && !isNaN(numeroDeposito)  ){
			depositoRefereArrendaServicio.consulta(1, beanCon, function(depositoRef){
				if(depositoRef!=null){							
					$('#depRefereID').val(depositoRef.depRefereID);
					$('#institucionID').val(depositoRef.institucionID);
					$('#cuentaBancaria').val(depositoRef.numCtaInstit);
					$('#fechaCarga').val(depositoRef.fechaCarga);
					consultaInstitucion('institucionID') ;
					consultaCuentaBan('cuentaBancaria');	
					listaDepositos();
				}else{
					mensajeSis("No se encontraron datos");
					$('#depRefereID').val("");
					$('#institucionID').val("");
					$('#nombreInstitucion').val("");
					$('#cuentaBancaria').val("");
					$('#nombreBanco').val("");
					$('#fechaCarga').val("");
					$('#listaDepositosArrenda').html("");
					$('#listaDepositosArrenda').hide();
					deshabilitaBoton('procesar', 'submit');
					$('#depRefereID').focus();
				}    						
			});
		}	
	}

	function consultaCuentaBan(idControl) {
		var jqCuentaBan= eval("'#" + idControl + "'");
		var numCuenta = $(jqCuentaBan).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var tipoConsulta = 9;
		var DispersionBeanCta = {
				'institucionID': $('#institucionID').val(),
				'numCtaInstit': numCuenta
		};
		if(!isNaN(numCuenta)){		
			operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
				if(data!=null){
					$('#cuentaAhoID').val(data.cuentaAhorro);
					$('#cuentaBancaria').val(numCuenta);
					$('#nombreBanco').val(data.nombreCuentaInst);
				}else{
					mensajeSis("No se encontro la cuenta bancaria.");
					$('#cuentaAhoID').val('');
					$('#nombreBanco').val('');
					$('#cuentaBancaria').val('');
					$('#cuentaBancaria').focus();
				}
			});
		}
	}

	
});


//FUNCION PARA LISTAR LOS DEPOSITOS REFERENCIADOS
function listaDepositos(){
	parametroBean = consultaParametrosSession();
	var params = {};
	params['tipoConsulta'] 			= 2; 
	params['depRefereID']			= $('#depRefereID').val();
	params['empresaID'] 			= parametroBean.empresaID;
	params['usuario'] 				= parametroBean.numeroUsuario;
	params['fecha'] 				= parametroBean.fechaSucursal;
	params['direccionIP'] 			= parametroBean.IPsesion;
	params['sucursal'] 				= parametroBean.sucursal;
	bloquearPantallaDepArrenda();
	$.post("depositosRefereArrendaLista.htm",params,function(data) {
		if (data.length > 0 || data != null) {
			$('#listaDepositosArrenda').show(); 
			$('#listaDepositosArrenda').html(data);
			habilitaBoton('procesar', 'submit');
		} else{
			$('#listaDepositosArrenda').html("");
			$('#listaDepositosArrenda').hide();
			deshabilitaBoton('procesar', 'submit');
		}
		$('#contenedorForma').unblock();
		agregaFormatoControles('formaGenerica');
	});
}
//funcion que bloque la pantalla mientras se cotiza
function bloquearPantallaDepArrenda() {
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
		message : $('#mensaje'),
		css : {
			border : 'none',
			background : 'none'
		}
	});

}


function cambiaSeleccionado(idCheck, idCampoOculto){

	var jqCheck	= eval("'#" + idCheck + "'");
	var jqCampo	= eval("'#" + idCampoOculto + "'");
	
	if($(jqCheck).attr('checked')==true){
		$(jqCheck).attr('checked', true);
		$(jqCampo).val("S");
	}else{
		$(jqCheck).attr('checked', false);
		$(jqCampo).val("N");
	}
}

function funcionExito(){
	$('#depRefereID').focus();

}

function funcionError(){
	agregaFormatoControles('formaGenerica');
	

}



