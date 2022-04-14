$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionConceptoBalanza = {  
  		'agrega':'1',
  		'modifica':'2'	,
  		'elimina':'3'};
	
	var catTipoConsultaConceptoBalanza = {
  		'foranea'	: 2
  		
	};	
	
		//------------ Msetodos y Manejo de Eventos -----------------------------------------
	 deshabilitaBoton('agrega', 'submit');
    deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('elimina', 'submit');

	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
            submitHandler: function(event) { 
                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','conBalanzaID'); 
            }
    });	
    	
	$('#conBalanzaID').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#conBalanzaID').val();
			listaAlfanumerica('conBalanzaID', '1', '1', camposLista, parametrosLista, 'listaConceptoBalanza.htm');
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionConceptoBalanza.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionConceptoBalanza.modifica);
	});	
	
	$('#elimina').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionConceptoBalanza.elimina);
	});	

	
	
	$('#conBalanzaID').blur(function() { 
  		validaConceptoBalanza(this.id); 
	});
	
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			
			conBalanzaID: {
				required: true,
				number: true,
				maxlength: 12,
				minlength: 12
			},
	
			descripcion: {
				required: true
			},
			
		},		
		messages: {
			
		
			conBalanzaID: {
				required: 'Especificar No.',
				number: 'solo numeros',
				maxlength: 'maximo 12 numeros',
				minlength: 'minimo 12 numeros'
			},
			
			descripcion: {
				required: 'Especificar Descripción'
			},
			
			
		}		
	});
	
	
	
	//------------ Validaciones de Controles -------------------------------------
	
		function validaConceptoBalanza(control) {
		var numconcepto = $('#conBalanzaID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numconcepto != '' && !isNaN(numconcepto) && esTab){

			if(numconcepto=='0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('elimina', 'submit');
				inicializaForma('formaGenerica','conBalanzaID' );
				$('#conBalanzaID').focus();
				$('#conBalanzaID').select();	
   			
   	         
			} else {
				deshabilitaBoton('agrega', 'submit'); 
				habilitaBoton('modifica', 'submit');
				habilitaBoton('elimina', 'submit');
				var conceptoBeanCon = { 
  				'conBalanzaID':$('#conBalanzaID').val()
  				
  				
				};
				 
				conceptoBalanzaServicio.consulta(catTipoConsultaConceptoBalanza.foranea,conceptoBeanCon,function(conceptos) {
						if(conceptos!=null){
							dwr.util.setValues(conceptos);	
							
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');
							habilitaBoton('elimina', 'submit');													
						
						}else{
							
							deshabilitaBoton('modifica', 'submit');
   						habilitaBoton('agrega', 'submit');
   						deshabilitaBoton('elimina', 'submit');
   						inicializaForma('formaGenerica','conBalanzaID' );
   										
							}
				});
						
			}
												
		}
	}
	
});
	