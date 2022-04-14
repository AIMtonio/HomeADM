	$(document).ready(function() {	
		esTab = true;
		agregaFormatoControles('formaGenerica');
		var parametroBean = consultaParametrosSession();
		llenaComboAnios(parametroBean.fechaAplicacion);
		$('#anio').focus();
		
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	var generaTipoXml = {
			'poliza' : 3
		};
	
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
		
	$('#generar').click(function() {		
	  generarXml();
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


	   $('#tipoSolicitud').blur(function (){
			var tipoSolicitud = $('#tipoSolicitud').val();
			if(tipoSolicitud == 'AF' || tipoSolicitud == 'FC'){
				$('#numeroTramite').val("");
				deshabilitaControl('numeroTramite');
				habilitaControl('numeroOrden');
			}else{
				$('#numeroOrden').val("");
				deshabilitaControl('numeroOrden');
				habilitaControl('numeroTramite');
			}
	   });
	   

	    $('#tipoSolicitud').blur(function (){
			var tipoSolicitud = $('#tipoSolicitud').val();
			if(tipoSolicitud == 'AF' || tipoSolicitud == 'FC'){
				$('#numeroTramite').val("");
				deshabilitaControl('numeroTramite');
				habilitaControl('numeroOrden');
			}else{
				$('#numeroOrden').val("");
				deshabilitaControl('numeroOrden');
				habilitaControl('numeroTramite');
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
	   		var tipoSolicitud = $("#tipoSolicitud").val();
	   		var numeroOrden = $("#numeroOrden").val();
	   		var numeroTramite = $("#numeroTramite").val();

	   		if(tipoSolicitud == 'AF' || tipoSolicitud == 'FC'){
	   			
	   			if(numeroOrden == ''){
	   				mensajeSis("Especifique el Número de Orden");
	   				$("#numeroOrden").focus();
	   			}else{	   				

					$('#ligaGenerar').attr('href','generarXmlContaElectro.htm?anio='+$('#anio').val()+'&mes='+$('#mes').val()
						+'&tipoSolicitud='+$('#tipoSolicitud').val()+'&numeroOrden='+$('#numeroOrden').val()+'&numeroTramite='+$('#numeroTramite').val()
						+'&generaTipoXml='+generaTipoXml.poliza);
	   			}
	   		}else{
	   			if(numeroTramite == ''){
	   				mensajeSis("Especifique el Número de Trámite");
	   				$("#numeroTramite").focus();
	   			}else{	   			

				$('#ligaGenerar').attr('href','generarXmlContaElectro.htm?anio='+$('#anio').val()+'&mes='+$('#mes').val()
						+'&tipoSolicitud='+$('#tipoSolicitud').val()+'&numeroOrden='+$('#numeroOrden').val()+'&numeroTramite='+$('#numeroTramite').val()
						+'&generaTipoXml='+generaTipoXml.poliza);
	   			}
	   		}


			

	   }

	  
	});

	
function validaNumOrden(fila){
	esTab=true; 
	expr = /^([A-Z]{3}[0-9]{7}[/][0-9]{2})$/;
	
	var jqnumOrden = eval("'#"+fila+"'");
	var claveOrden = $(jqnumOrden).val();
		
	if(claveOrden != '' && esTab){	
	    if (!expr.test(claveOrden)) { 
	       mensajeSis("El Número de Orden no es Válido");
	       $("#numeroOrden").focus();
	       $(jqnumOrden).val("");
		    	
	 	}
	}
}

function validaNumTramite(fila){
	esTab=true; 
	expr = /^([A-Z]{2}[0-9]{12})$/;	
	
	var jqnumTramite = eval("'#"+fila+"'");
	var claveTramite = $(jqnumTramite).val();
		
	if(claveTramite != '' && esTab){	
	    if (!expr.test(claveTramite)) { 
	       mensajeSis("El Número de Trámite no es Válido");
	       $("#numeroTramite").focus();
	       $(jqnumTramite).val("");
		    	
	 	}
	}

}

function ayudanumOrden(){	
	var data;
		
		data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
				'<legend class="ui-widget ui-widget-header ui-corner-all">Patr&oacute;n N&uacute;mero de Orden:</legend>'+
				'<div id="ContenedorAyuda">'+ 			
				'<table id="tablaLista">'+
					'<tr align="left">'+
						'<td id="encabezadoLista">[A-Z]{3}</td><td id="contenidoAyuda" align="left"><b>Tres Letras May&uacute;sculas de la A-Z</b></td>'+
					'</tr>'+
					'<tr>'+
						'<td id="encabezadoLista">[0-9]{7}</td><td id="contenidoAyuda" align="left"><b> Siete D&iacute;gitos del 0-9</b></td>'+
					'</tr>'+
					'<tr>'+
						'<td id="encabezadoLista">(/)</td><td id="contenidoAyuda" align="left"><b> S&iacute;mbolo (Diagonal)</b></td>'+ 
					'</tr>'+
					'<tr>'+
					'<td id="encabezadoLista">[0-9]{2}</td><td id="contenidoAyuda" align="left"><b> Dos D&iacute;gitos del 0-9</b></td>'+ 
					'</tr>'+
				'</table>'+
				'<br>'+
				'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
				'<div id="ContenedorAyuda">'+ 
				'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo: N&uacute;mero de Orden</legend>'+
				
				'<table id="tablaLista">'+				
					'<tr>'+
						'<td id="encabezadoAyuda" colspan="9"><b>N&uacute;mero de Orden:</b></td>'+ 
					'</tr>'+
					'<tr align="center" id="contenidoAyuda" >'+
						'<td>[A-Z]{3}[0-9]{7}(/)[0-9]{2}</td>'+
					'</tr>'+
					'<tr>'+
						'<td colspan="9" id="encabezadoAyuda"><b>N&uacute;mero de Orden Completo:</b></td>'+ 
					'</tr>'+
					'<tr align="center" id="contenidoAyuda">'+
						'<td>ABC1234567/01</td>'+
					'</tr>'+				
				'</table>'+
				'</div></div>'+ 
				'</fieldset>'+
				'</fieldset>'; 
		

	   $('#ContenedorAyuda').html(data); 
		$.blockUI({message: $('#ContenedorAyuda'),
					   css: { 
	                top:  ($(window).height() - 400) /2 + 'px', 
	                left: ($(window).width() - 400) /2 + 'px', 
	                width: '350' 
	            } });  
	   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 				      
	}	


	function ayudanumTramite(){	
	var data;
		
		data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
				'<legend class="ui-widget ui-widget-header ui-corner-all">Patr&oacute;n N&uacute;mero de Trámite:</legend>'+
				'<div id="ContenedorAyuda">'+ 			
				'<table id="tablaLista">'+
					'<tr align="left">'+
						'<td id="encabezadoLista">[A-Z]{2}</td><td id="contenidoAyuda" align="left"><b>Dos Letras May&uacute;sculas de la A-Z</b></td>'+
					'</tr>'+			
					'<tr>'+
					'<td id="encabezadoLista">[0-9]{12}</td><td id="contenidoAyuda" align="left"><b> Doce D&iacute;gitos del 0-9</b></td>'+ 
					'</tr>'+
				'</table>'+
				'<br>'+
				'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
				'<div id="ContenedorAyuda">'+ 
				'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo: Número de Tr&aacute;mite</legend>'+
				
				'<table id="tablaLista">'+				
					'<tr>'+
						'<td id="encabezadoAyuda" colspan="9"><b>Patr&oacute;n:</b></td>'+ 
					'</tr>'+
					'<tr align="center" id="contenidoAyuda" >'+
						'<td>[A-Z]{2}[0-9]{12}</td>'+
					'</tr>'+
					'<tr>'+
						'<td colspan="9" id="encabezadoAyuda"><b>Número de Tr&aacute;mite Completo:</b></td>'+ 
					'</tr>'+
					'<tr align="center" id="contenidoAyuda">'+
						'<td>AB123456789123</td>'+
					'</tr>'+				
				'</table>'+
				'</div></div>'+ 
				'</fieldset>'+
				'</fieldset>'; 
		

	   $('#ContenedorAyuda').html(data); 
		$.blockUI({message: $('#ContenedorAyuda'),
					   css: { 
	                top:  ($(window).height() - 400) /2 + 'px', 
	                left: ($(window).width() - 400) /2 + 'px', 
	                width: '350' 
	            } });  
	   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 				      
	}	

