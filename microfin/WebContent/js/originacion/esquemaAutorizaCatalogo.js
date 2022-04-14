$(document).ready(function() {
	parametros = consultaParametrosSession();
	$('#producCreditoID').focus();	
	
		

	//------------ Metodos y Manejo de Eventos -----------------------------------------
		agregaFormatoControles('formaGenerica');	
	 
	
	
	$('#producCreditoID').change(function() {		
		consultaGridEsquema();
		consultaGridOrganoAutoriza();
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	
	consultaProductosCredito();
	
	function consultaProductosCredito() {			
		dwr.util.removeAllOptions('producCreditoID'); 		
		dwr.util.addOptions('producCreditoID', {0:'SELECCIONAR'});						     
		productosCreditoServicio.listaCombo(16, function(producto){
		dwr.util.addOptions('producCreditoID', producto, 'producCreditoID', 'descripcion');
		});
	}

	
	
});// cerrar

function consultaGridEsquema(){			
	agregaFormatoControles('divGridEsquema');
	var productoID=$('#producCreditoID').val();
	var params = {};
	params['tipoLista'] = 2;
	params['producCreditoID'] = productoID;
	
	$.post("esquemaAutorizaGridVista.htm", params, function(data){
		
		if(data.length >0) {
			agregaFormatoControles('divGridEsquema');
			$('#divGridEsquema').html(data);
			$('#divGridEsquema').show();
			
			$("#numeroEsquema").val($('input[name=consecutivoID]').length);	
			var productoID=$('#producCreditoID').val();
			$("#producID").val(productoID);	
			
			$('#grabarEsquema').click(function() {			
				$('#tipoTransaccion').val(catTipoTranEsquema.alta);
				guardaGridEsquema();
			});
			
		}else{				
			$('#divGridEsquema').html("");
			$('#divGridEsquema').hide(); 
		}
	});
}


function consultaGridOrganoAutoriza(){	
	var productoID=$('#producCreditoID').val();
	var params = {};
	params['tipoLista'] = 3;
	params['productoCreditoID'] = productoID;
	
	$.post("esquemaOrganoAutorizaGridVista.htm", params, function(data){
		
		if(data.length >0) {
			$('#divGridFirmas').html(data);
			$('#divGridFirmas').show();	
		
			if($('#numeroOrganoAutoriza').val() == 0){
				$('#listaGarantias').html("");
				$('#listaGarantias').hide();			
			}	
			
			$("#numeroOrganoAutoriza").val(consultaFilasOrganoAutoriza());	
			var prodCredito=$('#producCreditoID').val();
			$("#productoCredID").val(prodCredito);
		
			
			cargaListaOrganos();
			cargaListaEsquemas();
			cargaListaFirmas();
			
			$('#grabarOrgano').click(function() {	
				$('#tipoTransaccionOrgano').val(catTipoTranOrgano.alta);
				guardaGridOrganoAutoriza();
			});
								
		}else{				
			$('#divGridFirmas').html("");
			$('#divGridFirmas').hide(); 
		}
	});
}





	
	
	

// -- FUNCIONES ---------------------- 
