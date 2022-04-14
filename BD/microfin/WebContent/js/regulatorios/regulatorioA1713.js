var tipoInstitucion = 0;	
var claveInstitucion = {
		sofipo: 3,
		socap: 6
}

function consultaInstitucion(){
	   
	   var tipoConsulta = 9;
	   var bean = { 
				'empresaID'		: 1		
			};
		
		paramGeneralesServicio.consulta(tipoConsulta, bean,function(Institucion){

			   tipoInstitucion = Institucion.valorParametro;
			   switch(parseInt(tipoInstitucion)){
			   		case claveInstitucion.sofipo:
			   			$('#tblRegulatorio').load('regulatorioA1713SofipoVista.htm',function(response, status, xhr){
							if(status == 'error') {
								$('#tblRegulatorio').html(response);
							}
						});
			   			break;
			   		case claveInstitucion.socap:
			   			$('#tblRegulatorio').load('regulatorioA1713SocapVista.htm',function(response, status, xhr){
							if(status == 'error') {
								$('#tblRegulatorio').html(response);
							}
						});
			   			break;
			   }
		   });
}



function validaRegulatorioInstitucion(){
	var mensajeRegulatorio = '<div style="border: 1px solid #f3f5f6;width: 250px;margin: 0 auto;"><div style="background: #1d4e77;color: #fff;padding: 5px 10px;border-radius: 5px 5px 0px 0px;">Mensaje:</div> '
				+ '<div style="background: #f3f5f6;padding: 5px 10px;text-align: justify;">Estimado Usuario el Regulatorio seleccionado no Aplica para su Tipo de Institución.</div> '
				+ ' <div class="footer"></div></div>';

	
	 var regulatorio = {
			   'clave' : 'A1713'
	   }
	   var numConsulta = 1;
	   
	regulatorioInsServicio.consulta(numConsulta,regulatorio,function(valida){
		   if(valida.aplica == 'N'){
			  $('#tblRegulatorio').html(mensajeRegulatorio);
		   }else{
		   	consultaInstitucion()
		   }
	   });
	   
}



$(document).ready(function() {
	parametros = consultaParametrosSession();
	
	validaRegulatorioInstitucion();

	
});
