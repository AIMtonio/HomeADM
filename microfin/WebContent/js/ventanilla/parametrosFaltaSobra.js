$(document).ready(function(){	
	
	var catTipoTransaccionParametros = {
			'alta' : '1',
			'modificacion' : '2'			
	};
	$.validator.setDefaults({
	    submitHandler: function(event) { 
	    		grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','sucursalID'); 
	      }
	 });
	deshabilitaBoton('guardar', 'submit');
	agregaFormatoControles('formaGenerica');
	
	$('#sucursalID').bind('keyup',function(e){
		lista('sucursalID', '2', '4', 'nombreSucurs',$('#sucursalID').val(), 'listaSucursales.htm');	       
	});
	$('#sucursalID').blur(function() {
		  consultaSucursal(this.id);			   		  
	});
	
	$('#formaGenerica').validate({			
		rules: {				
			sucursalID: {
				required: true,					
			},
			
			montoMaximoSobra:{
				numeroPositivo: true,
				required: true,
			},
			montoMaximoFalta:{
				numeroPositivo: true,
				required: true,
			},				
		},		
		messages: {
			sucursalID: {
				required: 'Indique el Número de la Sucursal'					
			},					
			montoMaximoSobra:{
				numeroPositivo: 'Solo Números positivos',
				required: 'Indique el Monto Máximo Sobrante'	
			},	
			montoMaximoFalta:{
				numeroPositivo: 'Sólo Números positivos',
				required: 'Indique el Monto Máximo Faltante'	
			},
		}		
	});
	function consultaSucursal(idControl) {	
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();	
		var conSucursal=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
				if(sucursal!=null){					
					$('#nombreSucursal').val(sucursal.nombreSucurs);
					consultaParametros('sucursalID');
					habilitaBoton('guardar', 'submit');
				}else{
					alert("No Existe la Sucursal");
					$(jqSucursal).focus();
					inicializaForma('formaGenerica', 'sucursalID');
					deshabilitaBoton('guardar', 'submit');
				}    						
			});
		}
	}
	
	function consultaParametros(idControl) {	
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();	
		var conParametros = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		var parametrosBean	={
				'sucursalID'	: numSucursal
		};
		
		if(numSucursal != '' && !isNaN(numSucursal)){
			paramFaltaSobraServicio.consulta(conParametros,parametrosBean,function(parametros) {
				if(parametros!=null){		
					
					$('#montoMaximoSobra').val(parametros.montoMaximoSobra);
					$('#montoMaximoFalta').val(parametros.montoMaximoFalta);
					$('#tipoTransaccion').val(catTipoTransaccionParametros.modificacion);
				}else{
					$('#tipoTransaccion').val(catTipoTransaccionParametros.alta);
					$('#montoMaximoSobra').val('');
					$('#montoMaximoFalta').val('');																		
				}    						
			});
		}
	}
		
		
}); // Fin 