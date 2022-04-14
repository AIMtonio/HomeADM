

$(document).ready(function() {
var parametroBean = consultaParametrosSession();  
	
	/* == Métodos y manejo de eventos ====  */
	agregaFormatoControles('formaGenerica');
	
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	
	
	
	$('#clienteID').bind('keyup',function(e) {
		lista('clienteID', '2', '1','nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#sucursalID').bind('keyup',function(e) {
		lista('sucursalID', '2', '1','nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);
	});
	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	});
	
	$('#generar').click(function() { 
		generaReporte();
	});
	
	
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaInicio').val() > parametroBean.fechaSucursal) {
					alert("La Fecha de Inicio es Mayor a la Fecha del Sistema.");
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
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaFin').val() > parametroBean.fechaSucursal) {
					alert("La Fecha de Fin  es Mayor a la Fecha del Sistema.");
					$('#fechaFin').val(parametroBean.fechaSucursal);
				}				
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

	});
	
	
	/* ====================== FUNCIONES ============================ */

	function generaReporte() {
			var fechaInicio = $("#fechaInicio").val();
			var fechaFin = $("#fechaFin").val();
			var cliente = $("#clienteID").val();	
			var sucursal = $("#sucursalID").val();	
			var nombreCliente = $("#clienteIDDes").val();	
			var ClienteConCaracter = nombreCliente;
			nombreCliente = ClienteConCaracter.replace(/\&/g, "%26");	
			var nombreSucursal = $("#sucursalIDDes").val();	
			var tipoReporte = 1;
			var fechaSis = parametroBean.fechaSucursal;
			var nombreUsuario = parametroBean.claveUsuario; 
			var nombreInstitucion = parametroBean.nombreInstitucion;
			
			

			$('#ligaGenerar').attr('href','reporteCapacidadPago.htm?fechaInicio='+fechaInicio + '&fechaFin=' + fechaFin + '&clienteID=' + cliente +'&sucursalID='+sucursal+'&fechaSistema='+fechaSis
					+'&nombreUsuario='+nombreUsuario+'&tipoReporte='+tipoReporte+'&nombreCliente='+nombreCliente+'&nombreSucursal='+nombreSucursal
					+'&nombreInstitucion='+nombreInstitucion);
		
	}
	
	function consultaCliente (idControl){
		var jqcliente = eval("'#" + idControl + "'");
		var numCliente = $(jqcliente).val();
		var conCliente = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		
		if (numCliente != '' && !isNaN(numCliente) && numCliente != 0) {
			clienteServicio.consulta(conCliente, numCliente, function(cliente) {
				if (cliente != null) {
					$('#clienteID').val(cliente.numero);
					$('#clienteIDDes').val(cliente.nombreCompleto);		
					
		
				} else {
					alert("No Existe el Cliente");
					$('#clienteID').val('0');
					$('#clienteIDDes').val('TODOS');
					
				}
			});
		}
		else {			
			$('#clienteID').val('0');
			$('#clienteIDDes').val('TODOS');
			$('#sucursalID').val('0');
			$('#sucursalIDDes').val('TODAS');
		}
	}
	
	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal) && numSucursal != 0) {
			sucursalesServicio.consultaSucursal(conSucursal,
					numSucursal, function(sucursal) {
						if (sucursal != null) {
							$('#sucursalID').val(sucursal.sucursalID);
							$('#sucursalIDDes').val(sucursal.nombreSucurs);
						} else {
							alert("No Existe la Sucursal");
							$('#sucursalID').val('0');
							$('#sucursalIDDes').val('TODAS');
						}
					});
		}
		else{
			$('#sucursalID').val('0');
			$('#sucursalIDDes').val('TODAS');
		}
	}
	
	

    /*=== Validaciones para la forma ====  */
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
	
	
	
});