$(document).ready(function() {
		esTab = true;
		
	//Definicion de Constantes y Enums  
	var catTipoTransaccionSucursal = {
  		'agrega':'1',
  		'modifica':'2',
  		
	};
	var catTipoConsultaSucursal = {
  		'principal':'1',
  		'foranea':'2'
	};	
	

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	
	$(':text').focus(function() {	
	 	esTab = false;
	});	
	
		$.validator.setDefaults({
            submitHandler: function(event) { 
                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','sucursalID'); 
            }
    });			
		    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionSucursal.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionSucursal.modifica);
	});		
	
	$('#sucursalID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalID', '2', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
		
	$('#sucursalID').blur(function() {
  		validaSucursal(this);
	});		

			
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			sucursalID: {
				//required: false
			},
			nombreSucurs: {
				required: true,
				minlength: 3
			},
			tipoSucursal: {
				required: true,
				minlength: 3
			},
				
		},
		messages: {
			sucursalID: {
				//required: 'Especificar numero'
			},
		
			nombreSucurs: {
				required: 'Especificar Nombre',
				minlength: 'Al menos 3 Caracteres'
			},
			
			tipoSucursal: {
				required: 'Especificar Tipo',
				minlength: 'Al menos 3 Caracteres'
			},

			
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	function validaSucursal(control) {
		var numSucursal = $('#sucursalID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
			
			if(numSucursal=='0'){
				
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				limpiaForm($('#formaGenerica'));
				
			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');			
				sucursalesServicio.consultaSucursal(1,numSucursal,function(sucursal) {
						if(sucursal!=null){
						dwr.util.setValues(sucursal);	
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');													
						}else{
							limpiaForm($('#formaGenerica'));
							alert("No Existe la Sucursal");
							deshabilitaBoton('modifica', 'submit');
   							deshabilitaBoton('agrega', 'submit');
								$('#sucursalID').focus();
								$('#sucursalID').select();	
																			
							}
				});
								
			}
												
		}
	}	

});
	
	/*function validaSucursalForanea(controlOrigen, controlDestino) {
		var jqSucursal = eval("'#" + controlOrigen + "'");
		var jqDestino = eval("'#" + controlDestino + "'");
		var numSucursal = $(jqSucursal).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
			sucursalesServicio.consultaSucursal(catTipoConsultaSucursal.foranea,
											 numSucursal,function(sucursal) {
						if(sucursal!=null){
							$(jqDestino).val(sucursal.nombreSucurs);							
						}else{
							alert("No Existe la Sucursal");
												}    						
			});
		}
	}
		
});*/
	