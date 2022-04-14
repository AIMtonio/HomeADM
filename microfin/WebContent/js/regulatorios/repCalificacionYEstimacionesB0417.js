
var tipoInstitucion = 0;	
var tipoSofipo		= 3;
$('#anio').focus();

 function consultaInstitucion(){
		   
		   var tipoConsulta = 9;
		   var bean = { 
					'empresaID'		: 1		
				};
			
			paramGeneralesServicio.consulta(tipoConsulta, bean,function(Institucion){
				   tipoInstitucion = Institucion.valorParametro;
				   if(tipoInstitucion == tipoSofipo){
					   $('.tipoSocap').hide();
					   $('.tipoSofipo').show();
					   $('#version2017').click();
				   }else{
					   $('.tipoSocap').show();
					   $('.tipoSofipo').hide();
				   }
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


	   function calculaFecha(anio,mes, callback){
	   		var fecha = new Date(anio,mes,0);

	   		fecha = fecha.getFullYear() +"-"+ (fecha.getMonth() < 9 ? "0" : "") + (fecha.getMonth()+1) + "-"+fecha.getDate();

	   		callback(fecha);
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


$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	fechaVacia = '1900-01-01';
	var parametroBean = consultaParametrosSession(); 

	llenaComboAnios(parametroBean.fechaAplicacion);  
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	consultaInstitucion();
	validaRegulatorioInstitucion();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
	  	}
	});	

	$('#excel').click(function() {
		$('#csv').attr("checked",false); 
		$('#excel').attr("checked",true); 

	});
	
	$('#csv').click(function() {
		$('#csv').attr("checked",true); 
		$('#excel').attr("checked",false); 
	});
	
	
	var fecha = parametroBean.fechaAplicacion;
	$('#fecha').val(fecha);
	
	$('#generar').click(function() { 
		var varFecha;

		if($('#mes').val() == '0'){
			mensajeSis('Favor de Especificar un mes');
			$('#mes').focus();
			return false;
		}

		calculaFecha($('#anio').val(),$('#mes').val(), function(fecha){
			varFecha = fecha;

			var varanioversion= $('input[name=version]:checked').val();
		
			setTimeout("$('#cajaLista').hide();", 200);
			var tipoConsulta = 1;
			if (varFecha == fechaVacia || varFecha == ''){ 
				mensajeSis('Favor de Especificar una Fecha Valida');
				$('#fecha').focus();
			}else if($('#excel').is(":checked")){ 
				consultaFechaEstimacionExcel(varFecha, tipoConsulta, varanioversion);
			}
			else if($('#csv').is(":checked")){ 
				consultaFechaEstimacionCSV(varFecha,tipoConsulta, varanioversion);
			}

		}); //$('#fecha').val();
		
	});

	   
	   $('#mes').change(function (){
	   		
	   		 var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
		   var anioSeleccionado = $('#anio').val();
		   var mesSeleccionado = $('#mes').val();

		   	if(parseInt(anioSeleccionado) > parseInt(anioActual)){
		   		 mensajeSis("El Año Indicado es mayor a la fecha del sistema.");
		   		 $('#anio').val(anioActual);
		   		 $('#anio').focus();

		   	}else{

		   		if(parseInt(anioSeleccionado) == parseInt(anioActual) & parseInt(mesSeleccionado) > parseInt(mesSistema)){
		   			 mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
		   			 $('#mes').val(mesSistema);
		   			 $('#mes').focus();
		   		}


		   	}
	   });
	   
	   $('#anio').change(function (){

	   	
		   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
		   var anioSeleccionado = $('#anio').val();
		   var mesSeleccionado = $('#mes').val();

		   	if(parseInt(anioSeleccionado) > parseInt(anioActual)){
		   		 mensajeSis("El Año Indicado es mayor a la fecha del sistema.");
		   		 $('#anio').val(anioActual);
		   		 $('#anio').focus();

		   	}else{

		   		if(parseInt(anioSeleccionado) == parseInt(anioActual)  &  parseInt(mesSeleccionado) > parseInt(mesSistema)){
		   			 mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
		   			 $('#mes').val(mesSistema);
		   			 $('#mes').focus();
		   		}


		   	}


	   });
	   
	  
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			fecha: {
				required: true,
				date : true
				}
		},
		messages: {
			fecha: {
				required: 'Especificar Fecha',
				date : 'Fecha Incorrecta'}
		}		
	});
	
	/* Consulta para obtener la Ultima Fecha de Generacion de Estimaciones  */
	function consultaFechaEstimacionExcel(varFecha, tipoConsulta, version){
		setTimeout("$('#cajaLista').hide();", 200);	
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
							mensajeSis('No existe Información para Generar el Reporte');
							$('#fecha').focus();
						}else{ 
							mensajeSis("No se encontró información para la fecha: "+varFecha+
									"\nLa última fecha con información es: "+ estimacionBean.fechaCorte);
						

							$('#mes').val( estimacionBean.fechaCorte.substring(5,7));
							$('#anio').val( estimacionBean.fechaCorte.substring(0,4));
							$('#mes').focus();
						}
					}else{
						pagina='RepEstimacionesB0417.htm?fecha='+estimacionBean.fechaCorte+'&tipoReporte='+tipoReporte+ '&tipoLista='+tipoLista + '&tipoEntidad='+tipoInstitucion+ '&version='+ version;
						window.open(pagina);
					}
				}
			});
		}
	}

	/* Consulta para obtener la Ultima Fecha de Generacion de Estimaciones  */
	function consultaFechaEstimacionCSV(varFecha,tipoConsulta, version){
		setTimeout("$('#cajaLista').hide();", 200);	
		var tipoReporte = 4;
		var tipoLista = 2;
		if(varFecha != '' && varFecha != '1900-01-01'){
			var estimacionPreventivaBean = {
				'fechaCorte':varFecha
			};
			
			estimacionPreventivaServicio.consultaEstimacion(estimacionPreventivaBean, tipoConsulta, function(estimacionBean) {
				if(estimacionBean!=null){
					esTab=true;
					if(estimacionBean.fechaCorte != varFecha){
						
						if (estimacionBean.fechaCorte == '1900-01-01' || estimacionBean.fechaCorte == ''){ 
							mensajeSis(	'No existe Información para Generar el Reporte');
							$('#fecha').focus();
						}else{ 
							mensajeSis("No se encontró información para la fecha: "+varFecha+
									"\nLa última fecha con información es: "+ estimacionBean.fechaCorte);
							$('#fecha').val(estimacionBean.fechaCorte);
							$('#fecha').focus();
						}
					}else{
						pagina='RepEstimacionesB0417.htm?fecha='+estimacionBean.fechaCorte+'&tipoReporte='+tipoReporte+ '&tipoEntidad='+tipoInstitucion+ '&tipoLista='+tipoLista+ '&version='+ version;
						window.open(pagina);
					}
				}
			});
		}
	}

	   
//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

	function mayor(fecha, fecha2){
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);



		if (xAnio > yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes > yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia > yDia){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}else{
				return false ;
			}
		} 
	}
	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha!= "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
				break;
			default:
				mensajeSis("Fecha introducida errónea  ");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea  ");
				return false;
			}
			return true;
		}
	}


	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	
});
