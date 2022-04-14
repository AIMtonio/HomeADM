$(document).ready(function() {
	esTab = false;
	
	// Parametros de Sesion
	var parametroBean = consultaParametrosSession();

	// Tipo de Reporte a Generar
    var catTipoRepVerificaPregunta = { 
			'Excel'	: 1
	};
	
	var catTipoLisVerificaPregunta = {
			'verificaPreguntaExcel' : 1 
	};	
	
	var Constantes = {
		"SI" 			: "S",
		"NO" 			: "N",	
		"CADENAVACIA" 	: "",
		"ENTEROCERO"  	: 0,
	};
		
	//------------ Metodos y Manejo de Eventos -----------------------
	agregaFormatoControles('formaGenerica');

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#fechaInicio').focus();

	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	// Genera Reporte Verificacion Preguntas en Excel
	$('#generar').click(function() { 
		generaExcel();
	});
	
	// Fecha Inicio Verificacion de Preguntas
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		$('#fechaInicio').focus();
		if(esFechaValida(Xfecha)){
			if(Xfecha == '')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if (mayor(Xfecha, Yfecha))
			{
				mensajeSis("La Fecha Inicio no debe ser mayor a la Fecha Fin.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#fechaInicio').focus();
		}
	});

	// Fecha Fin Verificacion de Preguntas
	$('#fechaFin').change(function() {
		var Xfecha = $('#fechaInicio').val();
		var Yfecha = $('#fechaFin').val();
		$('#fechaFin').focus();
		if(esFechaValida(Yfecha)){
			if(Yfecha == '')$('#fechaFin').val(parametroBean.fechaSucursal);
			if (mayor(Xfecha, Yfecha))
			{
				mensajeSis("La Fecha Fin no debe ser menor a la Fecha Inicio.");
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
			$('#fechaFin').focus();
		}

	});	
	
	// Lista de Clientes
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	// Consulta de Clientes
	$('#clienteID').blur(function() {
		consultaCliente(this.id);
	});
	
	// Validaciones
	$('#formaGenerica').validate({
		rules: {			
			fechaInicio: {
				required: true,
			},
			fechaFin:{
				required: true,
			}
		},		
		messages: {
			fechaInicio: {
				required: 'Especifique Fecha Inicio'

			},
			fechaFin:{
				required: 'Especifique Fecha Fin'
			}
		}
	});

	// Funcion para consultar datos del Cliente
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conPrincipal = 1;
		
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCliente == Constantes.CADENAVACIA || numCliente == Constantes.ENTEROCERO){
			$(jqCliente).val(0);
			$('#nombreCliente').val('TODOS');
		}
		else
			if (numCliente != Constantes.CADENAVACIA && !isNaN(numCliente)) {
				clienteServicio.consulta(conPrincipal, numCliente, function(cliente) {
					if (cliente != null) {
						$('#clienteID').val(cliente.numero);
						$('#nombreCliente').val(cliente.nombreCompleto);
					} else {
						mensajeSis("El Cliente No Existe.");
						$('#clienteID').focus();
						$(jqCliente).val(0);
						$('#nombreCliente').val('TODOS');
					}
			});
		}
	}

	// Funcion para Generar el Reporte de Verificacion de Preguntas en Excel
	function generaExcel(){
		// Declaracion de variables
		var tipoReporte = catTipoRepVerificaPregunta.Excel; 
		var tipoLista   = catTipoLisVerificaPregunta.verificaPreguntaExcel;  
		var fechaInicio	= $('#fechaInicio').val();	 
		var fechaFin 	= $('#fechaFin').val();
		var cliente 	= $('#clienteID').val();

		var nombreInstitucion 	= parametroBean.nombreInstitucion;
		var nombreUsuario		= parametroBean.claveUsuario;
		var fechaEmision 		= parametroBean.fechaSucursal;
	
		// Valores de Texto
		var nombreCliente 	= $('#nombreCliente').val();
		
		var pagina ='reporteVerificacionPreguntas.htm?fechaInicio='+fechaInicio+'&fechaFin='+fechaFin
							+ '&clienteID='+cliente+'&nombreCliente='+nombreCliente
							+ '&nombreInstitucion='+nombreInstitucion+'&nombreUsuario='+nombreUsuario.toUpperCase()		
							+ '&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+'&fechaEmision='+fechaEmision;
		window.open(pagina);
	}
		
		
	//	Función para validar las fechas
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


	// Funcion valida fecha formato (yyyy-MM-dd) 
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de fecha no válido (aaaa-mm-dd).");
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

	// Funcion para comprobar el año bisiesto
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	
}); // fin ready
		