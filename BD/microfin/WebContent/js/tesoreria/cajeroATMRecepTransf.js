var cont = 0;
$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();
	var catTipoTransTransfer = {
			'recepcionTransfer' : 2
	};	
	var catTipoListaMoneda = {
			'principal': 3
	};
	var EstatusInactivo	= 'I';
	var EstatusActivo	= 'A';
	var EstatusCajero	='';
	var ActivarBoton	='S';
	var CajeroDestino	='';
	cargaMonedas();
	CargaValoresSesion();
	

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	$('#cajeroTransfID').focus();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	deshabilitaBoton('aceptar', 'submit');
	$.validator.setDefaults({
	      submitHandler: function(event) {	   		 
	    		  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','polizaID',
	    				  'exitoRecepcionTransfer','falloRecepcionTransfer');
	      }
	});		

	$('#cajeroDestinoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();	
		
		camposLista[0] = "cajeroID";
		camposLista[1] = "nombreCompleto";		  
		parametrosLista[0] = parametros.numeroUsuario;
		parametrosLista[1] = $('#cajeroDestinoID').val();		  
		lista('cajeroDestinoID', '1', '2', camposLista,parametrosLista, 'listaCajerosATM.htm');	       
	});		

	
	$('#cajeroTransfID').change(function() {   	
		validaTransferencia(this.id);  		  		
   	});
	
  	$('#referencia').blur(function() {   	
  		$('#cantSalMil').focus();  		
   	});
  	
  	$('#aceptar').click(function(){
		$('#tipoTransaccion').val(catTipoTransTransfer.recepcionTransfer);
	});	
  	
  	$('#impPoliza').click(function(){
		var poliza = $('#polizaID').val();	 
		var fecha = parametros.fechaSucursal;	
		window.open('RepPoliza.htm?polizaID='+poliza+'&fechaInicial='+fecha+
				'&fechaFinal='+fecha+'&nombreUsuario='+parametroBean.nombreUsuario);

	});
	
//-----------------Validacion de la Forma--------------
	$('#formaGenerica').validate({
		rules: {			
			cajeroDestinoID : {
				required: true
			},
			cajeroTransfID : {
				required: true
			},
			
		},		
		messages: {			
			cajeroDestinoID : {
				required: 'Especifique el Cajero'
			},
			cajeroTransfID : {
				required: 'Especifique la Transferencia'
			},
		
		}
	});
	
