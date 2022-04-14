$(document).ready(function() {
		esTab = true;
 
		//Definicion de Constantes y Enums  
	var catTipoTransaccionParamSeguimiento = {
  		'agrega':'1',
  		'modifica':2
  		}; 
	
	var catTipoConsultaParamEscala = {
  		'principal'	: 1,
  		'comboBox' 	: 2
	};		 
		//------------ Metodos y Manejo de Eventos -----------------------------------------
		
	agregaFormatoControles('formaGenerica');
	 deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');
    
    $.validator.setDefaults({
        submitHandler: function(event) { 
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoPersona', 'exitoOperacion', 'falloOperacion');
        }
    });	
    
	 
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
 
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	 $('#agrega').click(function() {
		 if($('#monedaComp').val()==0){
			 alert("Especifique la Moneda de Comparación");
			event.preventDefault();
		 }else{
			$('#tipoTransaccion').val(catTipoTransaccionParamSeguimiento.agrega);

		 }
	});
	        	
  	$('#modifica').click(function() {
  		 if($('#monedaComp').val()==0){
			 alert("Especifique la Moneda de Comparación");
			event.preventDefault();
		 }else{
			$('#tipoTransaccion').val(catTipoTransaccionParamSeguimiento.modifica);  								
		 }
	});
	
  	$('#tipoPersona').blur(function() {		
  		deshabilitaBoton('modifica', 'submit');
  	    deshabilitaBoton('agrega', 'submit');	
		$('#nivelSeguimien option[value=0]').attr('selected','true');

  	 });
  	$('#tipoInstrumento').blur(function() {		
  		deshabilitaBoton('modifica', 'submit');
  	    deshabilitaBoton('agrega', 'submit');	
		$('#nivelSeguimien option[value=0]').attr('selected','true');

  	 });
	$('#nacCliente').blur(function() {		
  		deshabilitaBoton('modifica', 'submit');
  	    deshabilitaBoton('agrega', 'submit');
		$('#nivelSeguimien option[value=0]').attr('selected','true');
  	 });
  	
  	$('#nivelSeguimien').blur(function() {	
  		if($('#nivelSeguimien').val()!=0 && $('#tipoPersona').val()!=0 && $('#tipoInstrumento').val()!=0 && $('#nacCliente').val()!=0 ){
  	  		$('#montoInferior').val('');
  	  		$('#monedaComp option[value=0]').attr('selected','true');
  			validaParamSeguimiento();
  		}else{
  			$('#montoInferior').val('');
  			$('#monedaComp option[value=0]').attr('selected','true');
  			deshabilitaBoton('modifica', 'submit');
  	  	    deshabilitaBoton('agrega', 'submit');
  		}
  		
  	    
  		
	});
  	
	
	
	//------------ Validaciones de la Forma -------------------------------------		
	$('#formaGenerica').validate({					
		rules: {				
			tipoPersona: {
				required: true,
			},		
			tipoInstrumento: {
				required:true,
			},
			nacCliente: {
				required:true,
			},
			nivelSeguimien: {
				required:true,
			},
			montoInferior: {
				required:true,
			},	
			monedaComp: {
				required: true	,	
			}
		},		
		messages: {
			tipoPersona: {
				required: 'Especifique.',
			},					
			
			tipoInstrumento: {
				required:'Especifique',
			},
			nacCliente: {
				required:'Especifique',
			},
			nivelSeguimien: {
				required:'Especifique',
			},
			montoInferior: {
				required: 'Especifique el Monto Inferior',		
			},
			monedaComp: {
				required: 'Especifique',		
			}
			
			
		}
	});
	//------------ Validaciones de Controles -------------------------------------
	
		function validaParamSeguimiento() {  
			// inicializaForma('formaGenerica','tipoPersona');
		setTimeout("$('#cajaLista').hide();", 200);
		
		var tipoPerson = $('#tipoPersona').val();
		var tipoInstrum = $('#tipoInstrumento').val();
		var nacCliente = $('#nacCliente').val();
		var nivel = $('#nivelSeguimien').val();
		
		esTab=true;
		if(tipoPerson != '' && esTab && tipoInstrum != '' && monedaComp != '' && nivel != ''){
		
				deshabilitaBoton('agrega', 'submit');		
				habilitaBoton('modifica', 'submit');
				var paramsParSegto = {
				    'tipoPersona' :  tipoPerson,
				    'tipoInstrumento' :tipoInstrum,
				    'nacCliente' :nacCliente,
				    'nivelSeguimien' : nivel 
				};
				paramSegtoServicio.consulta(1,paramsParSegto,function(paramsSeg) { 
						if(paramsSeg!=null){
							
							dwr.util.setValues(paramsSeg);	 
							$('#monedaComp').val(paramsSeg.monedaComp).selected = true;
							$('#tipoPersona').val(paramsSeg.tipoPersona).selected = true;
							$('#tipoInstrumento').val(paramsSeg.tipoInstrumento).selected = true;
							$('#nacCliente').val(paramsSeg.nacCliente).selected = true;
							$('#nivelSeguimien').val(paramsSeg.nivelSeguimien).selected = true;
							$('#montoInferior').val(paramsSeg.montoInferior);
							
						}else{
							habilitaBoton('agrega', 'submit');												
							deshabilitaBoton('modifica', 'submit');
			 			}
				});		
			}
		
		
	}
		
	 	
		
		
});

function exitoOperacion(){	
	 deshabilitaBoton('modifica', 'submit');
	 deshabilitaBoton('agrega', 'submit');
		$('#tipoPersona option[value=0]').attr('selected','true');
		$('#tipoInstrumento option[value=0]').attr('selected','true');
  		$('#nacCliente option[value=0]').attr('selected','true');
		$('#nivelSeguimien option[value=0]').attr('selected','true');
  		$('#monedaComp option[value=0]').attr('selected','true');
  		$('#montoInferior').val('');
  		


}
function falloOperacion(){
	
}
