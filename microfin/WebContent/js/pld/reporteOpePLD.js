var esTab=false;
var parametroBean = consultaParametrosSession();
var Cat_TipoOpera ={
	'reelevantes':2
};
$(document).ready(function() {
	
	inicializarPantalla();
	
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
	
	$('#formaGenerica').validate({
		rules: {
			tipoOperacion:{
				required: true
				}
		},
		messages: {
			tipoOperacion:{
				required: 'El Tipo de Reporte es Requerido.',
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
	$('#tipoOperacion').change(function() { 
		var tipo=$('#tipoOperacion').asNumber();
		if(tipo==Cat_TipoOpera.reelevantes){
			$('#estatus').val("0");
			deshabilitaControl("estatus");
		} else {
			habilitaControl("estatus");
		}
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
});

function inicializarPantalla(){
	consultaEstatus();
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFinal').val(parametroBean.fechaSucursal);
	$('#estatus').val("0");
	$('#tipoOperacion').val("0");
	agregaFormatoControles('formaGenerica');
	$('#tipoOperacion').focus();
	$('#tipoOperacion').select();
}


function generaReporte(){
	if ($("#formaGenerica").valid()) {
		var fechaInicio = $("#fechaInicio").val();
		var fechaFinal = $("#fechaFinal").val();
		var tipoOperacion = $("#tipoOperacion").asNumber();
		if(tipoOperacion>0){
		var estatus = $("#estatus").val();
		var operaciones = $("#operaciones option:selected").val();
		var usuario 	 = parametroBean.claveUsuario;
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var tipoReporte = $('input:radio[name=tipoReporte]:checked').asNumber();
		var estatusDes = $("#estatus option:selected").text();
		var descOperaciones = $("#operaciones option:selected").text();
		var tituloReporte = "";
		if(tipoOperacion==1){
		tituloReporte 		= 'REPORTE DE OPERACIONES INUSUALES DEL DÍA '+ fechaInicio+' AL ' +fechaFinal+ '.';
		} else if(tipoOperacion==2){
		tituloReporte 		= 'REPORTE DE OPERACIONES RELEVANTES DEL DÍA '+ fechaInicio+' AL ' +fechaFinal+ '.';
		} else if(tipoOperacion==3){
		tituloReporte 		= 'REPORTE DE OPERACIONES INTERNAS PREOCUPANTES DEL DÍA '+ fechaInicio + ' AL '+fechaFinal+'.';
		}
		var liga = 'reporteOperacionesPLD.htm?'+
		'fechaInicio='+fechaInicio+
		'&fechaFinal='+fechaFinal+
		'&estatus='+estatus+
		'&estatusDes='+estatusDes+
		'&operaciones='+operaciones+
		'&descOperaciones='+descOperaciones+
		'&usuario='+usuario+
		'&fechaSistema='+fechaAplicacion+
		'&nombreInstitucion='+nombreInstitucion+
		'&tituloReporte='+tituloReporte+
		'&tipoReporte='+tipoReporte+
		'&tipoOperacion='+tipoOperacion;
		window.open(liga, '_blank');
		} else {
			mensajeSis("Seleccione el Tipo de Reporte.");
		}
			
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