var esTab=false;
var parametroBean = consultaParametrosSession();
$(document).ready(function() {
	
	inicializarPantalla();

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});
	
	$('#formaGenerica').validate({
		rules: {
			sucursal:{
				required: true
				}
		},
		messages: {
			sucursal:{
				required: 'Especificar la Sucursal.',
			}
		}
	});
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			
			var Yfecha= $('#fechaFinal').val();
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

	$('#fechaFinal').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFinal').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha ==''){
				$('#fechaFinal').val(parametroBean.fechaSucursal);
			}
			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFinal').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaFinal').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Fin  es Mayor a la Fecha del Sistema.");
					$('#fechaFinal').val(parametroBean.fechaSucursal);
				}				
			}
		}else{
			$('#fechaFinal').val(parametroBean.fechaSucursal);
		}

	});
	$('#generar').click(function() { 
		generaReporte();
	});
});

function inicializarPantalla(){
	consultaEstatus();
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFinal').val(parametroBean.fechaSucursal);
	$('#estatus').val("0");
	agregaFormatoControles('formaGenerica');
	$('#fechaInicio').focus();
	$('#fechaInicio').select();
}


function generaReporte(){
	if ($("#formaGenerica").valid()) {
		var fechaInicio = $("#fechaInicio").val();
		var fechaFinal = $("#fechaFinal").val();
		var estatus = $("#estatus").val();
		var usuario 	 = parametroBean.claveUsuario;
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var tipoReporte = $('input:radio[name=tipoReporte]:checked').val();
		var estatusDes = $("#estatus option:selected").text();


		var liga = 'reporteOperacionesInuPLD.htm?'+
		'fechaInicio='+fechaInicio+
		'&fechaFinal='+fechaFinal+
		'&estatus='+estatus+
		'&estatusDes='+estatusDes+
		'&usuario='+usuario+
		'&fechaSistema='+fechaAplicacion+
		'&nombreInstitucion='+nombreInstitucion+
		'&tipoReporte='+tipoReporte;
		window.open(liga, '_blank');
	}
}

function consultaEstatus() {
	dwr.util.removeAllOptions('estatus');
	dwr.util.addOptions('estatus', {
		'0' : 'TODAS'
	});
	estadosPreocupantesServicio.listaCombo(1,
			function(estatus) {
				dwr.util.addOptions('estatus', estatus, 'catEdosPreoID',
						'descripcion');
			});
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