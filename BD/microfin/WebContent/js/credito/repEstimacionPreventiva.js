$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	fechaVacia = '1900-01-01';
	fechaReporte = '1900-01-01';
	var parametroBean = consultaParametrosSession();   
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	
	llenaComboAnios(parametroBean.fechaAplicacion);

	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
	  	}
	});	

	$('#anio').focus();
		
	   $('#generar').click(function() {	
		   var anio = $('#anio').val();
		   var mes = $('#mes').val();
		   generaFecha(anio,mes);
		   var tipoConsulta = 1;

		   consultaFechaEstimacion(fechaReporte, tipoConsulta);
	   });

	$('#excel').click(function() {
		$('#csv').attr("checked",false); 
		$('#excel').attr("checked",true); 

	});
	
	$('#csv').click(function() {
		$('#csv').attr("checked",true); 
		$('#excel').attr("checked",false); 
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
			   anio: 'Especifique Año.',
			   mes: 'Especifique Mes.',
		   }		
	   });  
	   
	   
	   /* Consulta para obtener la Ultima Fecha de Generacion de Estimaciones  */
		function consultaFechaEstimacion(varFecha, tipoConsulta){
			var tipoReporte = 3;
			var tipoLista = 1;
			
			if(varFecha != '' && varFecha != '1900-01-01'){
				var estimacionPreventivaBean = {
					'fechaCorte':varFecha
				};
				
				estimacionPreventivaServicio.consultaEstimacion(estimacionPreventivaBean, tipoConsulta, function(estimacionBean) {
					if(estimacionBean!=null){
						esTab=true;
						if(estimacionBean.fechaCorte != varFecha){
							
							if (estimacionBean.fechaCorte == '1900-01-01' || estimacionBean.fechaCorte == ''){ 
								alert('No existe Información para Generar el Reporte');
								$('#fecha').focus();
							}else{ 
								alert("No se encontró información para la fecha: "+varFecha+
										"\nLa última fecha con información es: "+ estimacionBean.fechaCorte);
								$('#anio').val(estimacionBean.fechaCorte.substring(0,4));
								$('#mes').val(estimacionBean.fechaCorte.substring(5,7));
							}
						}else{
							generaReporte();
						}
					}
				});
			}
		}
	   
	   // Funcion que genera el reporte
	   function generaReporte(){
		   var tipoReporte = $("input[type='radio'][name='tipoReporte']:checked").val();
		   var anio = $('#anio').val();
		   var mes = $('#mes').val();
		   var url='';
		   
		   generaFecha(anio,mes);
		   
		   var nombreInstitucion =  parametroBean.nombreInstitucion; 
		   
		   url = 'repEstimacionPrevA419.htm?tipoReporte=' + tipoReporte + '&fecha='+fechaReporte+
		   		'&nombreInstitucion='+nombreInstitucion;
		   window.open(url);
	   };
	
	   function llenaComboAnios(fechaActual){
		   var anioActual = fechaActual.substring(0, 4);
		   var mesActual = parseInt(fechaActual.substring(5, 7));
		   var numOption = 10;
		  
		   for(var i=0; i<numOption; i++){
			   $("#anio").append('<option value="'+anioActual+'">' + anioActual + '</option>');
			   anioActual = parseInt(anioActual) - 1;
		   }
		   
		   $("#mes option[value="+ mesActual +"]").attr("selected",true);
	   }
	   
	   
	   function generaFecha(anio,mes){
	   	   mes = parseInt(mes) - 1;
		   var fechaRep = new Date(anio,mes,1);
		   var primerDia = new Date(fechaRep.getFullYear(), fechaRep.getMonth(), 1);
		   var ultimoDia = new Date(fechaRep.getFullYear(), fechaRep.getMonth() + 1, 0);

		   mes = (ultimoDia.getMonth() + 1) < 10 ? '0'+ (ultimoDia.getMonth()+1) : (ultimoDia.getMonth()+1);

		   fechaReporte = ultimoDia.getFullYear() + '-' + mes + '-' + ultimoDia.getDate();
	   }
	
	
	
});
