//VARIABLES

//CONSTANTES
var constanteTotalCartera = 'T';
var constanteCredNacPeriodo = 'P';

//INICIO DOCUMENT READY
$(document).ready(function() {
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	//SUBMIT
	$.validator.setDefaults({
		submitHandler: function(event) {
			
		}
	});
	inicializaPantalla();
	
	$('#generar').click(function(event){
		var periodo = $('#periodo').val();
		if($('#creditosNacPeriodo').is(':checked')){
			if(periodo == '' || periodo == undefined || periodo == null || periodo== NaN){
				mensajeSis("Especifique el Periodo");
				$('#periodo').focus();
			}else{
				generaReporteTXT();
			}
		}else{
			generaReporteTXT();
		}
		
	});

	$('#periodo').change(function(){
		validaPeriodo();
	});

	$('#totalCartera').click(function(){
		deshabilitaControl('periodo');
		$('.ui-datepicker-trigger').hide();
		$('#periodo').val('');
	});

	$('#creditosNacPeriodo').change(function(){
		habilitaControl('periodo');
		$('.ui-datepicker-trigger').show();
		agregaCalendario('formaGenerica');
	});

	$('#formaGenerica').validate({
		rules: {
			periodo: {
					required: function() { if(devuelveRangoCartera() === 'P') return true; else return false; }
			}
		},

		messages: {
			periodo: {
				required: 'Especifique el periodo.'
			}
		},
	});
});
// FIN DOCUMENT READY 


function generaReporteTXT(){
	var tipoCartera = $('#tipoCartera').val();
	var rangoCartera = devuelveRangoCartera();
	var periodo = $('#periodo').val();
	var estatusCredito = $('#estatusCredito').val();
	var tipoReporte = $('#tipoReporte').val();

	pagina='repBuroCalifica.htm?tipoCartera='+tipoCartera+'&rangoCartera='+rangoCartera+ '&periodo='+periodo+ 
	'&estatusCredito='+ estatusCredito+'&tipoReporte='+ tipoReporte;
	window.open(pagina);
}


function devuelveRangoCartera(){
	if($('#totalCartera').is(':checked')){
		return constanteTotalCartera;
	}
	if($('#creditosNacPeriodo').is(':checked')){
		return constanteCredNacPeriodo;
	}
}

function validaPeriodo(){
	var fechaPeriodo = $('#periodo').val();
	var fechaSucursal = parametroBean.fechaSucursal;

	if(esFechaValida(fechaPeriodo)){
		if ( mayor(fechaPeriodo, fechaSucursal) ){
			mensajeSis("La Fecha del Periodo no puede ser mayor a la fecha de la sucursal")	;
			$('#periodo').val(parametroBean.fechaSucursal);
			$('#periodo').focus();

		}
	}else{
		$('#periodo').val(parametroBean.fechaSucursal);
		$('#periodo').focus();
	}
	$('#periodo').focus();
}

function inicializaPantalla(){
	agregaCalendario('formaGenerica');
	$('#tipoCartera').focus();
	$("#totalCartera").attr('checked', 'checked');
	deshabilitaControl('periodo');
	$('.ui-datepicker-trigger').hide();
}

//valida que la fecha tenga un formato valido
function esFechaValida(fecha){
	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("Formato de fecha no válido (aaaa-mm-dd)");
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

// Devuelve si la fecha uno es mayor a la dos
function mayor(fechaUNO, fechaDOS){
	var mesUNO=fechaUNO.substring(5, 7);
	var diaUNO=fechaUNO.substring(8, 10);
	var anioUNO=fechaUNO.substring(0,4);

	var mesDOS=fechaDOS.substring(5, 7);
	var diaDOS=fechaDOS.substring(8, 10);
	var anioDOS=fechaDOS.substring(0,4);

	if (anioUNO > anioDOS){
		return true;
	}else{
		if (anioUNO == anioDOS){
			if (mesUNO > mesDOS){
				return true;
			}
			if (mesUNO == mesDOS){
				if (diaUNO > diaDOS){
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