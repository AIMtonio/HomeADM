$(document).ready(function() {
	// Definicion de constantes, variables y enums
	var esTab = true;
	
	var maximoValorDecimal = 999999999999.99;

	var Enum_Tipo_Reporte = {
		'pdf' : 1,
		'excel' : 2
	};

	var Enum_Num_Reporte = {
		'principal' : 1
	};

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('input').attr({
		'autocomplete' : 'off'
	});

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#fechaInicio').focus();
	$('#excel').attr("checked",true);
	$('#montoTransferIni').val(0);
	$('#montoTransferFin').val(0);
	$('#cuentaAhoID').val(0);
	$('#nombreCliente').val('TODOS');

	// Metodos y Manejo de Eventos
	agregaFormatoControles('formaGenerica');

	$.validator.setDefaults({
		submitHandler: function(event) {
		}
	});

	// Se valida que la fecha inicio no sea maypr a la del sistema y que no sea mayor a la fecha final
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			var Yfecha= $('#fechaFin').val();
			if (mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha Inicial es Mayor a la Fecha Final.");
				$('#fechaInicio').val($('#fechaFin').val());
			}else{
				if($('#fechaInicio').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Inicio es Mayor a la Fecha Actual.");
					$('#fechaInicio').val($('#fechaFin').val());
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
		$('#fechaInicio').focus();
	});

	// Se valida que la fecha final del reporte no sea mayor a la del sistema y tampoco mayor a la fecha de inicio
	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if ( mayor(Xfecha,Yfecha) ){
				mensajeSis("La Fecha Final es Menor a la Fecha de Inicio.");
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
		$('#fechaFin').focus();
	});
	
	$('#montoTransferIni').blur(function(){
		var montoIni = $('#montoTransferIni').asNumber();
		var montoFin = $('#montoTransferFin').asNumber();
		
		if(montoIni > maximoValorDecimal){
			mensajeSis("El Monto de Transferencia Inicial no puede ser mayor 999,999,999,999.99");
			$('#montoTransferIni').val(0);
			setTimeout("$('#montoTransferIni').select()", 50);
			return;
		}
		
		if(montoIni > 0){
			if (montoFin > 0){
				if(montoIni > montoFin){
					mensajeSis("El Monto de Transferencia Inicial es Mayor al Monto Final");
					$('#montoTransferIni').val(montoFin);
					setTimeout("$('#montoTransferIni').select()", 50);
				}
			} else if(montoFin < 0) {
				mensajeSis("El Monto Final no puede ser negativo");
				$('#montoTransferFin').val(0);
				setTimeout("$('#montoTransferIni').select()", 50);
			}
		} else {
			mensajeSis("El Monto Inicial no puede ser cero o negativo");
			setTimeout("$('#montoTransferIni').select()", 50);
		}
	});
	
	$('#montoTransferFin').blur(function(){
		var montoIni = $('#montoTransferIni').asNumber();
		var montoFin = $('#montoTransferFin').asNumber();
		
		if(montoFin > maximoValorDecimal){
			mensajeSis("El Monto de Transferencia Final no puede ser mayor 999,999,999,999.99");
			$('#montoTransferFin').val(0);
			setTimeout("$('#montoTransferFin').select()", 50);
			return;
		}
		
		if(montoFin > 0){
			if (montoIni > 0){
				if(montoFin < montoIni){
					mensajeSis("El Monto de Transferencia Final es Menor al Monto Inicial");
					$('#montoTransferFin').val(montoIni);
					setTimeout("$('#montoTransferFin').select()", 50);
				}
			} else if(montoIni < 0) {
				mensajeSis("El Monto Inicial no puede ser negativo");
				$('#montoTransferIni').val(0);
				setTimeout("$('#montoTransferFin').select()", 50);
			}
		} else {
			mensajeSis("El Monto Final no puede ser cero o negativo");
			setTimeout("$('#montoTransferFin').select()", 50);
		}
	});

	$('#cuentaAhoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			ponerMayusculas(this);

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#cuentaAhoID').val();
			lista('cuentaAhoID', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}
	});

	$('#cuentaAhoID').blur(function() {
		consultaCtaAho();
	});
	
	$('#generar').click(function() {
		generaExcel();
	});	
	
	function consultaCtaAho() {
		var numCta = $('#cuentaAhoID').val();
		var tipConCampos = 20;
		
		var CuentaAhoBeanCon = {
			'cuentaAhoID' : numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCta != '' && !isNaN(numCta)) {
			if (numCta > 0) {
				cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon, function(cuenta) {
					if (cuenta != null) {
						$('#nombreCliente').val(cuenta.nombreCompleto);
					} else {
						if (numCta > 0) {
							mensajeSis("No Existe la cuenta de ahorro");
							$('#cuentaAhoID').select();
						} else {
							$('#nombreCliente').val("TODOS");
						}
					}
				});
			} else {
				$('#cuentaAhoID').val(0);
				$('#nombreCliente').val("TODOS");
			}
		} else {
			$('#cuentaAhoID').val(0);
			$('#nombreCliente').val("TODOS");
		}
	}
	
	//Funcion para genera Reporte
	function generaExcel(){
		var tipoRep = Enum_Tipo_Reporte.excel;
		var numReporte = Enum_Num_Reporte.principal;
		var usuario = parametroBean.claveUsuario;
		var fecha = parametroBean.fechaSucursal;
		var institucion = parametroBean.nombreInstitucion;
		var fechaInicio = $('#fechaInicio').val();
		var fechaFin = $('#fechaFin').val();
		var montoTransferIni = $('#montoTransferIni').asNumber();
		var montoTransferFin = $('#montoTransferFin').asNumber();
		var cuentaAhoID = $('#cuentaAhoID').val();
		
		if(montoTransferIni > 0 && montoTransferFin > 0){
			var paginaReporte ='reporteSpeiEnvios.htm?'+
			'tipoRep='+tipoRep+
			'&numReporte='+numReporte+
			'&usuario='+usuario+
			'&fecha='+fecha+
			'&institucion='+institucion+
			'&fechaInicio='+fechaInicio+
			'&fechaFin='+fechaFin+
			'&montoTransferIni='+montoTransferIni+
			'&montoTransferFin='+montoTransferFin+
			'&cuentaAhoID='+cuentaAhoID;
		
			$('#ligaGenerar').attr({
				'href':paginaReporte,
				'target':'_blank'
			});
		} else {
			mensajeSis("Los Montos no pueden estar en ceros");
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
});

function comprobarSiBisisesto(anio){
	if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
		return true;
	}
	else {
		return false;
	}
}

function validadorNumeros(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57){
		if (key==8 || key == 0){
			return true;
		}
		else 
  		return false;
	}
}