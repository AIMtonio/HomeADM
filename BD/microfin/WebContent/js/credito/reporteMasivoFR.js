$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();   

	var catTipoListaRepSalTCred = {
			'repTotalExcel'	: 6 

	};	

	var catTipoRepSalTCredito = { 
			'frPantalla'	: 1,
			'frTxt'	: 2,
			'frExcel'		: 3 
	};	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();



	$(':text').focus(function() {	
		esTab = false;
	});



	//------------ Validaciones de la Forma -------------------------------------

	// inicio modificacion 06/09/2012

	$('#fechaInicio').val(parametroBean.fechaSucursal);

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
		if(esFechaValida(Xfecha)){
			var Yfecha= parametroBean.fechaSucursal;
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});
	$('#excel').attr('checked',true);

	$('#generar').click(function() { 

		if($('#aTxt').is(":checked") ){
			generaTXT();
		}

		if($('#excel').is(":checked") ){
			generaExcel();
		}

	});




	function generaExcel() {
		$('#aTxt').attr("checked",false) ;
		$('#pantalla').attr("checked",false); 
		if($('#excel').is(':checked')){	// alert('hola');
			var tr= catTipoRepSalTCredito.frExcel; 
			var tl= catTipoListaRepSalTCred.repTotalExcel;  

			var fechaInicio = $('#fechaInicio').val();	 

			$('#ligaGenerar').attr('href','ReporteMasivoFR.htm?fechaInicio='+fechaInicio+'&tipoReporte='+tr+'&tipoLista='+tl);



		}
	}

	function generaTXT() {	
		if($('#aTxt').is(':checked')){	
			$('#pantalla').attr("checked",false) ; 
			$('#excel').attr("checked",false); 
			var tr= catTipoRepSalTCredito.frTxt; 
			var tl= catTipoListaRepSalTCred.repTotalExcel;  
			var fechaInicio = $('#fechaInicio').val();	 

			$('#ligaGenerar').attr('href','ReporteMasivoFR.htm?fechaInicio='+fechaInicio+'&tipoReporte='+tr+'&tipoLista='+tl);

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
	/***********************************/

});
