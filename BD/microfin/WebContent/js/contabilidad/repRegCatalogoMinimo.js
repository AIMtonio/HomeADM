$(document).ready(function() {	
	esTab = true;
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();
	$('#csv').attr('checked', false);
	$('#excel').attr('checked', true);
	
        
	llenaComboAnios(parametroBean.fechaAplicacion);

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
	 
   

   $('#generar').click(function() {		
	   generaReporte();
   });
   
	$('#excel').click(function() {
		$('#csv').attr('checked', false);
		$('#excel').attr('checked', true);
		$('#excel').focus();
	});

	$('#csv').click(function() {
		$('#excel').attr('checked', false);
		$('#csv').attr('checked', true);
		$('#csv').focus();
	});
	
   
   $.validator.setDefaults({submitHandler: function(event) {
	   
	    }
   });	
 
   
	

   $('#formaGenerica').validate({
	   rules: {
		   fechaReporte: 'required',	
	   },
	   messages: {
		   fechaReporte: 'Especifique Fecha',
	   }		
   });
   
   function generaReporte(){
	   var anio = $('#anio').val();
	   var mes = $('#mes').val();
	   var fecha = parametroBean.fechaAplicacion;
	   var version= '2015';
	   var pagina='reporteRegulaCatMinimo.htm?anio='+anio+'&mes='+mes+'&fecha='+fecha+'&version='+version;
	   if($('#excel').is(':checked')){
		   pagina=pagina+'&tipoReporte=1';
	   }else{
		   pagina=pagina+'&tipoReporte=2';
	   }
	   window.open(pagina);	   
   };
   		   
//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE
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
