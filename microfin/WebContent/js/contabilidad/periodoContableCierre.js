$(document).ready(function() {
	// Definicion de Constantes y Enums	
	
	esTab = true;
	var catTipoTransaccionPeriodo= {
  		'Trancerrar':3  
	};

	var catTipoListaPeriodoConta = { 
		'porPeriodo':2
	};
	
	var parametroBean = consultaParametrosSession();	

   agregaFormatoControles('formaGenerica');
   
	//------------ Metodos y Manejo de Eventos -----------------------------------------
			
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#ejercicioRe').hide();
	$('#ejercicioGlo').hide();
	
	// deshabilitaBoton('cerrar', 'submit');
	
	
	deshabilitaBoton('cerrar', 'submit');

	
	$.validator.setDefaults({
           submitHandler: function(event) { 
        grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','numeroEjercicio',"exitoConocimiento","falloConocimiento"); 
				
			$('#ejercicioRe').show();
				$('#ejercicioGlo').show();
			}
    });			
	
		
	$('#cerrar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionPeriodo.Trancerrar);
		
	});
	$('#cerrar').attr('tipoTransaccion', '3');
	
	

	$('#numeroPeriodo').click(function() {
  		if($('#numeroPeriodo').val() == 0){	
			deshabilitaBoton('cerrar', 'submit');
  		}else {habilitaBoton('cerrar', 'submit'); }
	});
	consultaEjercicio();

	$('#formaGenerica').validate({
		rules: {
			numeroEjercicio:  'required',
			numeroPeriodo: 	'required'
		},
		messages: { 			
		 	numeroEjercicio: 'Ingrese Numero de Ejercicio',
			numeroPeriodo	: 'Ingrese Numero de Periodo'
		}		
	});
	
	function consultaEjercicio() {
		var conVigente =1;
		var ejercicioContableBean = {
      	'tipoEjercicio':0,
      	'inicioEjercicio':'1900-01-01',
      	'finEjercicio':'1900-01-01'
      };		
		setTimeout("$('#cajaLista').hide();", 200);	
		ejercicioContableServicio.consulta(conVigente,ejercicioContableBean,function(ejercicio){

					if(ejercicio!=null){							
						$('#finEjercicio').val(ejercicio.finEjercicio);				
						$('#numeroEjercicio').val(ejercicio.numeroEjercicio);
				  		consultaPeriodos();

					}else{
						alert("No Existe Ejercicio Vigente");
					}    						
		});

	}

});




function consultaPeriodos() {			
			dwr.util.removeAllOptions('numeroPeriodo'); 
		var PeriodoBeanCon = {
			'numeroEjercicio': $('#numeroEjercicio').val()
		};
		dwr.util.addOptions('numeroPeriodo',{0:'SELECCIONAR'});
		periodoContableServicio.listaCombo(PeriodoBeanCon,4, function(periodos){
		dwr.util.addOptions('numeroPeriodo', periodos, 'numeroPeriodo', 'finPeriodo');
		});
}


function exitoConocimiento(){
	consultaPeriodos();
	deshabilitaBoton('cerrar', 'submit');

}


function falloConocimiento(){
	
}