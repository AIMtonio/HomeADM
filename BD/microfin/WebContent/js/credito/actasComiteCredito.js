$(document).ready(function(){
	
	var opcionSucursal=1;
	var parametroBean = consultaParametrosSession();
	esTab = true;
	
	$('#tipoActa').focus();
	
	$('#fechaReporte').val(parametroBean.fechaSucursal);
	agregaFormatoControles('formaGenerica');	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	$("#pdf").attr("checked","true");
	$('#tipoReporte').val('2');
		
	$(':text').focus(function() {
		esTab = false;
	});
	
	$('#sucursalID').bind('keyup',function(e) {
		lista('sucursalID', '1', '1','nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});

	$('#sucursalID').blur(function() {
		if($('#sucursalID').val()!=''){
			consultaSucursal(this.id);				
		}else{
			$('#nombreSucursal').val('');			
		}
		
	});	
	
	$('#fechaReporte').change(function() {
		var Xfecha= $('#fechaReporte').val();		
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaReporte').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaSucursal;
			if ( mayor(Xfecha, Yfecha) ){
					alert("La fecha seleccionada no debe ser mayor a la de hoy.")	;
					$('#fechaReporte').val(parametroBean.fechaSucursal);				
			}
		}else{
			$('#fechaReporte').val(parametroBean.fechaSucursal);
		}
	});
	$('#tipoActa').change(function(){
		$('#fechaReporte').val(parametroBean.fechaSucursal);		
		if($('#tipoActa').val()==1){			
			$('#filaSucursal').show(200);
			$('#sucursalID').focus();
		}else{
			$('#filaSucursal').hide(200);
			$('#sucursalID').val('');
			$('#nombreSucursal').val('');		
		}if($('#tipoActa').val()>1){
			$('#fechaReporte').focus();
		}
	});	
	$('#generar').click(function(){
		$('#ligaGenerar').removeAttr("href");
		if($('#tipoActa').val()!=''){
			if($('#fechaReporte').val()!=''){
				if($('#tipoActa').val()==opcionSucursal){
					if($('#sucursalID').val()!=''){
							generaLiga();						
					}else{
						alert("Sucursal requerida");
						$('#sucursalID').focus();
					}				
				}else{
					generaLiga();
				}
			}else{
				alert('Fecha del reporte requerida');
				$('#fechaReporte').focus();
			}
		}else{
			alert("Tipo de Acta requerido");
			$('#tipoActa').focus();
		}					
	});


//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE
	
	
	function generaLiga(){
		var sucursal = $("#sucursalID").val();
		var tipoActa=$('#tipoActa').val();
		var fecha = $('#fechaReporte').val();
		$('#ligaGenerar').attr('href','actasComiteCreditoRep.htm?fechaReporte='+fecha+'&sucursalID='+sucursal+'&tipoActa='+tipoActa);
	}

	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
			sucursalesServicio.consultaSucursal(conSucursal,
					numSucursal, function(sucursal) {
						if (sucursal != null) {
							$('#nombreSucursal').val(sucursal.nombreSucurs);
						} else {
							alert("No Existe la Sucursal");							
							$('#sucursalID').focus();
							$('#sucursalID').val('');
							$('#nombreSucursal').val('');
						}
					});
		}
	}	
	
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
});