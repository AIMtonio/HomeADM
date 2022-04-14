$(document).ready(function(){
	agregaFormatoControles('formaGenerica');
	var parametroBean=consultaParametrosSession();

	var catTipoReporte = {
		'cartera'	: '1',
		'captacion'	: '2',
		'aportaciones'	: '3'
	};
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});	
	$('#formaGenerica').validate({
		rules:{
			tipoReporte:{
				required : true
			},
			fechaReporte:{
				required: true
			}
		},
		messages:{
			tipoReporte:{
				required: 'Especifique un Tipo de Reporte'
			},
			fechaReporte:{
				required: 'Especifique una Fecha de Reporte'
			}
		}		
	});
	
	$(':text').focus(function() {
		esTab = false;
	});	
	$('#fechaReporte').val(parametroBean.fechaSucursal);
	$('#empresaID').val(parametroBean.numeroSucursalMatriz);
	
	$('#csv').attr("checked",true);
	$('#tipoNormal').attr('checked',true);
	$('#secTipoRepCar').hide();

	$('#csv').click(function() {
		$('#csv').attr("checked",true); 
		$('#excel').attr("checked",false); 
	});

	$('#excel').click(function() {
		$('#csv').attr("checked",false); 
		$('#excel').attr("checked",true); 

	});
	
	//Validacion al generar los reportes en CSV y Excel
	$('#genera').click(function(){
		$('#ligaGenerar').removeAttr("href");
		if($('#tipoReporte').val()==''){
				mensajeSis('Especifique un tipo de Reporte');
				$('#tipoReporte').focus();
				
		}else if($('#fechaReporte').val()==''){
				mensajeSis('Especifique una Fecha de Reporte');
				$('#fechaReporte').focus();
		}else if($('#csv').is(":checked")){
			generaCSV();
			$('#tipoReporte').focus();			
		}
		else if($('#excel').is(":checked")){
			generaExcel();
			$('#tipoReporte').focus();			
		}
	});
	
	
	$('#tipoReporte').change(function(){
		$('#fechaReporte').val(parametroBean.fechaSucursal);
		if ($('#tipoReporte').val()=="1") {
			$('#secTipoRepCar').show();
		}else{
			$('#secTipoRepCar').hide();
		}
	});
	
	/* Validacion fecha del reporte */
	$('#fechaReporte').change(function() {
		var Xfecha= $('#fechaReporte').val();
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
				if(Xfecha > Yfecha) {
					alert("La Fecha de Corte es Mayor a la Fecha del Sistema.");
					$('#fechaReporte').val(parametroBean.fechaSucursal);
				}				
			}
		regresarFoco('fechaReporte');
	});
	

	/* Funcion para generar el reporte en CSV */
	function generaCSV(){	
		$('#excel').attr("checked",false);
		if($('#csv').is(':checked')){	
		$('#ligaGenerar').attr('href','reportesFOCOOPRep.htm?tipoReporte='+$('#tipoReporte').val()+
				'&fechaReporte='+$('#fechaReporte').val()+'&empresa='+$('#empresaID').val()+
				'&tipoRepCar='+$('[name=tipoRepCar]:checked').val());
		}	
	}
	
	/* Funcion para generar el reporte en Excel */
	function generaExcel(){	
		$('#csv').attr("checked",false);
		if($('#excel').is(':checked')){	
		var tipoPresentacion ="";
		var tipoLista = "";  
		var nombreUsuario=parametroBean.claveUsuario;
		var nombreInstitucion=parametroBean.nombreInstitucion;
		var fechaEmision=parametroBean.fechaSucursal;
		
		if($('#tipoReporte').val()==1)	{
			tipoLista = 1;
			tipoPresentacion =catTipoReporte.cartera; 
		}
		else if($('#tipoReporte').val()==2)	{
			tipoLista = 2;
			tipoPresentacion =catTipoReporte.captacion; 
		}
		else {
			tipoLista = 3;
			tipoPresentacion =catTipoReporte.aportaciones; 
		}
	
		$('#ligaGenerar').attr('href','reportesFOCOOPRep.htm?tipoPresentacion='+tipoPresentacion+'&tipoLista='+tipoLista
				+'&fechaReporte='+$('#fechaReporte').val()+'&empresa='+$('#empresaID').val()
				+'&nombreInstitucion='+nombreInstitucion+'&nombreUsuario='+nombreUsuario
				+'&parFechaEmision='+fechaEmision+'&tipoRepCar='+$('[name=tipoRepCar]:checked').val());
		
		}
	}
	
	
	/* Funcion valida fecha formato (yyyy-MM-dd)*/
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				alert("Fecha introducida errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea.");
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
	
	function regresarFoco(idControl){
		
		var jqControl=eval("'#"+idControl+"'");
		setTimeout(function(){
			$(jqControl).focus();
		 },0);
	}
	
	/***********************************/
	
});