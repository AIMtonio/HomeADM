var tipoInstitucion = 0;	

function consultaInstitucion(){

	   var tipoConsulta = 9;
	   var bean = { 
				'empresaID'		: 1		
			};
		
		paramGeneralesServicio.consulta(tipoConsulta, bean,function(Institucion){
			   tipoInstitucion = Institucion.valorParametro;

			   if(tipoInstitucion == 3){
			   	$('.socap').hide();
			   	$('.sofipo').show();
			   	$('#version2017').click();
			   }else{
			   	$('.socap').show();
			   	$('.sofipo').hide();
			   	$('#version2014').click();
			   }
		   });
  }


  function validaRegulatorioInstitucion(){
  	var mensajeRegulatorio = '<div style="border: 1px solid #f3f5f6;width: 250px;margin: 0 auto;"><div style="background: #1d4e77;color: #fff;padding: 5px 10px;border-radius: 5px 5px 0px 0px;">Mensaje:</div> '
				+ '<div style="background: #f3f5f6;padding: 5px 10px;text-align: justify;">Estimado Usuario el Regulatorio seleccionado no Aplica para su Tipo de Institución.</div> '
				+ ' <div class="footer"></div></div>';

	//" 
	 var regulatorio = {
			   'clave' : 'A2011'
	   }
	   var numConsulta = 1;
	   

  	regulatorioInsServicio.consulta(numConsulta,regulatorio,function(valida){
		   if(valida.aplica == 'N'){
			  $('#tblRegulatorio').html(mensajeRegulatorio);
		   }
	   });
	   
  }


$(document).ready(function() {	
		esTab = true;
		agregaFormatoControles('formaGenerica');
		var parametroBean = consultaParametrosSession();
		
	llenaComboAnios(parametroBean.fechaAplicacion);
	consultaInstitucion();
	validaRegulatorioInstitucion();
	
	   $('#generar').click(function() {		
		   generaReporte();
	   });
	   
	   $('#excel').click(function() {		
		   $("#excel").attr('checked', true); 
		   $("#csv").attr('checked', false); 
	   });
	   $('#csv').click(function() {		
		   $("#csv").attr('checked', true); 
		   $("#excel").attr('checked', false); 
	   });
	   
	   
	   $('#mes').blur(function (){
		   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));	
		   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
		   var anioSeleccionado = $('#anio').val();
		   
		   if((parseInt(this.value) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
			   alert("El Mes Indicado es Mayor al Mes Actual del Sistema.");
			   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
			   this.focus();
		   }
	   });
	   
	   $('#mes').change(function (){
		   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
		   var anioSeleccionado = $('#anio').val();
		   
		   if((parseInt(this.value) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
			   alert("El Mes Indicado es Mayor al Mes Actual del Sistema.");
			   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
			   this.focus();
		   }
	   });
	   
	   $('#anio').change(function (){
		   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
		   var anioSeleccionado = $('#anio').val();
		   var mesSeleccionado = $('#mes').val();
		   
		   if((parseInt(mesSeleccionado) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
			   alert("El Año Indicado es Incorrecto.");
			   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
			   this.focus();
		   }
	   });
	   
	   $('#anio').blur(function (){
		   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
		   var anioSeleccionado = $('#anio').val();
		   var mesSeleccionado = $('#mes').val();
		   
		   if((parseInt(mesSeleccionado) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
			   alert("El Año Indicado es Incorrecto.");
			   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
			   this.focus();
		   }
	   });
	   
		// Validaciones de la forma
	   $('#formaGenerica').validate({
		   rules: {
			   anio: 'required',
			   mes: 'required',
		   },	
		   messages: {
			   anio: 'Especifique Año',
			   mes: 'Especifique Mes',
		   }		
	   });  
	   
	   
	   // Funcion que genera el reporte
	   function generaReporte(){
		   var tipoReporte = 0;
		   var anio = $('#anio').val();
		   var mes = $('#mes').val();
		   var varanioversion= $('input[name=version]:checked').val();
		   var url='';
		   
		   if ($('#excel').attr('checked')) {
			   tipoReporte = 1;			   
			}else{
				tipoReporte = 2;
			}	
		   url = 'reporteRegulatorioA2011.htm?tipoReporte=' + tipoReporte + '&anio='+anio+ '&mes=' + mes+'&version='+varanioversion+'&tipoEntidad='+tipoInstitucion;
		   window.open(url);

	   };
	
	   function llenaComboAnios(fechaActual){
		   var anioActual = fechaActual.substring(0, 4);
		   var mesActual = parseInt(fechaActual.substring(5, 7));
		   var numOption = 4;
		  
		   for(var i=0; i<numOption; i++){
			   $("#anio").append('<option value="'+anioActual+'">' + anioActual + '</option>');
			   anioActual = parseInt(anioActual) - 1;
		   }
		   
		   $("#mes option[value="+ mesActual +"]").attr("selected",true);
	   }
	   

	  
	}); // fin ready

	
  