$(document).ready(function() {	
	$("#anio").focus();
		esTab = true;
		agregaFormatoControles('formaGenerica');
		var parametroBean = consultaParametrosSession();
		
	llenaComboAnios(parametroBean.fechaAplicacion);
		
		
	   $('#generar').click(function() {		
		   generaReporte();
	   });
	   
	   $('#excel').click(function() {		
		   $("#excel").attr('checked', true); 
		  
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
		   var tipoReporte = 1;
		   var nombreInstitucion = parametroBean.nombreInstitucion;
		   var nombreUsuario = parametroBean.claveUsuario; 
		   var fechaSis = parametroBean.fechaSucursal;
		   var horaEmision=hora();
			
		   var Anio=$('#anio').val();
		   var Mes=$('#mes').val();
			
		
			
			
			url ='reporteIDEMens.htm?'
				+'Anio=' + Anio
				+'&Mes='+Mes
				+'&nombreInstitucion='	+nombreInstitucion
				+'&nombreUsuario='	+nombreUsuario
				+'&fechaReporte='	+fechaSis
				+'&horaEmision='	+horaEmision
				+'&tipoReporte='+tipoReporte
				+ '&tipoLista=1';
				   window.open(url);
						   
		   
	   };
	   
	   function hora(){
			 var Digital=new Date();
			 var hours=Digital.getHours();
			 var minutes=Digital.getMinutes();
			 var seconds=Digital.getSeconds();
			
			 if (minutes<=9)
				 minutes="0"+minutes;
			 if (seconds<=9)
				 seconds="0"+seconds;
			return  hours+":"+minutes+":"+seconds;
		 }
	
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
	   

	  
	}); 

	
  