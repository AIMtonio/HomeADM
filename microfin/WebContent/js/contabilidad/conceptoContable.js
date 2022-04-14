$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	
	var catTipoTransaccionConceptoCon = { 
  		'agrega':'1',
  		'modifica':'2',
  		'elimina':'3'	}; 
	
	var catTipoListaConConta = {
		'principal':1
	};

	var catTipoConsultaConConta = {
		'principal' : 1
	};
	deshabilitaBoton('agrega', 'submit');
   deshabilitaBoton('modifica', 'submit');
   deshabilitaBoton('elimina', 'submit');
		
	//------------ Metodos y Manejo de Eventos -----------------------------------------
		
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	

	$('#conceptoContableID').bind('keyup',function(e){
		if(this.value.length >= 3){
			
			var camposLista = new Array();
			 var parametrosLista = new Array();
			 camposLista[0] = "descripcion";			 			 
			 parametrosLista[0] = $('#conceptoContableID').val();			
			lista('conceptoContableID', 3, catTipoListaConConta.principal, camposLista,
					 parametrosLista, 'listaConceptosConta.htm');
		}
	});
		
	$('#conceptoContableID').blur(function() {
		var conceptoConta = $('#conceptoContableID').val();		
		var tipoConsulta = catTipoConsultaConConta.principal;		
		setTimeout("$('#cajaLista').hide();", 200);
		
		var conceptoContableBean = {
      	'conceptoContableID':conceptoConta
      };		
		
		if(conceptoConta != '' && !isNaN(conceptoConta) && esTab){
			
			conceptoContableServicio.consulta(tipoConsulta, conceptoContableBean, function(conceptoContable){
				
				if(conceptoContable!=null){
					$('#conceptoContableID').val(conceptoContable.conceptoContableID);							
					$('#descripcion').val(conceptoContable.descripcion);
					habilitaBoton('modifica', 'submit');
					habilitaBoton('elimina', 'submit');
					deshabilitaBoton('agrega', 'submit');
				}else{
					$('#descripcion').val('');										
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('elimina', 'submit');
					habilitaBoton('agrega', 'submit');
										
				}
			});
		}
	});
	
	//------------ Validaciones de la Forma -----------------------------------------	
	$.validator.setDefaults({
			submitHandler: function(event) { 
         	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','conceptoContableID'); 
			}
    });			
	
	$('#formaGenerica').validate({
		rules: {
			conceptoContableID: { 
				minlength: 1
			},
			descripcion: { 
				minlength: 2,
				required: true
			}		
		},
		messages: { 			
		 	conceptoContableID: {
				minlength: 'Al menos un Caracter'
			},
			descripcion: {
				minlength: 'Al menos dos Caracteres',
				required: 'Especificar la Descripcion'
			}
		}
	});	

	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionConceptoCon.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionConceptoCon.modifica);
	});	 

	$('#elimina').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionConceptoCon.elimina);
	});

	
});
