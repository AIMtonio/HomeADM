$(document).ready(function() {	
    // conseguimos la fecha del sistema
    var parametroBean = consultaParametrosSession();
    $('#fechaSolicitud').val(parametroBean.fechaSucursal);	

	//Definicion de Constantes y Enums  		
	var catTipoTranSolicita = {
  		'nuevaTarjeta':'1',
		'reposicion'  :'2' 
  	};
	var catTipoTranCancela = {
	'actualizacion':'3'  	
	};
	var catTipoConsultaCliente = {
			'corporativos' : '12'
	};
	$(':text').focus(function() {
		esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
    deshabilitaBoton('solicitar', 'submit');
	deshabilitaBoton('cancelar,submit');	
	agregaFormatoControles('formaGenerica');
	$('#tarjetaNueva').attr('checked', 'true');
	$('.nueva').show();
	$('.reposicion').hide();
	$('#tipoTransaccion').val(catTipoTranSolicita.nuevaTarjeta);
	$('#folio').focus();
	limpiarFormularioSolicitaTarjeta();
	
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			habilitaControl('descripcionTarjeta');
	    	habilitaControl('nombreClienteTar');
	    	habilitaControl('relTar');
	    	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','folio', 
	    		'funcionExitoSolicTar','funcionErrorSolicTar');
	    	deshabilitaControl('relTar');
		}
	});	
	
	$('#solicitar').click(function() {
		if ($('#tarjetaNueva').is(':checked')){
			$('#tipoTransaccion').val(catTipoTranSolicita.nuevaTarjeta);
		}else{
			$('#tipoTransaccion').val(catTipoTranSolicita.reposicion);
	}
	});
	
	
	$('#cancelar').click(function() {
		$('#tipoTransaccion').val(catTipoTranCancela.actualizacion);
	});
	$('#folio').blur(function() {
		if ($('#folio').val()==0 && $('#folio').val()!=''){
			if ($('#tarjetaNueva').is(':checked')){
				habilitaControl('clienteID');
				habilitaControl('cuentaAhoID');
				habilitaControl('corpRelacionado');
				habilitaControl('tipoTarjetaDebID');
				habilitaControl('numeroTar');
				habilitaControl('relTar');	
				deshabilitaControl('nombreCliente');
				habilitaControl('nombreClienteTar');
				$('#status').val('SOLICITUD NUEVA');
				$('#corpRelacionado').focus();
				limpiarFormularioParaFolio();
				habilitaBoton('solicitar,submit');	
				deshabilitaBoton('cancelar,submit');	
			}else{				
				deshabilitaControl('clienteID');
				deshabilitaControl('cuentaAhoID');
				habilitaControl('numeroTar');
				$('#status').val('SOLICITUD NUEVA');
				$('#numeroTar').focus();
				limpiarFormularioParaFolio();
				deshabilitaBoton('solicitar,submit');
			}
		}else{			
			consultaDatosFolio(this.id);	
		}				
	});

	$('#corpRelacionado').blur(function() {	
		consultaCorp();
	});

	$('#cuentaAhoID').blur(function() {	
		consultaCtaAho(this.id);
	});
	$('#clienteID').blur(function() {	
		consultaCliente(this.id);
	
	});
	$('#tipoTarjetaDebID').blur(function() {	
		consultaTarjeta(this.id);
	
	});

	$('#numeroTar').blur(function() {		
		consultaDatosTarjetaDebito(this.id);
	});

	if ($('#numeroTar').val()=='');{
		limpiarFormularioSolicitaTarjeta();
	}
	
	$('#tarjetaNueva').click(function(){
		$('.nueva').show();
		$('.reposicion').hide();
		//$('#tipoTransaccion').val(catTipoTranSolicita.nuevaTarjeta);
		limpiarFormularioSolicitaTarjeta();
		$('#folio').focus();
		deshabilitaBoton('solicitar,submit');
		$('#nombreClienteTar').val('');	
	});

	$('#tarjetaRep').click(function(){
		$('.nueva').hide();
		$('.reposicion').show();
		//$('#tipoTransaccion').val(catTipoTranSolicita.reposicion);
		limpiarFormularioSolicitaTarjeta();
		$('#folio').focus();
		deshabilitaControl('clienteID');
		deshabilitaControl('cuentaAhoID');
		deshabilitaBoton('solicitar,submit');
		$('#nombreClienteTar').val('');	
	});

    //lista de tarjetas de debito 
    $('#numeroTar').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "tarjetaDebID";		
		parametrosLista[0] = $('#numeroTar').val();
		lista('numeroTar', '1', '4', camposLista, parametrosLista,'tarjetasDevitoLista.htm');
    });
	//lista de  clientes relacionados a un coorporativo
    $('#clienteID').bind('keyup',function(e){
    	var vacio='';
    	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "corpRelacionado";
		camposLista[1] = "clienteID";
		parametrosLista[0] = $('#corpRelacionado').val();
		parametrosLista[1] = $('#clienteID').val();
		if ( $('#corpRelacionado').val()!=vacio){
			lista('clienteID', '1', '4', camposLista, parametrosLista,'listaCliente.htm');
		}else{
			lista('clienteID', '1', '1','nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
			$('#nombre').val('');
		}
    });
	
	//lista de Cuentas del Cliente
	$('#cuentaAhoID').bind('keyup',	function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#clienteID').val();
		listaAlfanumerica('cuentaAhoID', '0', '9',camposLista, parametrosLista,'cuentasAhoListaVista.htm');
	});

		// Lista de Folios
	$('#folio').bind('keyup',function(e){
	var camposLista = new Array();
	var parametrosLista = new Array();
	camposLista[0] = "folio";
	parametrosLista[0] = $('#folio').val();
		if ($('#tarjetaNueva').is(':checked')){
			lista('folio', '2', '2', camposLista, parametrosLista,'listaFolios.htm');
			}else{
			lista('folio', '3', '3', camposLista, parametrosLista,'listaFolios.htm');
				 }
	});
		// lista de tipos de tarjetas
	 $('#tipoTarjetaDebID').bind('keyup',function(e){
	    	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "cuentaAhoID";
			camposLista[1] = "tipoTarjetaDebID";
			parametrosLista[0] = $('#cuentaAhoID').val();
			parametrosLista[1] = $('#tipoTarjetaDebID').val();
			lista('tipoTarjetaDebID', '1', '3', camposLista, parametrosLista,'tipoTarjetasDevLista.htm');
	    });

	$('#corpRelacionado').bind('keyup',function(e) { 
		lista('corpRelacionado', '3', '3', 'nombreCompleto', $('#corpRelacionado').val(), 'listaCliente.htm');
	});
	
	// ------------ Validaciones de la Forma
	$('#formaGenerica').validate({
		rules : {
			folio : {
				required : true,
				number: true
			},
			clienteID: {
				required: true
			}, 
			cuentaAhoID:{
				required: true
			},
			tipoTarjetaDebID:{
				'required':function() { return $('#tipoTransaccion').val()==1;},		
				number: true
			},
			costo:{
				required: true,
				number: true,
				maxlength:15
			},
			nombreClienteTar:{
				'required':function() { return $('#tipoTransaccion').val()==2;},	
			},
			nombreCliente:{
				'required':function() { return $('#tipoTransaccion').val()==1;},		
			},
			numeroTar:{
				'required':function() { return $('#tipoTransaccion').val()==2;},
				    number:true
			}
		},
	
		messages : {
			folio : {
				required : 'Especificar el folio',
				number:'solo Números'
			},	
			clienteID: {
				required: 'Especificar el Cliente'
			},
			cuentaAhoID:{
				required: 'Especificar la Cuenta de Ahorro'
			},
			tarjetaTipo:{
				required: 'Especificar el Tipo de  Tarjeta',
				number: 'solo Números'
			},
			
			descripcionTarjeta:{
				required:'Especificar Nombre de Tarjeta',	
			},
			costo:{
				required: 'Especificar el Costo',
				number: 'solo Números',
				maxlength:'La cantidad solo debe Tener 15 Dígitos'
			},
			numeroTar:{
				required: 'Especificar Número de Tarjeta de Débito',
			      number: 'Solo Números'
			}
		}
	});

	//------------ Validaciones de Controles -------------------------------------

		
	// Se Hace la consulta al coorporativo y su Nombre correspondiente 
	function consultaCorp() {
		var numCliente=$('#corpRelacionado').val();
			setTimeout("$('#cajaLista').hide();", 200);
		if ( !isNaN(numCliente) && Number(numCliente)>0) {
			clienteServicio.consulta(Number(catTipoConsultaCliente.corporativos), numCliente,"",function(cliente) {
				if (cliente != null) {
					$('#corpRelacionado').val(cliente.numero);
					$('#nombre').val(cliente.nombreCompleto);
				} else {
					deshabilitaBoton('solicitar', 'submit');
					alert("No Existe el Corporativo relacionado.");
					$('#corpRelacionado').val('');
					$('#nombre').val('');
					$('#corpRelacionado').focus();
				}
			});
		}else{
			$('#corpRelacionado').val('');
			 }
	}

	// funcion para consultar el nombre del cliente 
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var numCorp =$('#corpRelacionado').val();
		var vacio= '';
		var conCliente =1;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			if ($('#tarjetaNueva').is(':checked')){
				if  (numCorp == vacio){
					clienteServicio.consulta(1, numCliente, function(cliente) {
						if (cliente != null) {
							$('#nombreCliente').val(cliente.nombreCompleto);
							} else {
								alert("No Existe el Cliente");
								$('#nombreCliente').val('');
								$(jqCliente).focus();
								$(jqCliente).val('');
								deshabilitaBoton('solicitar','submit');
									}
						});
					
			}else{
			clienteServicio.consultaCorp(conCliente,numCliente ,numCorp ,function(cliente){
						if(cliente!=null){							
							$('#nombreCliente').val(cliente.nombreCompleto);	
							if ($('#folio').val() != 0){
								deshabilitaBoton('solicitar', 'submit');
							}
						}else{
							deshabilitaBoton('solicitar', 'submit');
							alert("El Cliente No esta Relacionado con el Coorporativo");
							$(jqCliente).focus();
							$(jqCliente).val('');
							$('#nombreCliente').val('');
							 }    						
				});
			}
			}else{
				clienteServicio.consulta(1, numCliente, function(cliente) {
					if (cliente != null) {
						$('#nombreCliente').val(cliente.nombreCompleto);
						} else {
							alert("No Existe el Cliente");
							$('#nombreCliente').val('');
							$(jqCliente).focus();
							$(jqCliente).val('');
							deshabilitaBoton('solicitar','submit');
						}
					});
				 }
		}else {
			$('#nombreCliente').val('');
			$('#cuentaAhoID').val('');
			$('#tipoCuenta').val('');
			$('#tipoTarjetaDebID').val('');
			$('#descripcionTarjeta').val('');
		}
	}

	// funcion que busca el nombre del tipo de cuenta 
	function consultaCtaAho(control) {
		var numCta = $('#cuentaAhoID').val();
		var numCliente= $('#clienteID').val();
		var tipConCampos= 4;
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != ''){
			if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
				if(cuenta!=null){	
					$('#tipoCuenta').val(cuenta.descripcionTipoCta);
					$('#clienteID').val(cuenta.clienteID);
					consultaCliente('clienteID');
					if ($('#folio').val() != 0){
						deshabilitaBoton('solicitar', 'submit');
					}
					}else{
						deshabilitaBoton('solicitar', 'submit');
						alert("Cuenta no asociada al Cliente...");
						$('#cuentaAhoID').val("");
						$('#tipoCuenta').val("");
						$('#cuentaAhoID').focus();
						 }
				});															
			}else {
				$('#tipoCuenta').val("");
				$('#tipoTarjetaDebID').val("");
				$('#descripcionTarjeta').val("");				
			}
		}else{
			alert("El Cliente esta vacio");
			$('#clienteID').focus();
			$('#cuentaAhoID').val('');
		}
	}
	function consultaTarjeta(idControl) {
		var jqTarjeta  = eval("'#" + idControl + "'");
		var tipoTarjeta = $(jqTarjeta).val();	
		var numCuenta =$('#cuentaAhoID').val();
		var conTarjeta =2;
		setTimeout("$('#cajaLista').hide();", 200);	
		if (numCuenta!=''){
			if(tipoTarjeta != '' && !isNaN(tipoTarjeta)){
			tipoTarjetaDebServicio.consultaTipoTarjeta(conTarjeta,tipoTarjeta, numCuenta,function(tarjeta) {
				if (tarjeta != null) {

					$('#tipoTarjetaDebID').val(tarjeta.tipoTarjetaDebID);
					$('#descripcionTarjeta').val(tarjeta.descripcion);
					$('#costo').val(tarjeta.montoComision);
					if ($('#tarjetaNueva').is(':checked')){
						if ($('#folio').val() != 0 ){
								deshabilitaBoton('solicitar', 'submit');
					    }else{
							habilitaBoton('solicitar', 'submit');
						     }
					}else{
						if ($('#estatus').val() =='S' ||$('#estatus').val() =='G'  ){
							deshabilitaBoton('solicitar','submit');
						   }else{
							   habilitaBoton('solicitar', 'submit');
						   }
						 }
					if(tarjeta.identificacionSocio=='S'){
						alert('El Tipo de Tarjeta es de Identificación.');
						$('#tipoTarjetaDebID').val('');
						$('#tipoTarjetaDebID').focus();
						$('#descripcionTarjeta').val('');
					}
				}else {
						deshabilitaBoton('solicitar', 'submit');
						alert("El Tipo de Tarjeta no esta Asociada al Tipo de Cuenta del Cliente");
						$('#tipoTarjetaDebID').val('');
						$('#tipoTarjetaDebID').focus();
						$('#descripcionTarjeta').val('');
						 }
				});
			}else {
				$('#descripcionTarjeta').val('');
			}
		}else{
			alert("La Cuenta está Vacia");
			$('#tipoTarjetaDebID').val('');
						
			$('#cuentaAhoID').focus();
		}
	}
	// consulta de datos de la tarjeta de debito
	function consultaDatosTarjetaDebito(idControl){
		var jqnumeroTarjeta  = eval("'#" + idControl + "'");
		var numTarjeta = $(jqnumeroTarjeta).val();	
		var conNumTarjeta = 15;
		var TarjetaBeanCon = {
				'tarjetaDebID'	:numTarjeta
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTarjeta != '' && !isNaN(numTarjeta)){
		tarjetaDebitoServicio.consulta(conNumTarjeta,TarjetaBeanCon,function(tarjetaDebito) {
			if(tarjetaDebito!=null){
				dwr.util.setValues(tarjetaDebito);					
				$('#costo').val(tarjetaDebito.montoComision);
				$('#descripcionTarjeta').val(tarjetaDebito.descripcion);
				$('#nombreClienteTar').val(tarjetaDebito.nombreTarjeta);
				$('#estatus').val(tarjetaDebito.estatus);
				if (tarjetaDebito.estatus == null ){
					habilitaControl('nombreClienteTar');	
					$('#status').val('SOLICITUD NUEVA');
					habilitaBoton('solicitar','submit');
					deshabilitaBoton('cancelar','submit');
				}
				if (tarjetaDebito.estatus =='C'){
					$('#status').val('CANCELAD0');
					habilitaBoton('solicit	ar','submit');
					deshabilitaBoton('cancelar','submit');
				
				}
				if (tarjetaDebito.estatus =='R'){
					$('#status').val('RECIBIDO');
					deshabilitaBoton('solicitar','submit');
					deshabilitaBoton('cancelar','submit');
				}
				if (tarjetaDebito.estatus =='G'){
					$('#status').val('GENERADO');
					deshabilitaBoton('solicitar','submit');
					deshabilitaBoton('cancelar','submit');
				//	alert("La Tarjeta ya fue Solicitada");
					//$('#folio').focus();
				}
				if (tarjetaDebito.estatus =='S'){
					$('#status').val('SOLICITADO');
					deshabilitaControl('nombreClienteTar');	
					deshabilitaBoton('solicitar','submit');
					habilitaBoton('cancelar','submit');
					//alert("La Tarjeta ya fue Solicitada");
				}
				consultaCtaAho(tarjetaDebito.cuentaAhoID);
				$('#tipoTarjetaDebID').val(tarjetaDebito.tipoTarjetaDebID);
				consultaTarjeta('tipoTarjetaDebID');
				deshabilitaControl('clienteID');
				deshabilitaControl('cuentaAhoID');

			}else{
				limpiarFormularioParaFolio();
				deshabilitaBoton('solicitar', 'submit');
				alert("El Número de Tarjeta no Existe");
				$('#numeroTar').focus();
				}
			});		
		}
	 }	

	// funcion que consulta los datos de un folio
	 function consultaDatosFolio (idControl ) {
		var jqNumFol  = eval("'#" + idControl + "'");
		var numFolio = $(jqNumFol).val();	
		var NumeroFoliosBeanCon = {
			'folio'	:numFolio
			};
		var conFolios =2;
		var conFoliosRepo=3;
		setTimeout("$('#cajaLista').hide();", 200);
		if ( !isNaN(numFolio) && Number(numFolio)>0 && esTab) {
			if ($('#tarjetaNueva').is(':checked')){
				solicitudTarDebServicio.consulta(conFolios, NumeroFoliosBeanCon, function(foliosTar) {
					if (foliosTar != null) {

						foliosTar.folio=numFolio;
						$('#corpRelacionado').val(foliosTar.corpRelacionadoID);
						$('#clienteID').val(foliosTar.clienteID);
						$('#cuentaAhoID').val(foliosTar.cuentaAhoID);
						$('#tipoTarjetaDebID').val(foliosTar.tarjetaTipo);
						$('#status').val(foliosTar.estatus);
						$('#nombreClienteTar').val(foliosTar.nombreTarjeta);
						$('#relTar').val(foliosTar.relacion);
						deshabilitaBoton('solicitar', 'submit');
						habilitaBoton('cancelar', 'submit');
						consultaCorp();
						//consultaCliente(foliosTar.clienteID);
						consultaCtaAho(foliosTar.cuentaAhoID);
					    consultaTarjeta('tipoTarjetaDebID');
						deshabilitaControl('clienteID');
						deshabilitaControl('cuentaAhoID');
						deshabilitaControl('corpRelacionado');
						deshabilitaControl('nombre');
						deshabilitaControl('nombreCliente');
						deshabilitaControl('tipoTarjetaDebID');
						deshabilitaControl('tipoCuenta');
						deshabilitaControl('numeroTar');
						deshabilitaControl('nombreClienteTar');
						deshabilitaBoton('solicitar', 'submit');
						deshabilitaControl('relTar');	
						if (foliosTar.estatus =='C'){
							$('#status').val('CANCELAD0');
						}
						if (foliosTar.estatus =='R'){
							$('#status').val('RECIBIDO');
						}
						if (foliosTar.estatus =='G'){
							$('#status').val('GENERADO');
							deshabilitaBoton('solicitar','submit');
						}
						if (foliosTar.estatus =='S'){
							$('#status').val('SOLICITADO');
							deshabilitaBoton('solicitar','submit');
						}
						if (foliosTar.estatus =='S' || foliosTar.estatus =='G'){
							deshabilitaBoton('solicitar','submit');
							//alert("La Tarjeta ya fue Solicitada");
						//	$('#folio').focus();
						}
						if ($('#folio').val() == 0){
							habilitaControl('clienteID');
							habilitaControl('cuentaAhoID');
							habilitaControl('corpRelacionado');
							habilitaControl('tipoTarjetaDebID');
							habilitaControl('numeroTar');
							habilitaControl('nombreCliente');
							habilitaControl('relTar');	
							$('#status').val('SOLICITUD NUEVA');
							limpiarFormularioSolicitaTarjeta();
						}
					} else {
						deshabilitaBoton('solicitar', 'submit');
						alert("No existe el Folio");
						limpiarFormularioSolicitaTarjeta();
						$('#folio').focus();
					   	   }
			});
			
			}else{
				solicitudTarDebServicio.consulta(conFoliosRepo, NumeroFoliosBeanCon,function(foliosTar) {
					if (foliosTar != null) {
						foliosTar.folio=numFolio;
						//$('#nombreCliente').val(foliosTar.nombreCompleto);
						$('#corpRelacionado').val(foliosTar.corpRelacionadoID);
						$('#clienteID').val(foliosTar.clienteID);
						$('#cuentaAhoID').val(foliosTar.cuentaAhoID);
						//$('#descripcionTarjeta').val(foliosTar.descripcion);
						$('#costo').val(foliosTar.costo);
						$('#numeroTar').val(foliosTar.tarjetaDebAntID);
						$('#tipoTarjetaDebID').val(foliosTar.tarjetaTipo);
						$('#status').val(foliosTar.estatus);
						$('#relTar').val(foliosTar.relacion);
						$('#nombreClienteTar').val(foliosTar.nombreTarjeta);
						esTab= true;
						consultaCliente('clienteID');
						consultaCtaAho('cuentaAhoID');
						consultaCorp();
						if (foliosTar.estatus == null ){
							$('#status').val('SOLICITUD NUEVA');
							habilitaBoton('solicitar','submit');
						}
						if (foliosTar.estatus =='C'){
							$('#status').val('CANCELAD0');
						
						}
						if (foliosTar.estatus =='R'){
							$('#status').val('RECIBIDO');
						}
						if (foliosTar.estatus =='G'){
							$('#status').val('GENERADO');
							deshabilitaBoton('solicitar','submit');
						//	alert("La Tarjeta ya fue Solicitada");
							//$('#folio').focus();
						}
						if (foliosTar.estatus =='S'){
							$('#status').val('SOLICITADO');
							deshabilitaControl('nombreClienteTar');	
							habilitaBoton('cancelar','submit');
							deshabilitaBoton('solicitar','submit');
							//alert("La Tarjeta ya fue Solicitada");
						}
						deshabilitaControl('numeroTar');
						deshabilitaControl('relTar');
						deshabilitaControl('nombreClienteTar');
						/*if (foliosTar.estatus =='S'||foliosTar.estatus =='G'){
							deshabilitaBoton('solicitar','submit');
							alert("La Tarjeta ya fue Solicitada");
							$('#folio').focus();
			
						}*/
					/*	if ($('#folio').val() == 0){
							habilitaControl('numeroTar');
							limpiarFormularioSolicitaTarjeta();
						}*/
					
					} else {
						deshabilitaBoton('solicitar', 'submit');
						alert("No existe el Folio");
						limpiarFormularioSolicitaTarjeta();
						$('#folio').focus();
						   } 
				});
				
			}
		}
	}
	// funcion que limpia el formulario
	function limpiarFormularioSolicitaTarjeta(){
		$('#status').val('');
		$('#clienteID').val('');
		$('#cuentaAhoID').val('');
		$('#corpRelacionado').val('');
		$('#nombre').val('');
		$('#nombreCliente').val('');
		$('#tipoCuenta').val('');
		$('#tipoTarjetaDebID').val('');
		$('#descripcionTarjeta').val('');
		$('#costo').val('');
		$('#numeroTar').val('');
		$('#estatus').val('');
		$('#relTar').val('');		
	}

	function limpiarFormularioParaFolio(){
		$('#clienteID').val('');
		$('#cuentaAhoID').val('');
		$('#corpRelacionado').val('');
		$('#nombre').val('');
		$('#nombreCliente').val('');
		$('#tipoCuenta').val('');
		$('#tipoTarjetaDebID').val('');
		$('#descripcionTarjeta').val('');
		$('#costo').val('');
		$('#numeroTar').val('');
		$('#nombreClienteTar').val('');	
		$('#relTar').val('');
		$('#estatus').val('');
	}
});//fin

