$(document).ready(function() {
	
	esTab = false;
	
	$("#arrendaID").focus();
	
	$('#arrendaID').blur(function() {
		if ($("#autorizar").is(":disabled") && esTab) {
 			$("#arrendaID").focus();
 		}
		if(isNaN($('#arrendaID').val())) {
			$('#arrendaID').val("");
			$('#arrendaID').focus();
			inicializaForma('formaGenerica','arrendaID');
			deshabilitaBoton('autorizar', 'submit');
		} else {
			funcionConsultaArrendamiento(this.id);
		}
	});
	
	$('#autorizar').focus(function() {
	 	esTab = false;
	});
	
	$('#autorizar').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#autorizar').blur(function() {
		if (esTab) {
			$("#arrendaID").focus();
		}
	});
	
	deshabilitaBoton('autorizar', 'submit');
	
	agregaFormatoControles('formaGenerica');
	
	$(':text').focus(function() {
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
			deshabilitaBoton('autorizar', 'submit');
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','autorizar');
		}
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#arrendaID').bind('keyup',function(e){
		lista('arrendaID', '2', '3', 'arrendaID', $('#arrendaID').val(), 'listaArrendamientos.htm');
	});
	

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			arrendaID: 'required',			
		},
		
		messages: {
			arrendaID: 'Especifique número de arrendamiento',
		}		
	});
});

function funcionConsultaArrendamiento(idControl) {
	var varJqArrendamiento = eval("'#" + idControl + "'");
	var varArrendamiento = $(varJqArrendamiento).val();
	var varTipoCon = 4;
	
	var varMesaControlArrendamientoBean = {
		'arrendaID': varArrendamiento
	};

	setTimeout("$('#cajaLista').hide();", 200);
	
	if(varArrendamiento != '' && !isNaN(varArrendamiento) ){
		varArrendamiento = parseInt(varArrendamiento); 
		arrendamientoServicio.consultaDetalleProducto(varTipoCon, varMesaControlArrendamientoBean, function(varArrendamientos) {
			if(varArrendamientos != null){
				$('#arrendaID').val(varArrendamientos.arrendaID);							
				$('#clienteID').val(varArrendamientos.clienteID); 						
				$('#nombreCliente').val(varArrendamientos.nombreCliente);
				$('#productoArrendaID').val(varArrendamientos.productoArrendaID);
				$('#nombreCorto').val(varArrendamientos.nombreCorto);
				$('#fechaAutoriza').val(varArrendamientos.fechaAutoriza);
				$('#usuarioAutoriza').val(varArrendamientos.usuarioAutoriza);
				$('#nombreUsuario').val(varArrendamientos.nombreUsuario);
				$('#estatus').val(varArrendamientos.estatus);
				$('#montoArrenda').val(varArrendamientos.montoArrenda);
				$('#ivaMontoArrenda').val(varArrendamientos.ivaMontoArrenda);
				$('#fechaApertura').val(varArrendamientos.fechaApertura);
				$('#montoEnganche').val(varArrendamientos.montoEnganche);
				$('#frecuenciaPlazo').val(varArrendamientos.frecuenciaPlazo);
				$('#montoSeguroAnual').val(varArrendamientos.montoSeguroAnual);
				$('#plazo').val(varArrendamientos.plazo);
				$('#tipoPagoSeguro').val(varArrendamientos.tipoPagoSeguro);
				$('#montoFinanciado').val(varArrendamientos.montoFinanciado);
				$('#diaPagoProd').val(varArrendamientos.diaPagoProd);
				agregaFormatoControles('formaGenerica');
				if ($('#estatus').val() == 'GENERADO') {
					habilitaBoton('autorizar', 'submit');
				} else {
					deshabilitaBoton('autorizar', 'submit');
				}
				$("#autorizar").focus();
			}else{ 
				mensajeSis("El arrendamiento no existe");
				$(varJqArrendamiento).focus();
				deshabilitaBoton('autorizar', 'submit');
				inicializaForma('formaGenerica');
			}
		});
	}
}
