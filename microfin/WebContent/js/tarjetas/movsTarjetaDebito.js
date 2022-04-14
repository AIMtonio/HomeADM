$(document).ready(function() {

	// Definicion de Constantes y Enums
	esTab = true;

	var catTipoRepMovimiento = { 
			'PDF' : 1
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	var parametroBean = consultaParametrosSession();
	
	agregaFormatoControles('formaGenerica');
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaVencimiento').val(parametroBean.fechaSucursal);
	$('#tipoTarjetaDeb').focus();
  	$('#tipoTarjetaDeb').attr("checked",false);
 	$('#tipoTarjetaCred').attr("checked",false);

	$('#pdf').attr("checked",true) ; 

	$(':text').focus(function() {
		esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({			
	   submitHandler: function(event) { 	    	  
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoOperacion');	   	 
		}
	});

	$('#fechaInicio').blur(function() {
		var Xfecha= $('#fechaInicio').val();
		var Zfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimiento').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) ){
					mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
		
	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimiento').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) ){
					mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaVencimiento').blur(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaVencimiento').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			if (mayor(Xfecha, Yfecha)){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaVencimiento').val(Xfecha);
			}
		}else{
			$('#fechaVencimiento').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaVencimiento').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaVencimiento').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimiento').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaVencimiento').val(Xfecha);
			}
		}else{
			$('#fechaVencimiento').val(parametroBean.fechaSucursal);
		}
	});


	//------------ Validaciones de Controles -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			fechaInicio :{
				required: true
			},
			fechaVencimiento:{
				required: true
			}			
		},
		
		messages: {
			fechaInicio :{
				required: 'Especifique la Fecha de Inicio.'
			},
			fechaVencimiento :{
				required: 'Especifique la Fecha Final.'
			}
		}
	});

	
	$('#generar').click(function() {
		var fechaInicio = $("#fechaInicio").val();
		var fechaVencimiento = $("#fechaVencimiento").val();
		var tipoOperacion = $("#tipoOperacion").val();
		if( fechaInicio ==''){
			mensajeSis("La fecha Inicio está Vacia");
			$('#fechaInicio').focus();
			 event.preventDefault();
		}else 
		
			if( fechaVencimiento ==''){
				mensajeSis("La fecha Fin está Vacia");
				$('#fechaVencimiento').focus();
				 event.preventDefault();
		}
			
		else{
			var tr = catTipoRepMovimiento.PDF;
			var reporte1 = 3;
			var reporte2 = 4;
			var reporte3 = 5;
			var tipoReporte = $("#tipoOperacion option:selected").val();
		
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;
			
	
			var nombreUsuario = parametroBean.claveUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 


			if ($("#tipoTarjetaDeb").is(':checked')){
				if(tipoOperacion == 3){
					$('#ligaGenerar').attr('href','movsTarjetaDebitoReporte.htm?'+
							'&fechaInicio='+fechaInicio+
							'&fechaVencimiento='+fechaVencimiento+
							'&tipoOperacion='+tipoOperacion+
							'&fechaEmision='+fechaEmision+
							'&tipoReporte='+tr+
							'&numeroReporte='+reporte1+
							'&nombreUsuario='+nombreUsuario.toUpperCase()+
							'&nombreInstitucion='+nombreInstitucion);
				}
				
				if(tipoOperacion == 4){
					$('#ligaGenerar').attr('href','movsTarjetaDebitoReporte.htm?'+
							'&fechaInicio='+fechaInicio+
							'&fechaVencimiento='+fechaVencimiento+
							'&tipoOperacion='+tipoOperacion+
							'&fechaEmision='+fechaEmision+
							'&tipoReporte='+tr+
							'&numeroReporte='+reporte2+
							'&nombreUsuario='+nombreUsuario.toUpperCase()+
							'&nombreInstitucion='+nombreInstitucion);
				}
				
				if(tipoOperacion == 5){
					$('#ligaGenerar').attr('href','movsTarjetaDebitoReporte.htm?'+
							'&fechaInicio='+fechaInicio+
							'&fechaVencimiento='+fechaVencimiento+
							'&tipoOperacion='+tipoOperacion+
							'&fechaEmision='+fechaEmision+
							'&tipoReporte='+tr+
							'&numeroReporte='+reporte3+
							'&nombreUsuario='+nombreUsuario.toUpperCase()+
							'&nombreInstitucion='+nombreInstitucion);
				}
			}
			else if ($("#tipoTarjetaCred").is(':checked')) {
				if(tipoOperacion == 3){
					$('#ligaGenerar').attr('href','movsTarjetaCreditoReporte.htm?'+
							'&fechaInicio='+fechaInicio+
							'&fechaVencimiento='+fechaVencimiento+
							'&tipoOperacion='+tipoOperacion+
							'&fechaEmision='+fechaEmision+
							'&tipoReporte='+tr+
							'&numeroReporte='+reporte1+
							'&nombreUsuario='+nombreUsuario.toUpperCase()+
							'&nombreInstitucion='+nombreInstitucion);
				}
				
				if(tipoOperacion == 4){
					$('#ligaGenerar').attr('href','movsTarjetaCreditoReporte.htm?'+
							'&fechaInicio='+fechaInicio+
							'&fechaVencimiento='+fechaVencimiento+
							'&tipoOperacion='+tipoOperacion+
							'&fechaEmision='+fechaEmision+
							'&tipoReporte='+tr+
							'&numeroReporte='+reporte2+
							'&nombreUsuario='+nombreUsuario.toUpperCase()+
							'&nombreInstitucion='+nombreInstitucion);
				}
				
				if(tipoOperacion == 5){
					$('#ligaGenerar').attr('href','movsTarjetaCreditoReporte.htm?'+
							'&fechaInicio='+fechaInicio+
							'&fechaVencimiento='+fechaVencimiento+
							'&tipoOperacion='+tipoOperacion+
							'&fechaEmision='+fechaEmision+
							'&tipoReporte='+tr+
							'&numeroReporte='+reporte3+
							'&nombreUsuario='+nombreUsuario.toUpperCase()+
							'&nombreInstitucion='+nombreInstitucion);
				}
			}

		}
	
		
	});



function lipiaCampos() {
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaVencimiento').val(parametroBean.fechaSucursal);
}
$('#tipoTarjetaDeb').click(function() {	
	lipiaCampos();
	$('#tipoTarjetaCred').attr("checked",false);
	$('#fechaInicio').focus();
	
});
$('#tipoTarjetaCred').click(function() {
	lipiaCampos();	
	$('#tipoTarjetaDeb').attr("checked",false);
	$('#fechaInicio').focus();
	
});


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
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha no Válida (aaaa-mm-dd)");
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
				mensajeSis("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea");
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