// funcion que se ejecuta cuando el resultado fue un éxito
function funcionExitoSolicTar(){
	deshabilitaControl('descripcionTarjeta');
	deshabilitaBoton('solicitar', 'submit');
	$('#clienteID').val('');
	$('#cuentaAhoID').val('');
	$('#corpRelacionado').val('');
	$('#nombre').val('');
	$('#nombreCliente').val('');
	$('#tipoCuenta').val('');
	$('#tipoTarjetaDebID').val('');
	$('#descripcionTarjeta').val('');
	$('#costo').val('');
	$('#numeroTar').val('');
	$('#estatus').val('');
	$('#status').val('');
	$('#nombreClienteTar').val('');	
}

// funcion que se ejecuta cuando el resultado fue error
// diferente de cero
	function funcionErrorSolicTar(){
		$('#costo').formatCurrency({
			positiveFormat: '%n',  
			negativeFormat: '%n',
			roundToDecimalPlace: 2	
		});		

/*	deshabilitaControl('descripcionTarjeta');
	deshabilitaControl('nombreClienteTar');
	deshabilitaBoton('solicitar', 'submit');
	$('#clienteID').val('');
	$('#cuentaAhoID').val('');
	$('#corpRelacionado').val('');
	$('#nombre').val('');
	$('#nombreCliente').val('');
	$('#tipoCuenta').val('');
	$('#tipoTarjetaDebID').val('');
	$('#descripcionTarjeta').val('');
	$('#costo').val('');
	$('#numeroTar').val('');
	$('#estatus').val('');
	$('#status').val('');
	$('#nombreClienteTar').val('');*/	
	
}

function Validador(e) {
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46) {
		if (key==8|| key == 46)	{
			return true;
		}
		else
		return false;
	}
}

//función para cargar los valores de la lista recibe el
//el control que es el campo donde secargara el valor y el valorCompleto es un valor extra. que se podra usar en cualquier campo
function cargaValorListaTarjetaDeb(control, valor,valorCompleto) {	
	consultaSesion();
	jqControl = eval("'#" + control + "'");
	$(jqControl).val(valor);
	$(jqControl).focus();
	setTimeout("$('#cajaLista').hide();", 200);
	$('#numeroTar').val(valorCompleto);	
}