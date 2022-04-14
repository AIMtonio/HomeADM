$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionPuestos = {  
  		'agrega':'1',
  		'modifica':'2'	};
	
	var catTipoConsultaPuesto = {
  		'principal'	: 1,
  		'foranea'	: 2
	};	
	
		//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');
    $('#puestoRelID').focus();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	

	$.validator.setDefaults({
		submitHandler: function(event) { 
        grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'puestoRelID', 'funcionExito', 'funcionError');
    }
    });				
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionPuestos.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionPuestos.modifica);
	});	

	$('#puestoRelID').bind('keyup',function(e){
		lista('puestoRelID', '2', '1', 'descripcionPuesto', $('#puestoRelID').val(), 'listaPuestosRelacionado.htm');
	});
	
	$('#puestoRelID').blur(function() { 
  		validaPuesto(this.id); 
	});
	
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			
			puestoRelID: {
				required: true
			},
	
			descripcionPuesto: {
				required: true,
				maxlength: 100
			}
		},
		messages: {
			
		
			puestoRelID: {
				required: 'Especificar Clave'
			},
			
			descripcionPuesto: {
				required: 'Especificar Descripción',
				maxlength: 'Máximo 100 Caracteres'
			}
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
		function validaPuesto(control) {
		var numpuesto = $('#puestoRelID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numpuesto != '' && !isNaN(numpuesto) && esTab){
			
			if(numpuesto=='0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','puestoRelID' )

			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var puestoBeanCon = { 
  				'puestoRelID':$('#puestoRelID').val()
  				
				};
				
				puestosRelacionadoServicio.consulta(catTipoConsultaPuesto.principal,puestoBeanCon,function(puesto) {
						if(puesto!=null){
							dwr.util.setValues(puesto);	
								
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');													
						}else{
							
							mensajeSis("No Existe el Puesto");
							deshabilitaBoton('modifica', 'submit');
   						deshabilitaBoton('agrega', 'submit');
								$('#puestoRelID').focus();
								$('#puestoRelID').select();	
																			
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
	$('#puestoRelID').focus();
	$('#descripcionPuesto').val("");
	$('#contenedorMsg').css("width","150");
}
/**
 * Funcion de error que se ejecuta después de grabar
 * la transacción y ésta marca error.
 */
function funcionError(){
	$('#contenedorMsg').css("width","150");
}
