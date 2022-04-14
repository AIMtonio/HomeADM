	$(document).ready(function() {	
		esTab = true;
		agregaFormatoControles('formaGenerica');
		var parametroBean = consultaParametrosSession();
		llenaComboAnios(parametroBean.fechaAplicacion);
		$('#anio').focus();
		
		
		var generaTipoXml = {
				'catalogo' : 1
			};
			
	
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({

      submitHandler: function(event) { 
      	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','consecutivo');
      }
   });	
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	// ------------ Metodos y Manejo de Eventos
	habilitaBoton('generar', 'submit');
	

		
	   $('#generar').click(function() {	
		   if($('#consecutivo').val()!='' && !isNaN($('#consecutivo').val()) ){
		  		generarXml();
			}
		   else{
			   mensajeSis('Especifique el Número Consecutivo.');
		   }
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
		   
		   if((parseInt(mesSeleccionado) > parseInt(mesSistema)) ){
			   mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
			   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
			   this.focus();
		   }
		   else{
		   		if(parseInt(anioSeleccionado) > parseInt(anioActual)){
			   		mensajeSis("El Año Indicado es Incorrecto.");
				   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
				   this.focus();
		   		}
		   }
	   });
	   
	   $('#anio').blur(function (){
		   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
		   var anioSeleccionado = $('#anio').val();
		   var mesSeleccionado = $('#mes').val();
		   if(parseInt(anioSeleccionado) > parseInt(anioActual) ){
			   mensajeSis("El Año Indicado es Incorrecto.");
			   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
			   this.focus();
		   }else{
		   	if((parseInt(mesSeleccionado) > parseInt(mesSistema))){
			   mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
			   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
			   this.focus();
		   	}
		   }
	   });
	   
		// Validaciones de la forma
	   $('#formaGenerica').validate({
		  
		   rules: {
			   anio: 'required',
			   mes: 'required',
			   
			   consecutivo : {
					required: true,
				    numeroPositivo: true
				},
		   },	
		   messages: {
			   anio: 'Especifique Año',
			   mes: 'Especifique Mes',
			   consecutivo : {
					required: 'Especifique el Consecutivo',
					numeroPositivo : "Solo números"
						},
		   }		
	   });  
	   
		// ------------ Validaciones de Controles-------------------------------------
	   
	 
	   function llenaComboAnios(fechaActual){
		   var anioActual = fechaActual.substring(0, 4);
		   var mesActual = parseInt(fechaActual.substring(5, 7));
		   var numOption = 2;
		  
		   for(var i=0; i<numOption; i++){
			   $("#anio").append('<option value="'+anioActual+'">' + anioActual + '</option>');
			   anioActual = parseInt(anioActual) - 1;
		   }
		   
		   $("#mes option[value="+ mesActual +"]").attr("selected",true);
	   }
	   

	   function generarXml(){
	   		
			$('#ligaGenerar').attr('href','generarXmlContaElectro.htm?anio='+$('#anio').val()+'&mes='+$('#mes').val()
						+'&consecutivo='+$('#consecutivo').val()+'&generaTipoXml='+generaTipoXml.catalogo);

	   }

	  
	});
	
	
	function validador(e){
		key=(document.all) ? e.keyCode : e.which;
		if (key < 48 || key > 57){
			if (key==8 || key == 0){
				return true;
			}
			else 
	  		return false;
		}
	}

	
  