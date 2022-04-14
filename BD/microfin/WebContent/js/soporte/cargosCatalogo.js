$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionCargos = {  
  		'agrega':'1',
  		'modifica':'2'	};
	
	var catTipoConsultaCargo = {
  		'principal'	: 1,
  		'foranea'	: 2
	};	
	
		//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');
    $('#cargoID').focus();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	

	$.validator.setDefaults({
		submitHandler: function(event) { 
        grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'cargoID', 'funcionExito', 'funcionError');
    }
    });				
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCargos.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCargos.modifica);
	});	

	$('#cargoID').bind('keyup',function(e){
		lista('cargoID', '2', '1', 'descripcionCargo', $('#cargoID').val(), 'listaCargos.htm');
	});
	
	$('#cargoID').blur(function() { 
  		validaCargo(this.id); 
	});
	
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			
			cargoID: {
				required: true
			},
	
			descripcionCargo: {
				required: true,
				maxlength: 100
			}
		},
		messages: {
			
		
			cargoID: {
				required: 'Especificar Clave'
			},
			
			descripcionCargo: {
				required: 'Especificar Descripción',
				maxlength: 'Máximo 100 Caracteres'
			}
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
		function validaCargo(control) {
		var numcargo = $('#cargoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numcargo != '' && !isNaN(numcargo) && esTab){
			
			if(numcargo=='0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','cargoID' )

			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var cargoBeanCon = { 
  				'cargoID':$('#cargoID').val()
  				
				};
				
				cargosServicio.consulta(catTipoConsultaCargo.principal,cargoBeanCon,function(cargo) {
						if(cargo!=null){
							dwr.util.setValues(cargo);	
								
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');													
						}else{
							
							alert("No Existe el Cargo");
							deshabilitaBoton('modifica', 'submit');
   						deshabilitaBoton('agrega', 'submit');
								$('#cargoID').focus();
								$('#cargoID').select();	
																			
							}
				});
						
			}
												
		}
	}
	
	
		


		
});
	
/**
 * Función de  de éxito que se ejecuta después de grabar
 * la transacción y ésta fue exitosa.
 */
function funcionExito(){
	$('#cargoID').focus();
	$('#descripcionCargo').val("");
	$('#contenedorMsg').css("width","150");
}
/**
 * Funcion de error que se ejecuta después de grabar
 * la transacción y ésta marca error.
 */
function funcionError(){
	$('#contenedorMsg').css("width","150");
}
