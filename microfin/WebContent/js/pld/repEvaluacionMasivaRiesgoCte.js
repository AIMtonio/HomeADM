$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();

	var catTipoRepVencimientos = { 
		'PDF'		: 1,
		'EXCEL'		: 2
	};
	
	inicializa();

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#fechaInicio').change(function() {
		var fechaInicial= $('#fechaInicio').val().trim();
		if(esFechaValida(fechaInicial)){
			if(fechaInicial==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			var fechaFinal= $('#fechaFin').val().trim();
			if (fechaInicial > fechaFinal){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var fechaInicial= $('#fechaInicio').val().trim();
		var fechaFinal= $('#fechaFin').val().trim();
		if(esFechaValida(fechaFinal)){
			if(fechaFinal==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if (fechaInicial > fechaFinal){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}
			if (fechaFinal > parametroBean.fechaSucursal){
				mensajeSis("La Fecha de Final es mayor a la Fecha del Sistema.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#generar').click(function() { 
		generaReporte();
	});

	function generaReporte() {
		var ligaGenerar			= '';
		var tipoReporte			= $('input:radio[name=tipoReporte]:checked').val();
		var fechaSistema		= parametroBean.fechaSucursal;
		var usuario				= parametroBean.claveUsuario;
	    var nombreInstitucion	= parametroBean.nombreInstitucion; 
	    var fechaInicio			= $('#fechaInicio').val();
	    var fechaFin			= $('#fechaFin').val();
	
		ligaGenerar = 'reporteEvalMasivaVista.htm?' + 
			'fechaSistema=' 	+ fechaSistema +
			'&nomUsuario=' 		+ usuario.toUpperCase() +
			'&nomInstitucion='	+ nombreInstitucion.toUpperCase() +
			'&fechaInicio='		+ fechaInicio +
			'&fechaFin=' 		+ fechaFin +
			'&tipoReporte=' 	+ tipoReporte;

		window.open(ligaGenerar, '_blank');
	}
	
	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
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
	function inicializa(){
	    $('#fechaInicio').focus();
		$('#fechaInicio').val(parametroBean.fechaSucursal);
		$('#fechaFin').val(parametroBean.fechaSucursal);
		habilitaBoton('generar');
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