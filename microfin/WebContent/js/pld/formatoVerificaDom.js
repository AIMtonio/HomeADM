$(document).ready(function() {
	$('#clienteID').focus();
	inicializaForma('formaGenerica', '');
	
	deshabilitaBoton('generar', 'button');
	


	$('#clienteID').bind('keyup',function(e){
		if($('#clienteID').val().length<3){		
			$('#cajaLista').hide();
		}else{
			lista('clienteID', '2', '9', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
		}
	});
	
	$('#clienteID').blur(function(){
		consultaCliente(this.id);
		
	});
	
	$('#generar').click(function(){
		generaPdf();
	});
	
	//--------------------- FUNCIONES -------------------------------------
	function validaSucursal() {
		var principal=1;
		numSucursal=$('#sucursalID').val();
		
		if(numSucursal != '' && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(principal,numSucursal,function(sucursal) { 
				if(sucursal!=null){
					$('#nombreSucursal').val(sucursal.nombreSucurs);
				} 
			});
		}
	}
	
	//----------- Funcion consultaCliente, para acceder a la información mostrada en Pantalla ---------------
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var clienteID = $(jqCliente).val();
		var conCliente = 7;
		var rfcCliente = '';
		
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(clienteID != '' && !isNaN(clienteID)){
			clienteServicio.consulta(conCliente,clienteID,rfcCliente,function(cliente) {
				if(cliente!=null){							
					$('#nombreCliente').val(cliente.nombreCompleto);

					switch(cliente.estatus){
						case 'A': 
							$('#estatusCliente').val('ACTIVO');		
							break;
						case 'I':
							$('#estatusCliente').val('INACTIVO'); 
							break;
					}

					$('#sucursalID').val(cliente.sucursalOrigen);
					//$('#nombreSucursal').val(cliente.sucursalOrigen);
					validaSucursal();
					habilitaBoton('generar', 'button');
					$('#generar').focus();
					

				}else{
					alert("No Existe el " + $('#valCliente').val()+".");					
					$('#nombreCliente').val('');
					$('#estatusCliente').val('');		
					$('#sucursalID').val('');
					$('#nombreSucursal').val('');
					$(jqCliente).focus();
					$(jqCliente).select();
					deshabilitaBoton('generar', 'button');
				}    						
			});
		}
	}
	
	

	//--------------------- Funcion  para Generar Reporte  ---------------------------------
	function generaPdf() {	
		var tipoReporte= parseInt(1);
		var clienteID = $('#clienteID').val();
		$('#ligaGeneraRep').attr('href','generaRepFormatoVerificaDom.htm?clienteID='+clienteID);	
	}

	//-------------------- Validaciones ------------------------------------
	$('#formaGenerica').validate({
		rules: {
			 clienteID: {
				 required: true,			
			 }
		},
		messages: {
			clienteID: {
				 required:'Especifique el Cliente.'				
			 }
		}
	});
	
	
	
	
});