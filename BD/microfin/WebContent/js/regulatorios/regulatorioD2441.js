var tipoInstitucion = 0;	

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
			   'clave' : 'D2441'
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
	validaPeriodo(false);
		
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
		   validaPeriodo(true);
	   });
	   
	   $('#mes').change(function (){
		    validaPeriodo(true);
	   });
	   
	   $('#anio').change(function (){
		    validaPeriodo(true);
	   });
	   
	   $('#anio').blur(function (){
		    validaPeriodo(true);
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
		   
		   if($('#mes').val() == 0){
			   mensajeSis('Seleccione un periodo');
		   		$('#mes').focus();
			   	return false;
			   }
		   
		   if ($('#excel').attr('checked')) {
			   tipoReporte = 1;			   
			}else{
				tipoReporte = 2;
			}	
		   url = 'reporteRegulatorioD2441.htm?tipoReporte=' + tipoReporte + '&tipoEntidad='+tipoInstitucion + '&anio='+anio+ '&periodo=' + mes;
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

	
  function consultaPeriodo(mes){
  	if(mes >= 1 && mes < 3){
  		return 1;
  	}

  	if(mes >= 3 && mes < 6){
  		return 2;
  	}

  	if(mes >= 6 && mes < 9){
  		return 3;
  	}

  	if(mes >= 9 && mes < 12){
  		return 4;
  	}

  }

  function validaPeriodo(inicio){
  		inicio  =  typeof inicio == 'undefined' ? true : inicio;
		var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	

		var anioSeleccionado = $('#anio').val();
		var mesSeleccionado = $('#mes').val();
		var periodoActual = consultaPeriodo(mesSistema);

		if(parseInt(anioSeleccionado) > parseInt(anioActual)  || 
			( parseInt(anioSeleccionado) == parseInt(anioActual) & parseInt(mesSeleccionado) >= periodoActual )  ){
		  
		   if (inicio){
		   	 mensajeSis("El Periodo Seleccionado no ha Finalizado.");
		   }
		   if ( periodoActual == 1 ){
			   	$('#anio').val(anioActual-1);
			   	$('#mes').val(4);
		   }else{
			   	$('#anio').val(anioActual);
			   	$('#mes').val(periodoActual-1);
		   }

			   $('#mes').focus();
		}
				   
  }