//---------------------funciones-------------------	


	
	// Consulta los datos de una transferencia
	function validaTransferencia(idControl){
		var jqTranferencia  = eval("'#" +idControl + "'");
		var transferenciaID = $(jqTranferencia).val();			
										
		var catCajerosBean = { 
				'cajeroTransferID':transferenciaID,
				'cajeroOrigenID':'',
				'cajeroDestinoID':$('#cajeroDestinoID').val()
		};					
		
		 if(transferenciaID != '' && transferenciaID >0){
			 limpiaFormEnvioTransferATM();
			 cajeroATMTransfServicio.consulta(1,catCajerosBean,function(transferenciaBean) {
				if(transferenciaBean != null){					
					$('#sucursalID').val(transferenciaBean.sucursalID);
					$('#cajeroOrigenID').val(transferenciaBean.cajeroOrigenID);
					$('#monedaID').val(transferenciaBean.monedaID).selected=true;
					$('#fecha').val(transferenciaBean.fecha);
					$('#cantidad').val(transferenciaBean.cantidad);					
					consultaSucursal('sucursalID', 'descSucursal');
					consultaCaja('cajeroOrigenID');
					consultaCajeroATM(transferenciaBean.cajeroDestinoID);
					 $('#impPoliza').hide();
				
					
				}else{								
					mensajeSis("Transferencia no válida");
					deshabilitaBoton('aceptar', 'submit');				
					inicializaForma('formaGenerica','cajeroDestinoID' );		
				}
			});
		 }else{
			 limpiaFormEnvioTransferATM();
			 deshabilitaBoton('aceptar', 'submit');
		 }
		
	}

	function consultaCajeroATM(cajeroID) {			
									
		var catCajerosBean = { 
				'cajeroID':cajeroID	  				
		};						
		 if(cajeroID != '' ){
			catCajerosATMServicio.consulta(1,catCajerosBean,function(cajeroATM) {
				if(cajeroATM != null){					
					$('#ubicacion').val(cajeroATM.ubicacion);
					$('#sucursalCajero').val(cajeroATM.sucursalID);	
					consultaSucursal('sucursalCajero', 'desSucursal');					
					EstatusCajero	=cajeroATM.estatus;											
					if(cajeroATM.estatus == EstatusInactivo){						
						mensajeSis("El Cajero se encuentra Inactivo");	
						ActivarBoton ='N';
					}else if(cajeroATM.usuarioID	 != parametros.numeroUsuario){
						mensajeSis("El Cajero ATM pertenece a otro Usuario");
						ActivarBoton ='N';
					}
					
					if (EstatusCajero != EstatusActivo && ActivarBoton == 'S'){
						deshabilitaBoton('aceptar', 'submit');
						
					}else{
						habilitaBoton('aceptar', 'submit');
					}
				}else{								
					mensajeSis("El Cajero no existe");
					deshabilitaBoton('aceptar', 'submit');				
					inicializaForma('formaGenerica','cajeroDestinoID' );		
				}
			});
		 }
	}
	
	// Consulta sucursal
	function consultaSucursal(idControl, descSucursal) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();	
		var conSucursal=1;
		setTimeout("$('#cajaLista').hide();", 200);		 
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
				if(sucursal!=null){							
					$('#'+descSucursal).val(sucursal.nombreSucurs);
				}else{
					mensajeSis("No Existe la Sucursal"); 
					$(jqSucursal).val("");
					$(jqSucursal).focus();
					$('#'+descSucursal).val("");
				}    						
			});
		}
	}	
	// consulta Usuario
	function consultaUsuario(usuarioID, nombreUsuario){
		var conForanea = 2;
		var usuarioBean = {
			'usuarioID' : usuarioID
		};
		if(usuarioID != '' && !isNaN(usuarioID)){
			usuarioServicio.consulta(conForanea, usuarioBean, function(usuario){
				if (usuario != null){					
					$('#'+nombreUsuario).val(usuario.nombreCompleto);					
				}else{
					mensajeSis('No Existe el Usuario');					
					$('#'+nombreUsuario).val('');					
				}
			});
		}
	}
	
	// Combo de Monedas
  	function cargaMonedas(){
		monedasServicio.listaCombo(catTipoListaMoneda.principal, function(monedas){
			dwr.util.removeAllOptions('monedaID');
			for (var i = 0; i < monedas.length; i++){
				$('#monedaID').append(new Option(monedas[i].descripcion, parseInt(monedas[i].monedaID), false, false));
			}
			$('#monedaID').val(1);
		});
	}
  	// Consulta informacion de la caja
  	function consultaCaja(idControl){
		var jqCajaVentanilla = eval("'#" + idControl + "'");
		var numCajaID = $(jqCajaVentanilla).val();
		var conPrincipal = 1;		// es una consulta Con_CajasTransfer 
		var CajasVentanillaBeanCon = {
  			'cajaID': numCajaID
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCajaID != '' && !isNaN(numCajaID)){
			cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanCon ,function(cajasVentanilla){
				if(cajasVentanilla != null){
					if(cajasVentanilla.tipoCajaID = 'CA'){
						$('#descCaja').val('CAJA DE ATENCION AL PUBLICO');
					}else if(cajasVentanilla.tipoCajaID = 'CP'){
						$('#descCaja').val('CAJA PRINCIPAL DE SUCURSAL');
					}else if(cajasVentanilla.tipoCajaID = 'BG'){
						$('#descCaja').val('BOBEDA CENTRAL');
					}
					
				}else{
					mensajeSis("La Caja No Existe.");
				}
			});
		}
	}
  	function CargaValoresSesion(){
		$('#usuarioID').val(parametros.numeroUsuario);
		consultaUsuario(parametros.numeroUsuario, 'nombreUsuario');
		consultaTransferenciasPendientes();
  	}
		
});

// Función de Exito en la transaccion
function exitoRecepcionTransfer() {	 	
	 limpiaFormEnvioTransferATM();	
	 deshabilitaBoton('aceptar','submit');
	 $('#cajeroTransfID').val('').selected =true;
	 $('#impPoliza').show();
	 consultaTransferenciasPendientes('');
}

// Funcion que se ejecuta despues de un error en la transacion
function falloRecepcionTransfer(){
	$('#impPoliza').hide();
}

function limpiaFormEnvioTransferATM(){
	$('#sucursalCajero').val('');
	$('#desSucursal').val('');
	$('#ubicacion').val('');
	$('#sucursalID').val('');
	$('#descSucursal').val('');
	$('#cajeroOrigenID').val('');
	$('#descCaja').val('');
	$('#cantidad').val();
	$('#fecha').val('');
	$('#cantidad').val('');	

}

// lista de Transferencias pendientes por Cajero Destino
function consultaTransferenciasPendientes(idControl){
		var cajeroATMTransfer = {
			'cajeroTransferID' : 0,
			'cajeroDestinoID'	 : 0,
			'usuarioID'	 : parametros.numeroUsuario
		}; 	
	
	
	cajeroATMTransfServicio.listaCombo(2, cajeroATMTransfer, function(trasnferencias){
		dwr.util.removeAllOptions('cajeroTransfID');
		dwr.util.addOptions( 'cajeroTransfID', {'':'Selecciona'});
		dwr.util.addOptions('cajeroTransfID', trasnferencias, 'cajeroTransferID', 'descripcionTransfer');			
	});
	}