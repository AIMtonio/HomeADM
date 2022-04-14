$(document).ready(function() {

	// Definicion de Constantes y Enums
	esTab = false;

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();
	consultaTipoGarantiaFira();
	listaProductosAgro();
	listaSucursales();
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#excel').attr("checked",true);
	$('#fechaInicio').focus();

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	//------------ Validaciones de la Forma -----------------------------------

	$('#fechaInicio').change(function() {
		validaFechaInicio();
	});

	$('#fechaFin').change(function() {
		validaFechaFin();
	});

	$('#generar').click(function() {
		if($('#excel').is(":checked") ){
			generaExcel();
		}
	});

	function generaExcel() {

		if($('#excel').is(':checked')){

			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaFin').val();

			var sucursalID = $("#sucursalID option:selected").val();
			var nombreSucursal = $("#sucursalID option:selected").html();
			if(sucursalID == '' || sucursalID == 0){
				nombreSucursal = 'TODOS';
			}else{
				nombreSucursal = $("#sucursalID option:selected").html();
			}

			var productoCreditoID = $("#productoCreditoID option:selected").val();
			var nombreProductoCreditoID = $("#productoCreditoID option:selected").html();
			if(productoCreditoID == '' || productoCreditoID == 0){
				nombreProductoCreditoID = 'TODOS';
			}else{
				nombreProductoCreditoID = $("#productoCreditoID option:selected").html();
			}

			var tipoGarantiaID = $("#tipoGarantiaID option:selected").val();
			var tipoGarantia = $("#tipoGarantiaID option:selected").val();
			if(tipoGarantiaID == '' || tipoGarantiaID == 0 ){
				tipoGarantia = 'TODOS';
			}else{
				tipoGarantia = tipoGarantiaID + " - " + $("#tipoGarantiaID option:selected").html();
			}

			var nombreInstitucion=	parametroBean.nombreInstitucion;
			var nombreUsuario = parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;
			var fecha = new Date();

			var segundos  = fecha.getSeconds();
			var minutos = fecha.getMinutes();
			var horas = fecha.getHours();

			if(fecha.getHours()<10){
				horas = "0"+fecha.getHours();
			}
			if(fecha.getMinutes()<10){
				minutos = "0"+fecha.getMinutes();
			}
			if(fecha.getSeconds()<10){
				segundos = "0"+fecha.getSeconds();
			}
			var horaEmision = horas+":"+minutos+":"+segundos;
			var tipoReporte	= 1;
			var tipoLista = 1;
			var rangoFechas = formarRangoFechas(fechaInicio,fechaFin);

			$('#ligaGenerar').attr('href',
						'reporteCreditoAfectacionGarantia.htm'+
						'?fechaInicio='+fechaInicio+
						'&fechaFin='+fechaFin+
						'&productoCreditoID='+productoCreditoID+
						'&nombreProductoCredito='+nombreProductoCreditoID+
						'&tipoGarantiaID='+tipoGarantiaID+
						'&tipoGarantia='+tipoGarantia+
						'&sucursalID='+sucursalID+
						'&nombreSucursal='+nombreSucursal+
						'&rangoFechas='+rangoFechas+
						'&tipoReporte='+tipoReporte+
						'&tipoLista='+tipoLista+
						'&fechaEmision='+fechaEmision+
						'&horaEmision='+horaEmision+
						'&nombreUsuario='+nombreUsuario+
						'&nombreInstitucion='+nombreInstitucion);
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

	//funcion valida fecha formato (yyyy-MM-dd)
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

	// funcion comprobar anio bisiesto
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}

	// funcion rango de fechas
	function formarRangoFechas(fechaInicio, fechaFin){
		var fechaInicial = covertirFechaLetras(fechaInicio);
		var fechaFinal = covertirFechaLetras(fechaFin);
		var fecha = fechaInicial+" AL "+fechaFinal;
		return fecha;
	}

	// convertur fechas a letras
	function covertirFechaLetras(fecha){
		var fechaCompleta = "";
		var nombreMes = "";
		var anio = 0;
		var mes = 0;
		var dia = 0;
		var cadenaDia = "";

		anio = parseInt((fecha).substring(0, 4));
		mes = parseInt((fecha).substring(5, 7));
		dia = parseInt((fecha).substring(8, 10));

		switch(mes) {
			case 1:
				nombreMes = "ENERO";
			break;
			case 2:
				nombreMes = "FEBRERO";
			break;
			case 3:
				nombreMes = "MARZO";
			break;
			case 4:
				nombreMes = "ABRIL";
			break;
			case 5:
				nombreMes = "MAYO";
			break;
			case 6:
				nombreMes = "JUNIO";
			break;
			case 7:
				nombreMes = "JULIO";
			break;
			case 8:
				nombreMes = "AGOSTO";
			break;
			case 9:
				nombreMes = "SEPTIEMBRE";
			break;
			case 10:
				nombreMes = "OCTUBRE";
			break;
			case 11:
				nombreMes = "NOVIEMBRE";
			break;
			case 12:
				nombreMes = "DICIEMBRE";
			break;
			default:
				nombreMes = "MES INVALIDO";
			break;
		}

		cadenaDia = dia;
		if(dia < 10){
			cadenaDia = "0"+dia;
		}

		fechaCompleta = (cadenaDia + " DE " + nombreMes+" DEL " +anio).toString();
		return fechaCompleta;
	}


	function consultaTipoGarantiaFira() {
		dwr.util.removeAllOptions('tipoGarantiaID');
		dwr.util.addOptions('tipoGarantiaID', {"0" : 'TODAS'});
		var CatTipoGarantiaFIRABean = {
			'descripcion' : ''
		};
		catTipoGarantiaFIRAServicio.listaCombo(2, CatTipoGarantiaFIRABean, function(tipoGarantiaF) {
			dwr.util.addOptions('tipoGarantiaID', tipoGarantiaF, 'tipoGarantiaID', 'descripcion');
		});
	}

	function listaProductosAgro() {
		var tipoConsulta = 10;
		dwr.util.removeAllOptions('productoCreditoID');
		dwr.util.addOptions('productoCreditoID', {'0':'TODOS'});
		productosCreditoServicio.listaCombo(tipoConsulta, function(productoCreditoBean){
			dwr.util.addOptions('productoCreditoID', productoCreditoBean, 'producCreditoID', 'descripcion');
		});
	}

	function listaSucursales() {
		var tipoConsulta = 2;
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions('sucursalID', {'0':'TODAS'});
		sucursalesServicio.listaCombo(tipoConsulta, function(sucursalesBean){
			dwr.util.addOptions('sucursalID', sucursalesBean, 'sucursalID', 'nombreSucurs');
		});
	}

		function validaFechaInicio(){
		var fechaInicio= $('#fechaInicio').val();
		var fechaFin= $('#fechaFin').val();
		var fechaSis= parametroBean.fechaSucursal;

		if(esFechaValida(fechaInicio)){
			if( mayor(fechaInicio, fechaSis)){
				mensajeSis("La Fecha de Inicio no Puede ser Mayor a la Fecha del Sistema");
				$('#fechaInicio').val(fechaSis);
				$('#fechaFin').val(fechaSis);
				$('#fechaInicio').focus();
			}else{
				if( mayor(fechaInicio, fechaFin)){
					mensajeSis("La Fecha de Inicio no Puede ser Mayor a la Fecha de Fin")	;
					$('#fechaInicio').val(fechaFin);
					$('#fechaInicio').focus();
				}else{
					$('#fechaInicio').focus();
				}
			}
		}else{
			$('#fechaInicio').val(fechaSis);
			$('#fechaFin').val(fechaSis);
			$('#fechaInicio').focus();
		}
	}

	function validaFechaFin(){
		var fechaInicio= $('#fechaInicio').val();
		var fechaFin= $('#fechaFin').val();
		var fechaSis= parametroBean.fechaSucursal;

		if(esFechaValida(fechaFin)){
			if( mayor(fechaFin, fechaSis)){
				mensajeSis("La Fecha de Fin no Puede ser Mayor a la Fecha del Sistema");
				$('#fechaFin').val(fechaSis);
				$('#fechaFin').focus();
			}else{
				if( mayor(fechaInicio, fechaFin)){
					mensajeSis("La Fecha de Fin no Puede ser Menor a la Fecha de Inicio")	;
					$('#fechaFin').val(fechaSis);
					$('#fechaFin').focus();
				}else{
					$('#fechaFin').focus();
				}
			}
		}else{
			$('#fechaInicio').val(fechaSis);
			$('#fechaFin').val(fechaSis);
			$('#fechaFin').focus();
		}
	}
});