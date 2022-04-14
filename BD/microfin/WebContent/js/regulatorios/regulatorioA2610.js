var tipoInstitucion = 0;	
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
			   mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
			   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
			   this.focus();
		   }
	   });
	   
	   $('#mes').change(function (){
		   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
		   var anioSeleccionado = $('#anio').val();
		   
		   if((parseInt(this.value) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
			   mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
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
			   mensajeSis("El Año Indicado es Incorrecto.");
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
			   mensajeSis("El Año Indicado es Incorrecto.");
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
		   var url='';
		   
		   if (mes == 0 ){
			   mensajeSis('Seleccione un mes');
			   $('#mes').focus();
			   return false;
		   } 
		   
		   if ($('#excel').attr('checked')) {
			   tipoReporte = 1;			   
			}else{
				tipoReporte = 2;
			}	
		   
		   var regulatorio = {
				   'clave' : 'A2610'
		   }
		   var numConsulta = 1;
		   
		   regulatorioInsServicio.consulta(numConsulta,regulatorio,function(valida){
			   if(valida.aplica == 'S'){
				   url = 'reporteRegulatorioA2610.htm?tipoReporte=' + tipoReporte + '&tipoEntidad='+tipoInstitucion+'&anio='+anio+ '&mes=' + mes;
				   window.open(url);
			   }else{
				   mensajeSis("El Reporte Seleccionado no Aplica para su Institución Financiera");
			   }
		   });
		   
		   
		   
		   
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
	   
	   
	   function consultaInstitucion(){
		   
		   var tipoConsulta = 9;
		   var bean = { 
					'empresaID'		: 1		
				};
			
			paramGeneralesServicio.consulta(tipoConsulta, bean,function(Institucion){
				   tipoInstitucion = Institucion.valorParametro;
			   });
	   }



	   function validaRegulatorioInstitucion(){
	   	var mensajeRegulatorio = '<div style="border: 1px solid #f3f5f6;width: 250px;margin: 0 auto;"><div style="background: #1d4e77;color: #fff;padding: 5px 10px;border-radius: 5px 5px 0px 0px;">Mensaje:</div> '
					+ '<div style="background: #f3f5f6;padding: 5px 10px;text-align: justify;">Estimado Usuario el Regulatorio seleccionado no Aplica para su Tipo de Institución.</div> '
					+ ' <div class="footer"></div></div>';

		//" 
		 var regulatorio = {
				   'clave' : 'A2610'
		   }
		   var numConsulta = 1;
		   

	   	regulatorioInsServicio.consulta(numConsulta,regulatorio,function(valida){
			   if(valida.aplica == 'N'){
				  $('#tblRegulatorio').html(mensajeRegulatorio);
			   }
		   });
		   
	   }
	  
	}); // fin ready

	
  