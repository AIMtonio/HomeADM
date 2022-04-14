var tipoInstitucion = 0;	
var tipoConsulta = 9;
var bean = { 
		'empresaID'		: 1		
	};

var catTipoIns = { 
			'socap'			: 6,		
			'sofipo'		: 3,		
	};
		

function validaRegulatorioInstitucion(){
	   	var mensajeRegulatorio = '<div style="border: 1px solid #f3f5f6;width: 250px;margin: 0 auto;"><div style="background: #1d4e77;color: #fff;padding: 5px 10px;border-radius: 5px 5px 0px 0px;">Mensaje:</div> '
					+ '<div style="background: #f3f5f6;padding: 5px 10px;text-align: justify;">Estimado Usuario el Regulatorio seleccionado no Aplica para su Tipo de Institución.</div> '
					+ ' <div class="footer"></div></div>';

		 var regulatorio = {
				   'clave' : 'I0391'
		   }
		   var numConsulta = 1;
		   

	   	regulatorioInsServicio.consulta(numConsulta,regulatorio,function(valida){

			   if(valida.aplica == 'N'){
				  $('#tblRegulatorio').html(mensajeRegulatorio);
				
			   }else{
			   		paramGeneralesServicio.consulta(tipoConsulta, bean,function(Institucion){
						var head = document.getElementsByTagName('head')[0];
					    var script = document.createElement('script');
					    script.type = 'text/javascript';
					    var url = "";

					     if (Institucion.valorParametro == catTipoIns.socap) {
					   			url = "js/regulatorios/regulatorioI0391Socap.js";
							}else if(Institucion.valorParametro == catTipoIns.sofipo){
							   		url = "js/regulatorios/regulatorioI0391Sofipo.js";
							}
						
						script.src = url;
						head.appendChild(script);
				  
					   
				   });

			   }
		   });
		   
	   }


validaRegulatorioInstitucion();