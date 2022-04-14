$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var catTipoRepEstatusTarjeta = {	
		'PDF'		: 1
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	var parametroBean = consultaParametrosSession();
	
	agregaFormatoControles('formaGenerica');
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	$('#fechaVencimiento').val(parametroBean.fechaSucursal);

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
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','estatus');	   	 
		}
	});

	$('#fechaRegistro').blur(function() {
		var Xfecha= $('#fechaRegistro').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaRegistro').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimiento').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) ){
					alert("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaRegistro').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaRegistro').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaRegistro').change(function() {
		var Xfecha= $('#fechaRegistro').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaRegistro').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimiento').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) ){
					alert("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaRegistro').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaRegistro').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaVencimiento').blur(function() {
		var Xfecha= $('#fechaRegistro').val();
		var Yfecha= $('#fechaVencimiento').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			if (mayor(Xfecha, Yfecha)){
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaVencimiento').val(Xfecha);
			}
		}else{
			$('#fechaVencimiento').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaVencimiento').change(function() {
		var Xfecha= $('#fechaRegistro').val();
		var Yfecha= $('#fechaVencimiento').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimiento').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaVencimiento').val(Xfecha);
			}
		}else{
			$('#fechaVencimiento').val(parametroBean.fechaSucursal);
		}
	});


	//------------ Validaciones de Controles -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			fechaRegistro :{
				required: true
			},
			fechaVencimiento:{
				required: true
			}			
		},
		
		messages: {
			fechaRegistro :{
				required: 'Especifique la Fecha de Inicio.'
			},
			fechaVencimiento :{
				required: 'Especifique la Fecha Final.'
			}
		}
	});

	// funcion para llenar el combo de Tipos de Tarjeta
	
	
	$('#generar').click(function() {
		var fechaRegistro = $("#fechaRegistro").val();
		var fechaVencimiento = $("#fechaVencimiento").val();
		var estatus = $("#estatus").val();
		if( fechaRegistro ==''){
			alert("La fecha Inicio está Vacia");
			$('#fechaRegistro').focus();
			 event.preventDefault();
		}else 
		
			if( fechaVencimiento ==''){
				alert("La fecha Fin está Vacia");
				$('#fechaVencimiento').focus();
				 event.preventDefault();
		}
			if( estatus ==''){
				alert("Seleccione el Estatus");
				$('#estatus').focus();
				 event.preventDefault();
		}
		else{
			var tr= catTipoRepEstatusTarjeta.PDF;
			var estatus = $("#estatus option:selected").val();
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;
			
			/// VALORES TEXTO
			var nombreUsuario = parametroBean.claveUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
		
			$('#ligaGenerar').attr('href','TarDebReporteEstatus.htm?'+'&fechaRegistro='+fechaRegistro+
					'&fechaVencimiento='+fechaVencimiento+'&estatus='+estatus
					+'&fechaEmision='+fechaEmision+
					'&usuario='+usuario+'&tipoReporte='+tr+
					'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion);
		}
	
		
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
				alert("Formato de Fecha no Válida (aaaa-mm-dd)");
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
});