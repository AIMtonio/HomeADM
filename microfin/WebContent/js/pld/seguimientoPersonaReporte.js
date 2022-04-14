/**
 * 
 */
var parametroBean;
var esTab = true;
var fechaSis;

$(document).ready(function() {
	parametroBean = consultaParametrosSession();
	fechaSis = (parametroBean.fechaSucursal);
	
	agregaFormatoControles('formaGenerica');
	
	$('#fechaInicio').val(fechaSis);
	$('#fechaFin').val(fechaSis);
	$('#excel').attr("checked", true);
	
	var clienteSofi = 15;  // Número de cliente que corresponde a SOFI EXPRESS.
	var numeroCliente = 0;
	numeroCliente = consultaClienteEspecifico();

	if (numeroCliente == clienteSofi) {
		$('#trOperaciones').show();
	}else{
		$('#trOperaciones').hide();
	}
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});
	
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaInicio').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Inicio es Mayor a la Fecha del Sistema.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha ==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaFin').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Fin  es Mayor a la Fecha del Sistema.");
					$('#fechaFin').val(parametroBean.fechaSucursal);
				}				
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

	});
	
	
	$('#generar').click(function() {	
		generaReporte();
	});
	
	// Función para consultar el Cliente Especifico
	function consultaClienteEspecifico() {
		var numeroCliente = 0;
		paramGeneralesServicio.consulta(13, {
			async: false, callback: function (valor) {
				if (valor != null) {
					numeroCliente = valor.valorParametro;
				}
			}
		});
		return numeroCliente;
	}
	
});//Fin document ready



function generaReporte() {
	var fechaInicio = $('#fechaInicio').val();
	var fechaFin = $('#fechaFin').val();
	var operaciones = $("#operaciones option:selected").val();
	var tipoReporte = $('input:radio[name=tipoReporte]:checked').val();
	var tipoLista = 1;
	var fechaSis = parametroBean.fechaSucursal;
	var nombreUsuario = parametroBean.claveUsuario;
	var nombreInstitucion = parametroBean.nombreInstitucion;
	
	var descOperaciones;
	if(operaciones == ""){
		descOperaciones = 'TODOS';
	}else{
		descOperaciones = $("#operaciones option:selected").html();
	}
	
	var url = 'reporteCoincidenciasListas.htm?'+
		'fechaInicio=' + fechaInicio +
		'&fechaFin=' + fechaFin +
		'&operaciones='+operaciones+
		'&descOperaciones='+descOperaciones+
		'&tipoReporte=' + tipoReporte +
		'&tipoLista=' + tipoLista + '&fechaSistema=' + fechaSis + '&nombreUsuario=' + nombreUsuario + '&nombreInstitucion=' + nombreInstitucion;
	window.open(url, "_blank");
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