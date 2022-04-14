/*JS PARA EL COBRO DE ANUALIDAD DE TAJERTA DE DEBITO EN VENTANILLA  */
var montoAnualidad = 0;
$(document).ready(function() {
$('#fechSistema').val(parametroBean.fechaAplicacion);	
  $('#tarjetaDebID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "tarjetaDebID";		
		parametrosLista[0] = $('#tarjetaDebID').val();
		lista('tarjetaDebID', '1', '14', camposLista, parametrosLista,'tarjetasDevitoLista.htm');
    });
  

  $('#numCtaTarjetaDeb').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#numCtaTarjetaDeb').val();		
			lista('numCtaTarjetaDeb', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}				       
	});	
	  
	$('#tarjetaDebID').blur(function() {		
		consultaDatosTarjetaDebito(this.id);
	});
	$('#numCtaTarjetaDeb').blur(function() {		
		consultaDatosTarjetaDebito(this.id);
	});
	
//	$('#clienteIDCorporativo').blur(function() {		
//		consultaNombreCliente(this.id);
//	});
	
	function consultaDatosTarjetaDebito(idControl){
		var jqControl  = eval("'#" + idControl + "'");
		var Var_CuentaAhoID=0;
		var numTarjeta =0;
		var fechaProximoPag  = '';
		if(idControl == 'tarjetaDebID'){
			numTarjeta	=$(jqControl).val();		
		}else{
			 Var_CuentaAhoID = $(jqControl).val();			
		}
		setTimeout("$('#cajaLista').hide();", 200);
		inicializaCantidadEntradaSalida();
		var conNumTarjeta=19;
		var fechaSistema = parametroBean.fechaSucursal;
		var TarjetaBeanCon = {
				'tarjetaDebID'	:numTarjeta,
				'cuentaAhoID'	:Var_CuentaAhoID
			};
		
		
		if((numTarjeta != '' && numTarjeta >0) ||( Var_CuentaAhoID != '' && Var_CuentaAhoID >0) ){
		tarjetaDebitoServicio.consulta(conNumTarjeta,TarjetaBeanCon,function(tarjetaDebito) {
			if(tarjetaDebito!=null){
				var cliente = tarjetaDebito.clienteID;
				if(cliente>0){
					listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, tarjetaDebito.cuentaAhoID, 0);
					if(listaPersBloqBean.estaBloqueado!='S'){
						expedienteBean = consultaExpedienteCliente(cliente);
						if(expedienteBean.tiempo<=1){
							if (tarjetaDebito.identificacionSocio=="S"){
								alert("La Tarjeta es de Tipo Identificación");
								$('#tarjetaDebID').val("");
								$('#tarjetaDebID').focus();
							}else{
								$('#tarjetaDebID').val(tarjetaDebito.tarjetaDebID);
								$('#estatusTarjetaDeb').val(tarjetaDebito.estatus);
								$('#numCtaTarjetaDeb').val(tarjetaDebito.cuentaAhoID);				
								$('#clienteIDTarjeta').val(tarjetaDebito.clienteID);
								$('#nombreCteTarjeta').val(tarjetaDebito.nombreCompleto);
								$('#tipoTarjeta').val(tarjetaDebito.tipoCuentaID);
								$('#descTipoTarjeta').val(tarjetaDebito.desTipoTarjeta);
								
								
								if (tarjetaDebito.comisionAnual == null || tarjetaDebito.comisionAnual == '') {
									tarjetaDebito.comisionAnual  = 0;
								}
								$('#fechProximoPago').val(tarjetaDebito.fechaProximoPag);
								fechaProximoPag = tarjetaDebito.fechaProximoPag;
		
								if(fechaProximoPag > fechaSistema){
									alert(' La Fecha de Pago de Comision Anual es: '+ fechaProximoPag );					
									inicializaCamposTarjeta();
									$('#tarjetaDebID').focus();
									$('#tarjetaDebID').val('');				
								}else{						
									$('#montoComisionTarjeta').val(tarjetaDebito.comisionAnual);
									$('#ivaComisionTarjeta').val(tarjetaDebito.comisionAnual * parametroBean.ivaSucursal);		
									$('#totalComisionTD').val(parseFloat(tarjetaDebito.comisionAnual) + $('#ivaComisionTarjeta').asNumber());				
									$('#clienteIDCorporativo').val(tarjetaDebito.corpRelacionado);
									$('#cantEntraMil').focus();
									agregaFormatoMoneda('formaGenerica');
									montoAnualidad = tarjetaDebito.comisionAnual;
									totalEntradasSalidasGrid();
								}
								if(tarjetaDebito.corpRelacionado >0 ){
									$('#cteCorpTr').show();
									consultaNombreCliente('clienteIDCorporativo');
								}else {
									$('#cteCorpTr').hide();
								}										
							}
						} else {
							alert('Es necesario Actualizar el Expediente del Cliente para Continuar.');
							$(jqControl).focus();
							inicializaCamposTarjeta();
						}
					} else {
						alert('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						$(jqControl).focus();
						inicializaCamposTarjeta();
					}
				}
			}else{
				alert("La Tarjeta de Débito no existe o tiene un estatus diferente de Vigente o Bloqueada ");
				$(jqControl).focus();
				inicializaCamposTarjeta();
			}
			});				
		}
	 }
	
	function consultaNombreCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =1;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
						if(cliente!=null){		
							$('#nombreCteCorpoTarjeta').val(cliente.nombreCompleto);							
						}else{
							alert("No Existe el Cliente");
							$(jqCliente).focus();
						}    						
				});
			}
	}
		
});// fin Document

function imprimeTicketAnualidadTarjeta(){
	var imprimeTicketAnualidadTarjetaBean ={
		    'folio' 	       	:$('#numeroTransaccion').val(),
	        'tituloOperacion'  	:'ANUALIDAD TARJETA DEBITO',
		    'clienteID'         :$('#clienteIDTarjeta').val(),
		    'nombreCliente'     :$('#nombreCteTarjeta').val(),
		    'montoAnualidad'    :$('#montoComisionTarjeta').val(),
		    
		    'IVAMonto'			:$('#ivaComisionTarjeta').val(),
		    'totalComisionTD'	:$('#totalComisionTD').val(),
		    'montoRecibido'		:$('#sumTotalEnt').val(),
		    'cambio'			:$('#sumTotalSal').val(),
		    'tarjetaDebito'		:$('#tarjetaDebID').val(),
		    'numeroCuenta'		:$('#numCtaTarjetaDeb').val()
		};					
	imprimeTicketAnualidad(imprimeTicketAnualidadTarjetaBean);
}

function inicializaCamposTarjeta(){
		$('#tarjetaDebID').val('');
		$('#estatusTarjetaDeb').val('');
		$('#numCtaTarjetaDeb').val('');
		$('#montoComisionTarjeta').val('');
		$('#clienteIDTarjeta').val('');
		$('#nombreCteTarjeta').val('');
		$('#clienteIDCorporativo').val('');
		$('#tipoTarjeta').val('');
		$('#descTipoTarjeta').val('');
		$('#ivaComisionTarjeta').val('');
		$('#totalComisionTD').val('');
				
	}