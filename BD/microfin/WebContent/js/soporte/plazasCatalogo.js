$(document).ready(function() {
	esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionPlaza = {  
  		'agrega':'1',
  		'modifica':'2'	};
	
	var catTipoConsultaPlaza = {
  		'principal'	: 1,
  		'foranea'	: 2
	};	
	$('#plazaID').focus();
		//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');

	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	

	$.validator.setDefaults({
            submitHandler: function(event) { 
                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','plazaID'); 
            }
    });				
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionPlaza.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionPlaza.modifica);
	});	

	$('#plazaID').bind('keyup',function(e){
		lista('plazaID', '2', '1', 'nombre', $('#plazaID').val(), 'listaPlazas.htm');
	});
	
	$('#plazaID').blur(function() { 
  		validaPlaza(this.id); 
	});
	
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			
			plazaID: {
				required: true
			},
	
			nombre: {
				required: true,
				maxlength: 100
			},	
			
			plazaCLABE: { 
				required: true ,
				number: true,
				maxlength:3
			},	
		},
		messages: {
			
		
			plazaID: {
				required: 'Especificar No.'
			},
			
			nombre: {
				required: 'Especificar Nombre',
				maxlength: 'Máximo 100 Caracteres'
			},
			
			plazaCLABE: {
				required: 'Especificar CLABE',
				maxlength: 'Máximo 3 Caracteres',
				number: 'solo Numeros'
			}
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
		function validaPlaza(control) {
		var numplaza = $('#plazaID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numplaza != '' && !isNaN(numplaza) && esTab){
			
			if(numplaza=='0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','clienteID' )

			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var plazaBeanCon = { 
  				'plazaID':$('#plazaID').val()
  				
				};
				
				plazasServicio.consulta(catTipoConsultaPlaza.principal,plazaBeanCon,function(plaza) {
						if(plaza!=null){
							dwr.util.setValues(plaza);	
								
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');													
						}else{
							
							mensajeSis("No Existe la Plaza");
							deshabilitaBoton('modifica', 'submit');
   							deshabilitaBoton('agrega', 'submit');
							$('#plazaID').focus();
							$('#plazaID').select();	
																			
							}
				});
						
			}
												
		}
	}
	
	
		


		
});
	