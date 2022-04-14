	$(document).ready(function() {	
		esTab = true;
		agregaFormatoControles('formaGenerica');
		var parametroBean = consultaParametrosSession();

		$('#anio').focus();
		
	llenaComboAnios(parametroBean.fechaAplicacion);
	
	$('#excel').click(function() {
		$('#csv').attr("checked",false); 
		$('#excel').attr("checked",true); 

	});
	
	$('#csv').click(function() {
		$('#csv').attr("checked",true); 
		$('#excel').attr("checked",false); 
	});
	
		
		consultaMonedaUDIS(); 
	
	   $('#generar').click(function() {	
		   if($('#excel').is(":checked")){ 
			   generaReporteExcel();
			}
		   else if($('#csv').is(":checked")){ 
				generaReporteCSV();
			} 
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
	   
	   
	   // Funcion que genera el reporte en Excel
	   function generaReporteExcel(){
		   var tipoReporte = 1;
		   var tipoLista = 1;
		   var anio = $('#anio').val();
		   var mes = $('#mes').val();
		   var institucion = parametroBean.nombreInstitucion;
		   var fecha = parametroBean.fechaSucursal;
		   var usuario = parametroBean.claveUsuario;
		   var url='ReporteDIOT.htm?tipoReporte=' + tipoReporte +
		   							'&tipoLista='+tipoLista+
		   							'&anio='+anio+ 
		   							'&mes=' + mes +
		   							'&nombreInstitucion=' + institucion +
		   							'&fechaSistema=' + fecha +
		   							'&usuario=' + usuario;
		   window.open(url);
	   };
	   
	   // Funcion que genera el reporte en Csv
	   function generaReporteCSV(){
		   var tipoReporte = 2;
		   var tipoLista = 2;
		   var anio = $('#anio').val();
		   var mes = $('#mes').val();
		   var url='ReporteDIOT.htm?tipoReporte=' + tipoReporte + '&tipoLista='+tipoLista+'&anio='+anio+ '&mes=' + mes;
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
	   
	   
		  function consultaMonedaUDIS(){
		   var monedaID = 4;   // ID de la moneda UDIS
		   var tipoConsulta = 3;
		   var divisaBean = {
					'monedaId' : monedaID
				};

		   			divisasServicio.consultaExisteDivisa(tipoConsulta,divisaBean,function(divisa) {
		   						if(divisa != null) {
		   							habilitaBoton('generar','submit');	
								} 
								else {
									deshabilitaBoton('generar','submit');
									alert('La Moneda UDIS No Está Registrada.');
								}
		   			}); 
		   }
	  
	}); // fin ready

	
  