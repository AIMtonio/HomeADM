var tipoInstitucion = 0;	
$(document).ready(function() {	
		
		
	consultaInstitucion();
	

	

	
	
	   function consultaInstitucion(){
		   
		   var tipoConsulta = 9;
		   var bean = { 
					'empresaID'		: 1		
				};
			
			paramGeneralesServicio.consulta(tipoConsulta, bean,function(Institucion){
				   tipoInstitucion = Institucion.valorParametro;
				     if(tipoInstitucion==3){
					   $('#contenidoRegulatorio').load('regulatorioD084203Vista.htm',function(response, status, xhr){
							if(status == 'error') {
								$('#contenidoRegulatorio').html(response);
							}
							validaRegulatorioInstitucion();
						});
					   
				   }else {
					   $('#contenidoRegulatorio').load('regulatorioD084206Vista.htm',function(response, status, xhr){
							if(status == 'error') {
								$('#contenidoRegulatorio').html(response);
							}
							validaRegulatorioInstitucion();
						});
				   }
			   });
	   }



	   function validaRegulatorioInstitucion(){
	   	var mensajeRegulatorio = '<div style="border: 1px solid #f3f5f6;width: 250px;margin: 0 auto;"><div style="background: #1d4e77;color: #fff;padding: 5px 10px;border-radius: 5px 5px 0px 0px;">Mensaje:</div> '
					+ '<div style="background: #f3f5f6;padding: 5px 10px;text-align: justify;">Estimado Usuario el Regulatorio seleccionado no Aplica para su Tipo de Institución.</div> '
					+ ' <div class="footer"></div></div>';

		//" 
		 var regulatorio = {
				   'clave' : 'D0842'
		   }
		   var numConsulta = 1;
		   

	   	regulatorioInsServicio.consulta(numConsulta,regulatorio,function(valida){
			   if(valida.aplica == 'N'){
				  $('#tblRegulatorio').html(mensajeRegulatorio);
			   }
		   });
		   
	   }
	  
	}); // fin ready

	
  