$(document).ready(function() {
	// Definicion de Constantes y Enums
	 
 
	var parametroBean = consultaParametrosSession();   
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaSucursal();
	var catTipoConsultaProveedores = {
			'principal'	: 1


	};	

	$('#pdf').attr("checked",true) ; 



	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);	

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

	});



	$('#generar').click(function() {	
		
		  generaReporteRequisicion(); 
	});

	function generaReporteRequisicion(){
		var tipoReporte = 0;
		var tipoLista = 0;
		var sucursal = $("#sucursal option:selected").val();
		var estatusEnc = $("#estatusEnc option:selected").val();
		var estatusDet = $("#estatusDet option:selected").val();
		var usuario = 	parametroBean.nombreUsuario; 
		
		if(estatusEnc=='T'){
			estatusEnc='';
		}
		
		if(estatusDet=='T'){
			estatusDet='';
		}
				
		var fechaEmision = parametroBean.fechaSucursal;

		if($('#fechaInicio').val()!= ''){
			var fechaInicio = $('#fechaInicio').val();	

		}else{
			alert("La fecha de inicio esta vacia");
			event.preventDefault();
		}

		if($('#fechaFin').val()!= ''){
			var fechaFin = $('#fechaFin').val();	 
		}else{
			alert("La fecha de fin esta vacia");
			event.preventDefault();
		}
		
		if($('#pantalla').is(':checked')){
			tipoReporte = 1;

		}
		if($('#pdf').is(':checked')){
			tipoReporte = 2;
		}
		
		/// VALORES TEXTO
		var nombreSucursal = $("#sucursal option:selected").val();
		var nombreUsuario = parametroBean.nombreUsuario; 
		
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var nombreEstatusEnc = $("#estatusEnc option:selected").html();
		var nombreEstatusDet = $("#estatusDet option:selected").html();
		
		if(nombreSucursal=='0'){
			nombreSucursal='';
		}
		else{
			nombreSucursal = $("#sucursal option:selected").html();
		}

		 
 

		$('#ligaGenerar').attr('href','reporteReqGastos.htm?fechaInicio='+fechaInicio+'&fechaFin='+
				fechaFin+'&sucursal='+sucursal+'&estatusEnc='+estatusEnc+'&estatusDet='+estatusDet+
				'&usuario='+usuario+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+
				'&nombreSucursal='+nombreSucursal+'&nombreUsuario='+nombreUsuario+'&parFechaEmision='+fechaEmision+ 
				'&nombreInstitucion='+nombreInstitucion+'&nombreEstatusEnc='+nombreEstatusEnc+'&nombreEstatusDet='+
				 nombreEstatusDet);


	}
	// ***********  Inicio  validacion Promotor, Estado, Municipio  ***********



	// fin validacion Promotor, Estado, Municipio


	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursal');
		dwr.util.addOptions( 'sucursal', {'0':'TODAS'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursal', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}

	 





//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

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
//	FIN VALIDACIONES DE REPORTES

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
