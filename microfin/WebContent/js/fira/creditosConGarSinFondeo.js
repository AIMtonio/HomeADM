var creditosSinFondeoObj = {};


creditosSinFondeoObj.listaCreditosSinFondeo =  function() {
	$("#listaCredGarSinFondeo").html("");
	
	var creditosBean = {
		'tipoLista'		: 46
	}
	
	$.post("creditosConGarSinFondeoGrid.htm", creditosBean, function(data) {
		if (data.length > 0) {
			$("#listaCredGarSinFondeo").html(data);
			$("#listaCredGarSinFondeo").show();
			agregaFormatoControles('formaGenerica');

			if($('#num_creditos').asNumber() == 0){
				
				mensajeSis('No Existen Cr&eacute;ditos Pendientes por Procesar');
			}

			deshabilitaBoton('procesar');
			deshabilitaBoton('cancelar');


		} else {
			$("#listaCredGarSinFondeo").html("");
			$("#listaCredGarSinFondeo").show();
		}



	});
}


creditosSinFondeoObj.activaProcesarCancelar = function(idControl,tipoGarantia){
	var numFila = idControl.split('_')[1];

	switch(tipoGarantia){
		case 'fega':
			if($('#todos_fega').is(':checked')){
				$('#todos_fega').attr('checked',false);
			}

			break;
		case 'fonaga':
			if($('#todos_fonaga').is(':checked')){
				$('#todos_fonaga').attr('checked',false);
			}
			break;
		case 'cancelado':
			if($('#todos_cancelado').is(':checked')){
				$('#todos_cancelado').attr('checked',false);
			}
			creditosSinFondeoObj.cancelaActivaGarantias(idControl);
			break;
	}


	creditosSinFondeoObj.validaTipoGarantia(idControl);
	



	creditosSinFondeoObj.bloqueaHabilitaBotones();
	
}


creditosSinFondeoObj.validaTipoGarantia = function(idControl){
	var numFila = idControl.split('_')[1];

	if($('#fega_'+numFila).is(':checked') & $('#fonaga_'+numFila).is(':checked')){
		$('#tipoGarantia_'+numFila).val(3);
	}else
		if($('#fega_'+numFila).is(':checked')){
			$('#tipoGarantia_'+numFila).val(1);
		}else
			if($('#fonaga_'+numFila).is(':checked')){
				$('#tipoGarantia_'+numFila).val(2);
			}else
				if($('#cancelado_'+numFila).is(':checked')){
					$('#tipoGarantia_'+numFila).val(4);
				}else{
					$('#tipoGarantia_'+numFila).val("");
				}


}

creditosSinFondeoObj.cancelaActivaGarantias = function(idControl){
	var nunFila = idControl.split('_')[1];

	if($('#'+idControl).is(':checked')){
		$('#fega_'+nunFila).attr('checked',false);
		$('#fonaga_'+nunFila).attr('checked',false);

		$('#todos_fega').attr('checked',false);
		$('#todos_fonaga').attr('checked',false);


		deshabilitaControl('fega_'+nunFila);
		deshabilitaControl('fonaga_'+nunFila);
	}else{
		habilitaControl('fega_'+nunFila);
		habilitaControl('fonaga_'+nunFila);
	}



	

}



creditosSinFondeoObj.seleccionarTodos = function(idControl,tipoGarantia){
	var checked = false;
	var controlID = '';
	var idRenglon = 0;
	if($('#'+idControl).is(':checked')){
		checked = true;	
	}
	


	$('.renglon').each(function(id,renglon){	
		idRenglon = renglon.id.split('_')[1];
		controlID = tipoGarantia+"_"+idRenglon;

		if($('#'+controlID).is(':disabled')){
			$('#'+controlID).attr('checked',false);
		}else{
			$('#'+controlID).attr('checked',checked);
		}

		if (tipoGarantia == 'cancelado'){
			creditosSinFondeoObj.cancelaActivaGarantias(controlID);
		}

		creditosSinFondeoObj.validaTipoGarantia(controlID);

	});


	

	creditosSinFondeoObj.bloqueaHabilitaBotones();

}


creditosSinFondeoObj.bloqueaHabilitaBotones = function(){
	if($('.cl_fonaga').is(':checked') || $('.cl_fega').is(':checked') || $('.cl_cancelado').is(':checked')){
		habilitaBoton('procesar');
	}else{
		deshabilitaBoton('procesar');
	}
}

creditosSinFondeoObj.exitoTransaccion = function(){
	console.log('Reconsultar grid para eliminar procesados');
	creditosSinFondeoObj.listaCreditosSinFondeo();
}


creditosSinFondeoObj.errorTransaccion = function(){
	console.log('No fue posible procesar los resultados');
}

$(document).ready(function() {
	
	creditosSinFondeoObj.listaCreditosSinFondeo();
	
	$('#formaGenerica').validate({

		rules: {

		},
		messages: {
		
		},
		submitHandler: function(event) {
				
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID'
													,'creditosSinFondeoObj.exitoTransaccion','creditosSinFondeoObj.errorTransaccion');
			
		}
	});
	
}); // End Document Ready