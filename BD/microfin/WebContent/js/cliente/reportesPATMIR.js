$(document).ready(function(){
	agregaFormatoControles('formaGenerica');
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
//	$.validator.setDefaults({
//			submitHandler: function(event){
//				grabaFormaTransaccion(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','numero');	
//			}
//	});
//	
	$('#formaGenerica').validate({
		rules:{
			tipoReporte:{
				required : true
			},
			fechaReporte:{
				required: true
			},
			tipoRep:{
				required: true
			},
			tipoRepMenores:{
				required: true
			}
		},
		messages:{
			tipoReporte:{
				required: 'Especifique un Tipo de Reporte'
			},
			fechaReporte:{
				required: 'Especifique una Fecha de Reporte'
			},
			tipoRep:{
				required: 'Especifique un Tipo de Reporte'
			},
			tipoRepMenores:{
				required:'Especifique un Tipo de Reporte'
			}
		}
		
	});
	$(':text').focus(function() {
		esTab = false;
	});
	$('#filaMenores').hide();
	$('#fechaReporte').val(parametroBean.fechaSucursal);
	
	$('#tipoRep').change(function(){
		if($('#tipoRep').val() == 1){
			$('#filaMenores').hide();
			$('#filaSocio').show();
		}else if($('#tipoRep').val() == 2){
			$('#filaSocio').hide();
			$('#filaMenores').show();
		}
	});	
	
	$('#genera').click(function(){	
		$('#ligaGenerar').removeAttr("href");		
		if($('#tipoRep').val()== 1){		
			if($('#tipoReporte').val()==''){
				alert('Especifique un Tipo de Reporte');
				$('#tipoReporte').focus();
				
			}else if($('#fechaReporte').val()==''){
				alert('Especifique una Fecha de Reporte');
				$('#fechaReporte').focus();
			}else{
			generaLiga();
			$('#tipoReporte').focus();			
			}
		}else if($('#tipoRep').val()==2){
			if($('#tipoRepMenores').val()==''){
				alert('Especifique un Tipo de Reporte');
				$('#tipoRepMenores').focus();
				
			}else if($('#fechaReporte').val()==''){
				alert('Especifique una Fecha de Reporte');
				$('#fechaReporte').focus();
			}else{
			generaLiga();
			$('#tipoRepMenores').focus();			
			}
			
		}
	});
	$('#tipoReporte').change(function(){
		$('#fechaReporte').val(parametroBean.fechaSucursal);		
	});
	$('#fechaReporte').change(function(){
		var Xfecha= $('#fechaReporte').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if(Xfecha==''){
			$('#fechaReporte').val(parametroBean.fechaSucursal);
		}else{
				if(esFechaValida(Xfecha)){
				if (mayor(Xfecha, Yfecha)){
					alert("La Fecha Capturada es Mayor a la de Hoy");
					$('#fechaReporte').val(parametroBean.fechaSucursal);
					$('#fechaReporte').focus();
				}else{
					if(esTab==false){
						$('#fechaReporte').focus();
					}
				}
				}else{
					$('#fechaReporte').val(parametroBean.fechaSucursal);
					$('#fechaReporte').focus();
				}
		}
	});
	
	$('#fechaReporte').blur(function(){		
		var Xfecha= $('#fechaReporte').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if (esTab == true) {
			if(esFechaValida(Xfecha)){					
				if ( mayor(Xfecha, Yfecha) ){
					alert("La Fecha Capturada es Mayor a la de Hoy");
					$('#fechaReporte').val(parametroBean.fechaSucursal);
					$('#fechaReporte').focus();
				}
			}else{
				$('#fechaReporte').val(parametroBean.fechaSucursal);
				$('#fechaReporte').focus();
			}
		}
	});
	function generaLiga(){	
		if($('#tipoRep').val()==1){		
			$('#ligaGenerar').attr('href','reportesPATMIRRep.htm?tipoReporte='+$('#tipoReporte').val()+'&fechaReporte='+$('#fechaReporte').val());
		}else if($('#tipoRep').val()==2){
			$('#ligaGenerar').attr('href','reportesPATMIRRep.htm?tipoReporte='+$('#tipoRepMenores').val()+'&fechaReporte='+$('#fechaReporte').val());
		}
	}
	
	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("Formato de Fecha no Válido (aaaa-mm-dd)");
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				alert("Fecha Introducida Errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha Introducida Errónea.");
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
	function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
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
	/***********************************/	
});

