$(document).ready(function() {

	esTab = true;
	var parametroBean = consultaParametrosSession();
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#personaFisica').attr("checked",true);
	$('#mensual').attr("checked",true);
	$('#personaFisica').focus();

	// Tipo de Reporte
	var car_TipoReporte = {
		'personaFisica' : 1,
		'personaMoral'  : 2
	};

	// Tipo de Persona
	var cat_TipoLista = {
		'semanal' : 1,
		'mensual' : 2
	};


	agregaFormatoControles('formaGenerica');
		$('#fechaFin').blur(function() {
	});

	 $('#fechaFin').change(function() {
		var Xfecha= $('#fechaFin').val();
		$('#fechaFin').focus();
		if(esFechaValida(Xfecha)){
			if(Xfecha==true)$('#fechaFin').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaSucursal;
			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha Seleccionada no Debe ser Mayor a la de Hoy.");
				$('#fechaFin').focus();
				$('#fechaFin').val(parametroBean.fechaSucursal);
				habilitaBoton('enviar', 'button');
			}else{
				habilitaBoton('enviar', 'button');
			}
		}
		else {
			$('#fechaFin').focus();
			$('#fechaFin').val(parametroBean.fechaSucursal);
			habilitaBoton('enviar', 'button');
		}
	});


	$('#personaFisica').click(function() {
		$('#personaFisica').attr("checked",true);
		$('#personaMoralFisica').attr("checked",false);
		$('#personaMoralFisica').focus();
	});

	$('#personaFisica').blur(function() {
		$('#personaMoralFisica').focus();
	});

	$('#personaMoralFisica').click(function() {
		$('#personaMoralFisica').attr("checked",true);
		$('#personaFisica').attr("checked",false);
		$('#mensual').focus();
	});

	$('#personaMoralFisica').blur(function() {
		$('#mensual').focus();
	});

	$('#mensual').click(function() {
		$('#mensual').attr("checked",true);
		$('#semanal').attr("checked",false);
		$('#semanal').focus();
	});

	$('#mensual').blur(function() {
		$('#semanal').focus();
	});

	$('#semanal').click(function() {
		$('#semanal').attr("checked",true);
		$('#mensual').attr("checked",false);
		$('#fechaFin').focus();
	});

	$('#semanal').blur(function() {
		$('#fechaFin').focus();
	});

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$('#formaGenerica').validate({
		rules: {
			fechaFin: {
				required: true,
				date: true
			},
		},

		messages: {
			fechaFin: {
				required:'Especifique Fecha.',
				date: 'Fecha Incorrecta.'
			},
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$('#enviar').click(function() {
		consultaCintaCirculo();
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});


	function consultaCintaCirculo() {
		var tipoLista = 0;
		var tipoReporte = 0;

		if($('#personaFisica').is(':checked')){
			tipoReporte = car_TipoReporte.personaFisica;
		} else {
			tipoReporte = car_TipoReporte.personaMoral;
		}

		if($('#mensual').is(':checked')){
			tipoLista = cat_TipoLista.mensual;
		} else {
			tipoLista = cat_TipoLista.semanal;
		}

		var fechaConsulta = $('#fechaFin').val();
		var parametros = "?fechaConsulta="+fechaConsulta+"&tipoLista="+tipoLista+"&tipoReporte="+tipoReporte;

		var pagina="circuloVerArchivos.htm"+parametros;
		$('#ligaGenerar').attr('href',pagina);
		//window.location=pagina;
	}

	function esFechaValida(fecha){
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd).");
				$("label.error").hide();
				$(".error").removeClass("error");
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
				mensajeSis("Fecha introducida errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea.");
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

});