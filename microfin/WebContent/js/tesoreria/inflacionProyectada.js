$(document).ready(function(){
	esTab = true;
	
	var parametrosBean = consultaParametrosSession();  	
	var varfechaAplicacion = parametrosBean.fechaAplicacion;
	
	var catTipoTransaccionInflacion = {
			'actualiza':'1'
	}; 
	
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
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'valorGatAct','exito','error');
        
	}
    });
	
	$('#formaGenerica').validate({
  		rules: {
  			valorGatHis: {
  				required:	true,
  				number: 	true
  			},
  			valorGatAct:{
  				required:	true,
  				number:		true
  			}
  		},
  		messages: {
  			valorGatHis: {
  				required: 	'Especifique Valor histórico ',
  				number:		'Solo Números'
  			},
  			valorGatAct:{
  				required:	'Especifique Valor Actual',
  				number:		'Solo Números'
  			}
  		}
	});
	$('#valorGatHis').val('0.00');
	deshabilitaBoton('actualiza','submit');

	consultaInflacion();
	$('#valorGatAct').focus();
	
	$('#valorGatAct').blur(function(){		
		
		if(this.value!=''){
			if(!isNaN(this.value)){				
				consultaInflacion();
				habilitaBoton('actualiza','submit');
				$('#actualiza').focus();
			}else{
				$('#valorGatAct').val('');
				$('#valorGatAct').focus();
				deshabilitaBoton('actualiza','submit');
			}			
		}
		
	});
	
	$('#actualiza').click(function(){
		$('#tipoTransaccion').val(catTipoTransaccionInflacion.actualiza);
	});
	
});

function consultaInflacion(){
	var consultaPrincipal=1;
	inflacionProyecServicio.consulta(consultaPrincipal,function(inflacion){
		if(inflacion!=null){				
			$('#valorGatHis').val(inflacion.valorGatHis);							
		}			
	});	
}
function exito(){
	consultaInflacion();
	$('#valorGatAct').val('');
	$('#valorGatAct').focus();	
}
function error(){
	
}
