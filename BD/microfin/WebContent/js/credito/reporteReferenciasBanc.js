$(document).ready(function() {
	esTab = true;

	var parametroBean = consultaParametrosSession();  
	//Definicion de Constantes y Enums  

	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('generar','submit');
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#creditoID').bind('keyup',function(e){
		lista('creditoID', '2', '1', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');

	});

	$('#creditoID').blur(function() { 
		validaCredito(this.id);

	});


	$('#generar').click(function() {	
			var credito = $('#creditoID').val();	 
			var tr=1;
			
			$('#ligaGenerar').attr('href','reporteReferencias.htm?creditoID='+credito+'&tipoReporte='+tr);
		
	});	
	//------------ Validaciones de la Forma -------------------------------------	

	$('#formaGenerica').validate({

		rules: {

			creditoID: {
				required: true
			},			
		},
		messages: {
			creditoID: {
				required: 'Especificar Numero',
			},
		}		
	});


	//------------ Validaciones de Controles -------------------------------------

	function validaCredito(control) {
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) ){
			var creditoBeanCon = { 
					'creditoID':$('#creditoID').val()
			};			
			
				creditosServicio.consulta(13,creditoBeanCon,function(credito) {
					if(credito!=null){
						$('#clienteID').val(credito.clienteID);
						consultaCliente('clienteID');
						habilitaBoton('generar', 'button');
					}else{
						alert("No Existe el Credito");
						$('#creditoID').focus();
						limpiarPantalla();
						deshabilitaBoton('generar','submit');

					}
				});
			

		}
	}


	function limpiarPantalla(){
		$('#clienteID').val('');
		$('#nombreCliente').val('');	

	}


	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero);						
					$('#nombreCliente').val(cliente.nombreCompleto);
				}else{
					alert("No Existe el Cliente");
					limpiarPantalla();
					$('#creditoID').focus();	
					deshabilitaBoton('generar','submit');
				}    	 						
			});
		}
	}

});