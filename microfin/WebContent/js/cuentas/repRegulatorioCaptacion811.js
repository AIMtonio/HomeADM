$(document).ready(function() {	
	esTab = true;
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();

	$('#fechaReporte').val(parametroBean.fechaSucursal);
	$(':text').focus(function() {	
    	esTab = false;
    });
  
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
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
	

   $.validator.setDefaults({submitHandler: function(event) {
	   
	    }
   });	
 
   
   $('#fechaReporte').change(function() {
		var Xfecha= $('#fechaReporte').val();
		if(Xfecha == '1900-01-01'){
			alert("Dede de indicar una Fecha no vacia");
			$('#fechaReporte').val(parametroBean.fechaSucursal);
		}else{
			if(Xfecha=='')$('#fechaReporte').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaSucursal;
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha es Mayor a la Fecha del Sistema.")	;
				$('#fechaReporte').val(parametroBean.fechaSucursal);
			}
   		}
	});

	$('#fechaReporte').blur(function() {
		var Xfecha= $('#fechaReporte').val();
		if(Xfecha == '1900-01-01'){
			alert("Dede de indicar una Fecha no vacia");
			$('#fechaReporte').val(parametroBean.fechaSucursal);
		}else{
			if(esFechaValida(Xfecha)){
				if(Xfecha=='')$('#fechaReporte').val(parametroBean.fechaSucursal);
				var Yfecha= parametroBean.fechaSucursal;
				if ( mayor(Xfecha, Yfecha) )
				{
					alert("La Fecha es Mayor a la Fecha del Sistema.")	;
					$('#fechaReporte').val(parametroBean.fechaSucursal);
				} 
			}else{
				$('#fechaReporte').val(parametroBean.fechaSucursal);
			}
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
  
   
    $('#generar').click(function() {
    	if($('#excel').is(":checked")){ 
    		generaReporteExcel();
		}
		else if($('#csv').is(":checked")){ 
			generaReporteCSV();
		}
	});

   
   function generaReporteExcel(){
	   var tipoReporte = 1;
	   var tipoLista = 1;
	   var pagina='regulatorioCap811Rep.htm?fecha='+$('#fechaReporte').val()+'&tipoReporte='+tipoReporte+ '&tipoLista='+tipoLista;
	   window.open(pagina);
   };
   
   function generaReporteCSV(){
	   var tipoReporte = 2;
	   var tipoLista = 2;
	   var pagina='regulatorioCap811Rep.htm?fecha='+$('#fechaReporte').val()+'&tipoReporte='+tipoReporte+ '&tipoLista='+tipoLista;
	   window.open(pagina);
   };
   		
   		   
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
//	FIN VALIDACIONES DE REPORTES


	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha!= "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("formato de fecha no válido (aaaa-mm-dd)");
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
				alert("Fecha introducida errónea  ");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea  ");
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
	/***********************************/
   
   
}); // fin ready
