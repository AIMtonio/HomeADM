$(document).ready(function() {
	parametros = consultaParametrosSession();
	
	var Constantes = {
			'CADENAVACIA' : ''
		};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');				
	$('#fechaInicio').val(parametros.fechaSucursal);
	$('#fechaFin').val(parametros.fechaSucursal);
	$('#fechaInicio').focus();
	$('#excel').attr("checked",true) ; 
		
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
		}
	});	

	
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			var Yfecha= $('#fechaFin').val();
			if (mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha Inicial es Mayor a la Fecha Final.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaInicio').val() > parametros.fechaSucursal) {
					mensajeSis("La Fecha de Inicio es Mayor a la Fecha Actual.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}

			
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	// se valida que la fecha de carga no sea superior a la fecha del sistema
	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if ( mayor(Xfecha,Yfecha) ){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			else{
				if($('#fechaFin').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Fin  es Mayor a la Fecha Actual.");
					$('#fechaFin').val(parametroBean.fechaSucursal);
				}				
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
	});
	
	
	$('#generar').click(function() { 
		consultaINPC($('#fechaFin').val());
		generaExcel();


	});	
	
	// Funcion para consultar Indice Nacional de Precios al Consumidor
	function consultaINPC(fechaFin){
		var jqMes = fechaFin.substring(5,7);
		var jqAnio = fechaFin.substring(0,4);
		console.log(jqMes);
		console.log(jqAnio);
		   
		var numMesAnio = jqMes.concat(jqAnio);
		console.log(numMesAnio);
		
		setTimeout("$('#cajaLista').hide();", 200);
		var consultaBean = {  
				'mesAnio':numMesAnio
				};
		if(numMesAnio != Constantes.CADENAVACIA && !isNaN(numMesAnio) && numMesAnio > 0){
			indiceNaPreConsumidorServicio.consulta(1,consultaBean, function(indice){
				console.log(indice);
				if(indice == null || indice == Constantes.CADENAVACIA){
					mensajeSis('Nota: Si hace falta capturar el INPC para alguno de los meses en los que se pagó intereses, no será posible calcular el interés real.');
				}				
			});
		}
	}
	

	//------------ Validaciones de Controles -------------------------------------

	//Funcion para genera Reporte
	function generaExcel(){
		var tipoRep			= 1;
		var nombreInstitucion=parametroBean.nombreInstitucion;
		var fechaEmision = parametroBean.fechaSucursal;
		var claveUsuario=parametroBean.claveUsuario;
		var nomUsu	= parametroBean.nombreUsuario;
		
		var paginaReporte ='repInteresesPagados.htm?'+
			'tipoRep='+tipoRep+
			'&nombreInstitucion='+nombreInstitucion+
			'&fechaInicio='+$('#fechaInicio').val()+
			'&fechaFin='+$('#fechaFin').val()+
			'&nombreUsuario='+nomUsu+
			'&nomUsuario='+claveUsuario+
			'&fechaSistema='+fechaEmision;
			$('#ligaGenerar').attr('href',paginaReporte);
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
	
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd)");
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