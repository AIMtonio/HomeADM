$(document).ready(function() {
	// Definicion de Constantes y Enums
	 
 
	var parametroBean = consultaParametrosSession();   
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	var catTipoTransaccion = {
			'alta'	: 1
	};	

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);	
	$('#enlaceExp').removeAttr("href");
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
			  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','false',
			  'funcionExito','funcionError');
		}
	});	
		
	
	
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			var Yfecha= $('#fechaFin').val();
			if (mayor(Xfecha, Yfecha)){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		var Zfecha = parametroBean.fechaSucursal;
		if(esFechaValida(Yfecha)){
			if(Yfecha==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if (mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if(mayor(Yfecha, Zfecha)){
				mensajeSis("La Fecha Final es mayor a la Fecha del Sistema.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

	});



	$('#grabar').click(function() {		
		$("#tipoTransaccion").val(catTipoTransaccion.alta);	
	});

	
	$('#formaGenerica').validate({

		rules: {
		},		
		messages: {		

		}
		
	});

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
	
	

	
});

//Funcion de Exito
function funcionExito(){
	var paginaArchSantader ='generaArchText.htm?fechaInicio='+$("#fechaInicio").val()+
													'&fechaFin='+$("#fechaFin").val()+
													'&tipoCta='+"A"+
													'&nombreArch='+"CuentasBanSantander"+
													'&estatus='+"E"+
													'&tipoArchivo='+"1"+
													'&extension='+".txt";
		window.open(paginaArchSantader,'_blank');

		var paginaArchOtros ='generaArchText.htm?fechaInicio='+$("#fechaInicio").val()+
												'&fechaFin='+$("#fechaFin").val()+
												'&tipoCta='+"O"+
												'&nombreArch='+"CuentasBanOtros"+
												'&estatus='+"E"+
												'&tipoArchivo='+"1"+
												'&extension='+".txt";
		window.open(paginaArchOtros,'_blank');
		
}

//Funcion de Error
function funcionError(){
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
}
