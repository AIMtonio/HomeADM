$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');
	$('#tipoRep').val('');
	$('#lfec').show();
	$('#fechaInicio').val(parametroBean.fechaSucursal);	
	$('#fecFin').hide();
	$('#lfecFin').hide();
    $('#lfecIni').hide();
	$('#excel').attr("checked",true) ; 

	
	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {
		esTab = false;
	});
	
	$.validator.setDefaults({
		submitHaandler: function(event) { 

		}
	});		
	
	$('#tipoRep').change(function(){
		if($('#tipoRep').val() == '1' || $('#tipoRep').val() == '2'){
			$('#fecFin').show();
			$('#lfecFin').show();
			$('#fechaFin').val(parametroBean.fechaSucursal);
			$('#lfecIni').show();
			$('#lfec').hide();
		
		}
		else if($('#tipoRep').val() == '3'){
			$('#fecFin').hide();
			$('#lfecFin').hide();
			$('#fechaFin').val('1900-01-01');
			$('#lfecIni').hide();
			$('#lfec').show();
		}
		});
	
	
	
	$('#fechaInicio').change(function() {
		if($('#tipoRep').val() == '1' || $('#tipoRep').val() == '2'){
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaInicio').val() > parametroBean.fechaSucursal) {
					alert("La Fecha de Inicio es Mayor a la Fecha del Sistema.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
		}
	});

	$('#fechaFin').change(function() {
		if($('#tipoRep').val() == '1' || $('#tipoRep').val() == '2' || $('#tipoRep').val() == ''){
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha ==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaFin').val() > parametroBean.fechaSucursal) {
					alert("La Fecha de Fin  es Mayor a la Fecha del Sistema.");
					$('#fechaFin').val(parametroBean.fechaSucursal);
				}				
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
		}

	});
	
	$('#fechaInicio').change(function() {
		if($('#tipoRep').val() == '3'|| $('#tipoRep').val() == ''){
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			
				if($('#fechaInicio').val() > parametroBean.fechaSucursal) {
					alert("La Fecha  es Mayor a la Fecha del Sistema.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}else{
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}
		
	});
	
	
	$('#generar').click(function() { 
		if($('#tipoRep').val() == ''){
			$('#ligaGenerar').removeAttr("href"); 
			alert('Especifique el Tipo de Reporte');
			$('#tipoRep').focus();
			}
		else{
			generaExcel();
		}

	});	
	
//	------------ Validaciones de la Forma -------------------------------------


	function generaExcel(){	
	
		var fechaInicio = $('#fechaInicio').val();	 
		var fechaFin = $('#fechaFin').val();	 			
		var tipoRep       	= $('#tipoRep').val();

		var usuario 	  = parametroBean.claveUsuario;
		var nombreUsuario = parametroBean.claveUsuario; 			
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var fechaEmision	  =  parametroBean.fechaSucursal;
		var hora='';
		var horaEmision= new Date();
		hora = horaEmision.getHours();
		hora = hora+':'+horaEmision.getMinutes();
		hora = hora+':'+horaEmision.getSeconds();

		
		var paginaReporte= 'RepConvencionSeccional.htm?fechaInicio='+fechaInicio+'&fechaFin='+fechaFin+
		'&tipoRep='+tipoRep+'&usuario='+usuario+'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+
		'&fechaEmision='+fechaEmision+'&horaEmision='+hora;			
		$('#ligaGenerar').attr('href',paginaReporte);
	
}


//	FIN VALIDACIONES DE REPORTES

	  /*=== Validaciones para la forma ====  */
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


	/*==== Funcion valida fecha formato (yyyy-MM-dd) =====*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
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
				alert("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea");
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

	
	

}); // Fin Document

