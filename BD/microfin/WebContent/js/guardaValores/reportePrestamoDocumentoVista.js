$(document).ready(function() {

	// Definicion de Constantes y Enums
	esTab = false;
	var cat_TipoLista = {
		'prestamoDocumentos' : 3
	};

	var cat_TipoReporte = {
		'prestamoDocumentos' : 3
	};

	var con_sucursal= {
		'principal'	: 1
	};

	var con_almacen= {
		'foranea'	: 2
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();

	$('#sucursalID').val('0');
	$('#almacenID').val("0");
	$('#nombreSucursal').val('TODAS');
	$('#nombreAlmacen').val("TODOS");
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#pdf').attr("checked",true);
	$('#excel').attr("checked",false);
	$('#sucursalID').focus();

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	//------------ Validaciones de la Forma -----------------------------------

	$('#sucursalID').bind('keyup',function(e){
		lista('sucursalID', '2', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});

	$('#sucursalID').blur(function(){
		consultaSucursal();
	});

	//Consulta de Sucursal
	function consultaSucursal(){

		var sucursalID =  $("#sucursalID").val();
		setTimeout("$('#cajaLista').hide();", 200);

		if( esTab && sucursalID != 0 && sucursalID != ''){
			sucursalesServicio.consultaSucursal(con_sucursal.principal,sucursalID,function(sucursal) {
				if(sucursal!=null){
					$('#sucursalID').val(sucursal.sucursalID);
					$('#nombreSucursal').val(sucursal.nombreSucurs);
				} else {
					mensajeSis("La Sucursal no Existe.");
					$('#nombreSucursal').val("TODAS");
					$('#sucursalID').val("0");
					$('#sucursalID').focus();
				}
			});
		} else {
			$('#sucursalID').val("0");
			$('#nombreSucursal').val("TODAS");
		}
	}

	$('#almacenID').bind('keyup',function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "nombreAlmacen";
		camposLista[1] = "sucursalID";

		parametrosLista[0] = $('#almacenID').val();
		parametrosLista[1] = $('#sucursalID').val();

		lista('almacenID', '2', '2', camposLista, parametrosLista, 'listaCatalogoAlmacenes.htm');
	});

	$('#almacenID').blur(function(){
		consultaAlmacen();
	});

	//Consulta de almacén
	function consultaAlmacen() {
		var almacenID =  $("#almacenID").val();
		var sucursalID =  $("#sucursalID").val();
		setTimeout("$('#cajaLista').hide();", 200);

		var catalogoAlmacenesBean = {
				'almacenID':almacenID,
				'sucursalID':sucursalID
		};

		if( esTab && almacenID != 0 && almacenID != ''){
			catalogoAlmacenesServicio.consulta(con_almacen.foranea, catalogoAlmacenesBean, function(catalogoAlmacen) {
				if (catalogoAlmacen != null) {
					$('#almacenID').val(catalogoAlmacen.almacenID);
					$('#nombreAlmacen').val(catalogoAlmacen.nombreAlmacen);
				} else {
					mensajeSis("El Almacén no Existe.");
					$('#almacenID').val("0");
					$('#nombreAlmacen').val("TODOS");
				}
			});
		} else {
			$('#almacenID').val("0");
			$('#nombreAlmacen').val("TODOS");
		}
	}


	$('#fechaInicio').change(function() {

		var fechaInicio= $('#fechaInicio').val();
		if(esFechaValida(fechaInicio)){

			if(fechaInicio==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#fechaInicio').focus();
		}
		$('#fechaInicio').focus();

	});

	$('#fechaInicio').blur(function() {

		var fechaInicio= $('#fechaInicio').val();
		if(esFechaValida(fechaInicio)){

			var fechaSistema = parametroBean.fechaSucursal;
			if ( mayor(fechaInicio, fechaSistema)){
				mensajeSis("La Fecha es mayor a la fecha del sistema.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#fechaInicio').focus();
		}
		$('#fechaFin').focus();

	});

	$('#fechaFin').change(function() {
		var fechaFin= $('#fechaFin').val();
		if(esFechaValida(fechaFin)){

			if(fechaFin==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}

			var fechaInicio= $('#fechaInicio').val();
			if ( mayor(fechaInicio, fechaFin)){
				mensajeSis("La Fecha Final es menor a la fecha Inicial.");
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}

			var fechaSistema= parametroBean.fechaSucursal;
			if ( mayor(fechaFin, fechaSistema)){
				mensajeSis("La Fecha es mayor a la fecha del sistema.");
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}

		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
			$('#fechaFin').focus();
		}
	});

	$('#fechaFin').blur(function() {

		var fechaFin= $('#fechaFin').val();
		if(esFechaValida(fechaFin)){

			if(fechaFin==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}

		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
			$('#fechaFin').focus();
		}
		$('#pdf').focus();
	});


	$('#pdf').click(function() {
		$('#pdf').attr("checked",true);
		$('#excel').attr("checked",false);
	});

	$('#excel').click(function() {
		$('#pdf').attr("checked",false);
		$('#excel').attr("checked",true);

	});


	$('#generar').click(function() {
		generaReporte();
	});

	function generaReporte() {

		if($('#pdf').is(':checked')){
			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaFin').val();

			var almacenID = $("#almacenID").val();
			var nombreAlmacen = $("#nombreAlmacen").val();
			if(almacenID == '' || almacenID == 0){
				nombreAlmacen = 'TODOS';
			}else{
				nombreAlmacen = $("#almacenID").val() + ' - ' + $("#nombreAlmacen").val();
			}

			var sucursalID = $("#sucursalID").val();
			var nombreSucursal = $("#nombreSucursal").val();
			if(sucursalID == 0 || sucursalID == ''){
				nombreSucursal = 'TODAS';
			}else{
				nombreSucursal = $("#sucursalID").val() + ' - '+ $("#nombreSucursal").val();
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
			var tipoReporte	= cat_TipoReporte.prestamoDocumentos;
			var tipoLista = cat_TipoLista.prestamoDocumentos;
			var rangoFechas = formarRangoFechas(fechaInicio, fechaFin);

			$('#ligaGenerar').attr('href',
						'reporteDocumentosGrdValPDF.htm'+
						'?nombreInstitucion='+nombreInstitucion+
						'&nombreUsuario='+nombreUsuario+
						'&fechaEmision='+fechaEmision+
						'&horaEmision='+horaEmision+
						'&rangoFechas='+rangoFechas+
						'&fechaInicio='+fechaInicio+
						'&fechaFin='+fechaFin+
						'&sucursalID='+sucursalID+
						'&nombreSucursal='+nombreSucursal+
						'&almacenID='+almacenID+
						'&nombreAlmacen='+nombreAlmacen+
						'&tipoReporte='+tipoReporte+
						'&tipoLista='+tipoLista);
		}

		if($('#excel').is(':checked')){

			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaFin').val();

			var almacenID = $("#almacenID").val();
			var nombreAlmacen = $("#nombreAlmacen").val();
			if(almacenID == '' || almacenID == 0){
				nombreAlmacen = 'TODOS';
			}else{
				nombreAlmacen = $("#almacenID").val() + ' - ' + $("#nombreAlmacen").val();
			}

			var sucursalID = $("#sucursalID").val();
			var nombreSucursal = $("#nombreSucursal").val();
			if(sucursalID == 0 || sucursalID == ''){
				nombreSucursal = 'TODAS';
			}else{
				nombreSucursal = $("#sucursalID").val() + ' - '+ $("#nombreSucursal").val();
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
			var tipoReporte	= cat_TipoReporte.prestamoDocumentos;
			var tipoLista = cat_TipoLista.prestamoDocumentos;
			var rangoFechas = formarRangoFechas(fechaInicio, fechaFin);

			$('#ligaGenerar').attr('href',
						'reporteDocumentosGrdValExcel.htm'+
						'?nombreInstitucion='+nombreInstitucion+
						'&nombreUsuario='+nombreUsuario+
						'&fechaEmision='+fechaEmision+
						'&horaEmision='+horaEmision+
						'&rangoFechas='+rangoFechas+
						'&fechaInicio='+fechaInicio+
						'&fechaFin='+fechaFin+
						'&sucursalID='+sucursalID+
						'&nombreSucursal='+nombreSucursal+
						'&almacenID='+almacenID+
						'&nombreAlmacen='+nombreAlmacen+
						'&tipoReporte='+tipoReporte+
						'&tipoLista='+tipoLista);
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;}
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
	function formarRangoFechas(fechaInicio, fechaFin, formato){
		var fechaInicial = convertirFechaLetras(fechaInicio);
		var fechaFinal = convertirFechaLetras(fechaFin);
		var fecha = "Del "+fechaInicial+" al "+fechaFinal;
		fecha =  fecha.toUpperCase();

		return fecha;
	}

	// convertur fechas a letras
	function convertirFechaLetras(fecha, formato){
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
				nombreMes = "Enero";
			break;
			case 2:
				nombreMes = "Febrero";
			break;
			case 3:
				nombreMes = "Marzo";
			break;
			case 4:
				nombreMes = "Abril";
			break;
			case 5:
				nombreMes = "Mayo";
			break;
			case 6:
				nombreMes = "Junio";
			break;
			case 7:
				nombreMes = "Julio";
			break;
			case 8:
				nombreMes = "Agosto";
			break;
			case 9:
				nombreMes = "Septiembre";
			break;
			case 10:
				nombreMes = "Octubre";
			break;
			case 11:
				nombreMes = "Noviembre";
			break;
			case 12:
				nombreMes = "Diciembre";
			break;
			default:
				nombreMes = "Mes Invalidó";
			break;
		}

		cadenaDia = dia;
		if(dia < 10){
			cadenaDia = "0"+dia;
		}

		fechaCompleta = (cadenaDia + " de " + nombreMes+" del " +anio).toString();
		fechaCompleta = fechaCompleta.toUpperCase();

		return fechaCompleta;
	}

});
