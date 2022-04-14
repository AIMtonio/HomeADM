var tipoInstitucion = 0;	
	
$(document).ready(function() {	
	
	esTab = true;
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();
	$('#mesActual').focus();
	
	var campoActual = reordenarFecha(parametroBean.fechaAplicacion); 
	var campoAnterior= reordenarFecha(parametroBean.fechaAplicacion); 
	
	$('#mesActual').val(campoActual); 	
	$('#mesAnterior').val(campoAnterior);

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
	   
	calendarioRegulatorio('mesActual');
	calendarioRegulatorio('mesAnterior');
	
   	$('#mesActual').blur(function (){
	   	var fechaSistema = parametroBean.fechaAplicacion;
	   	var fechaAct = $('#mesActual').val();	   
	   	var campoActual = reordenarFecha(parametroBean.fechaAplicacion); 	
	   	
	   	esFechaValida(fechaAct,"#mesActual");

   		var str = fechaAct;
    	var año = parseInt(str.substring(0, 4));
    	var mes = str.substring(5, 7);
	   	
	   	var fechaConsultaActual = new Date(año, mes, 0); 
	   	var añoActual = fechaConsultaActual.getFullYear();
	   	var mesActual = fechaConsultaActual.getMonth();
	   	var diaActual = fechaConsultaActual.getDate();
	   	
		mesActual =  mesActual +1;
	   	if(mesActual <= 9){
	   		mesActual = ("0"+mesActual).toString();
	   	}

	   	var fechaSis = fechaSistema;
	   	var añoSis = parseInt(fechaSis.substring(0, 4));
    	var mesSis = fechaSis.substring(5, 7);

    	var fechaConsultaSis = new Date(añoSis, mesSis, 0);
    	var mesActSistema = fechaConsultaSis.getMonth(); 
	   	
	   	mesActSistema =  mesActSistema +1;
	   	if(mesActSistema <= 9){
	   		mesActSistema = ("0"+mesActSistema).toString();
	   	}

	   	var fechaActual = añoActual+"-"+mesActual+"-"+diaActual;

	   	if(fechaActual > campoActual){
	   		$('#mesActual').focus();
	   		mensajeSis("La Fecha ingresada es mayor a la fecha del sistema.");
	   		$('#mesActual').val(campoActual);

	   		return false;
	   	}
		$('#mesActual').val(fechaActual);

   	});

   	$('#mesActual').change(function (){
	   	var fechaSistema = parametroBean.fechaAplicacion;
	   	var fechaAct = $('#mesActual').val();	   
	   	var campoActual = reordenarFecha(parametroBean.fechaAplicacion); 	
	   	
	   	esFechaValida(fechaAct,"#mesActual");

   		var str = fechaAct;
    	var año = parseInt(str.substring(0, 4));
    	var mes = str.substring(5, 7);
	   	
	   	var fechaConsultaActual = new Date(año, mes, 0); 
	   	var añoActual = fechaConsultaActual.getFullYear();
	   	var mesActual = fechaConsultaActual.getMonth();
	   	var diaActual = fechaConsultaActual.getDate();
	   	
		mesActual =  mesActual +1;
	   	if(mesActual <= 9){
	   		mesActual = ("0"+mesActual).toString();
	   	}

	   	var fechaSis = fechaSistema;
	   	var añoSis = parseInt(fechaSis.substring(0, 4));
    	var mesSis = fechaSis.substring(5, 7);

    	var fechaConsultaSis = new Date(añoSis, mesSis, 0);
    	var mesActSistema = fechaConsultaSis.getMonth(); 
	   	
	   	mesActSistema =  mesActSistema +1;
	   	if(mesActSistema <= 9){
	   		mesActSistema = ("0"+mesActSistema).toString();
	   	}

	   	var fechaActual = añoActual+"-"+mesActual+"-"+diaActual;

	   	if(fechaActual > campoActual){
	   		$('#mesActual').focus();
	   		mensajeSis("La Fecha ingresada es mayor a la fecha del sistema.");
	   		$('#mesActual').val(campoActual);

	   		return false;
	   	}

	   	
	   	$('#mesActual').val(fechaActual);
	   	$('#mesAnterior').focus();


   	});


    $('#mesAnterior').blur(function (){
	   	var fechaSistema = parametroBean.fechaAplicacion;
	   	var fechaAnt = $('#mesAnterior').val();
	   	var fechaAct = $('#mesActual').val();	   	
	   	var campoActual = reordenarFecha(parametroBean.fechaAplicacion); 

		esFechaValida(fechaAnt,"#mesAnterior");

	   	var str = fechaAnt;
    	var año = parseInt(str.substring(0, 4));
    	var mes = str.substring(5, 7);
	   	
	   	var fechaConsultaActual = new Date(año, mes, 0); 
	   	var añoActual = fechaConsultaActual.getFullYear();
	   	var mesActual = fechaConsultaActual.getMonth();
	   	var diaActual = fechaConsultaActual.getDate();
	   	
	   	var fechaSis = fechaSistema;
	   	var añoSis = parseInt(fechaSis.substring(0, 4));
    	var mesSis = fechaSis.substring(5, 7);

    	var fechaConsultaSis = new Date(añoSis, mesSis, 0);
    	var mesActSistema = fechaConsultaSis.getMonth(); 
	   	
	   	mesActSistema =  mesActSistema +1;
	   	if(mesActSistema <= 9){
	   		mesActSistema = ("0"+mesActSistema).toString();
	   	}

	   	mesActual =  mesActual +1;
	   	if(mesActual <= 9){
	   		mesActual = ("0"+mesActual).toString();
	   	}
	   		   
	   	var fechaActual = añoActual+"-"+mesActual+"-"+diaActual;

	   	if(fechaActual > campoActual){
	   		$('#mesAnterior').focus();
	   		mensajeSis("La Fecha ingresada es mayor a la fecha del sistema.");
	   		$('#mesAnterior').val(campoActual);	   		
	   		return false;
	   	}

		
	   	$('#mesAnterior').val(fechaActual);

   	});
   
   	$('#mesAnterior').change(function (){
	   	var fechaSistema = parametroBean.fechaAplicacion;
	   	var fechaAnt = $('#mesAnterior').val();
	   	var fechaAct = $('#mesActual').val();	   	
	   	var campoActual = reordenarFecha(parametroBean.fechaAplicacion); 

		esFechaValida(fechaAnt,"#mesAnterior");

	   	var str = fechaAnt;
    	var año = parseInt(str.substring(0, 4));
    	var mes = str.substring(5, 7);
	   	
	   	var fechaConsultaActual = new Date(año, mes, 0); 
	   	var añoActual = fechaConsultaActual.getFullYear();
	   	var mesActual = fechaConsultaActual.getMonth();
	   	var diaActual = fechaConsultaActual.getDate();
	   	
	   	var fechaSis = fechaSistema;
	   	var añoSis = parseInt(fechaSis.substring(0, 4));
    	var mesSis = fechaSis.substring(5, 7);

    	var fechaConsultaSis = new Date(añoSis, mesSis, 0);
    	var mesActSistema = fechaConsultaSis.getMonth(); 
	   	
	   	mesActSistema =  mesActSistema +1;
	   	if(mesActSistema <= 9){
	   		mesActSistema = ("0"+mesActSistema).toString();
	   	}
	   	
		mesActual =  mesActual +1;
	   	if(mesActual <= 9){
	   		mesActual = ("0"+mesActual).toString();
	   	}
	   	
	   	var fechaActual = añoActual+"-"+mesActual+"-"+diaActual;
	   	
	   	if(fechaActual > campoActual){
	   		$('#mesAnterior').focus();
	   		mensajeSis("La Fecha ingresada es mayor a la fecha del sistema.");
	   		$('#mesAnterior').val(campoActual);	   		
	   		return false;
	   	}

   		if (fechaAnt < fechaAct){
		   	$('#mesAnterior').focus();
		   	mensajeSis('El mes final no puede ser menor al mes inicial.');
		   	$('#mesAnterior').val(campoActual);	  		   	
		   	return false;
	  	} 

	   	$('#mesAnterior').val(fechaActual);
	   	$('#excel').focus();
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
	   	var mesActual = $('#mesActual').val();
	   	var mesAnterior = $('#mesAnterior').val();
	   	var campoActual = reordenarFecha(parametroBean.fechaAplicacion);
	   	var url='';
	   	esFechaValida(mesActual,"#mesActual");
	   	esFechaValida(mesAnterior,"#mesAnterior");

	   	if(mesActual == '' ){
			$('#mesActual').focus();
	   		mensajeSis('El campo no puede ser vacío.');		   	
		   	return false;
	   	}	  

	   	if(mesAnterior == '' ){
			$('#mesActual').focus();
	   		mensajeSis('El campo no puede ser vacío.');		   	
		   	return false;
	   	}
	   	if (mesAnterior  < mesActual){
		   	$('#mesAnterior').focus();
		   	mensajeSis('El mes final no debe ser menor al mes inicial');		   	
		   	return false;
	  	} 

	  	if (mesAnterior == mesActual){
		   	mensajeSis('Las fechas de consulta no pueden ser las mismas.');
		   	$('#mesActual').focus();
		   	$('#mesAnterior').val(campoActual);
		   	return false;
	  	} 	  	

	   	if ($('#excel').attr('checked')) {
		   	tipoReporte = 1;			   
	   	}else{
			tipoReporte = 2;
	   	}	
	   
	   	var numConsulta = 1;
	   	var regulatorio = {
		   'clave' : 'A1316'
   		};
	   
	   regulatorioInsServicio.consulta(numConsulta,regulatorio,function(valida){
		   if(valida.aplica == 'S'){
				url = 'reporteRegulatorioA1316.htm?tipoReporte=' + tipoReporte + '&tipoEntidad='+tipoInstitucion+'&fechaConsultaActual='+mesAnterior+ '&fechaConsultaAnterior=' + mesActual;
				window.open(url);
		   }else{
			   mensajeSis("El Reporte Seleccionado no Aplica para su Institución Financiera");
		   }
	   }); 
	   
	   	
	   
   };
	
   
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
	   var regulatorio = {
		   'clave' : 'A1316'
	   };
	   var numConsulta = 1;
		   

   		regulatorioInsServicio.consulta(numConsulta,regulatorio,function(valida){
		   if(valida.aplica == 'N'){
			  $('#tblRegulatorio').html(mensajeRegulatorio);
		   }
	   });
	   
   	}

   function esFechaValida(fecha, jcontrol) {
	if (fecha != undefined && fecha.value != "") {
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)) {
			mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd).");
			$(jcontrol).focus();	
			return false;
		}

		var mes = fecha.substring(5, 7) * 1;
		var dia = fecha.substring(8, 10) * 1;
		var anio = fecha.substring(0, 4) * 1;

		switch (mes) {
			case 1:
			case 3:
			case 5:
			case 7:
			case 8:
			case 10:
			case 12:
				numDias = 31;
				break;
			case 4:
			case 6:
			case 9:
			case 11:
				numDias = 30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)) {
					numDias = 29;
				} else {
					numDias = 28;
				}
				;
				break;
			default:
				mensajeSis("Fecha Introducida es Errónea.");
			return false;
		}
		if (dia > numDias || dia == 0) {
			mensajeSis("Fecha Introducida es Errónea.");
			return false;
		}
		return true;
		}
	}

	function comprobarSiBisisesto(anio) {
		if ((anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		} else {
			return false;
		}
	}

	function reordenarFecha(fecha){
   		var str = fecha;
    	var año = parseInt(str.substring(0, 4));
    	var mes = str.substring(5, 7);
	   	
	   	var fechaConsultaActual = new Date(año, mes, 0); 
	   	var añoActual = fechaConsultaActual.getFullYear();
	   	var mesActual = fechaConsultaActual.getMonth();
	   	var diaActual = new Date(new Date(añoActual, mesActual,1)-1).getDate();			
	   		   	
	   	if(mesActual <= 9){
	   		mesActual = ("0"+mesActual).toString();
	   	}

	   	var fechaActual = añoActual+"-"+mesActual+"-"+diaActual;
	   	return fechaActual;
   	}
	
	function calendarioRegulatorio(idCampo){

		var jControl = '#' + idCampo;
		var fechaDeSistema = parametroBean.fechaAplicacion;


		$(jControl).datepicker({
			showOn: "button",
			buttonImage: "images/calendar.png",
			buttonImageOnly: true,
			changeMonth: true, 
			changeYear: true,
			dateFormat: 'yy-mm-dd',
			yearRange: '-100:+10',
			defaultDate: fechaDeSistema,
			beforeShowDay: function (date) {
		        if (date.getDate() == LastDayOfMonth(date.getFullYear(),date.getMonth())) {
		            return [true, ''];
		        }
		        return [false, ''];
		    }

		}); 		 
		 
		$(jControl).datepicker($.datepicker.regional['es']);	

	}

	function LastDayOfMonth(Year, Month) { 
	    return new Date(new Date(Year, Month+1,1)-1).getDate(); 
	} 
}); // fin ready
