$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var parametroBean = consultaParametrosSession();

	var catTipoRepLineasCredito = {
			'PDF'	: 1,
			'EXCEL'	: 2
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	$('#pdf').attr("checked",true) ;
	$('#fechaInicio').focus();
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaVencimiento').val(parametroBean.fechaSucursal);
	$('#lineaCreditoID').val('0');
	$('#clienteID').val('0');
	$('#nombreCliente').val('TODOS');
	$('#productoCreditoID').val('0');
	$('#nombreProducto').val('TODOS');
	$('#sucursalID').val('0');
	$('#nombreSucursal').val('TODOS');

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#lineaCreditoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#lineaCreditoID').val();
		lista('lineaCreditoID', '2', '7', camposLista, parametrosLista, 'lineasCreditoLista.htm');
	});

	$('#clienteID').bind('keyup',function(e){
		if(this.value.length >= 4){
			lista('clienteID', '2', '14', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
		}
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);
	});

	$('#lineaCreditoID').blur(function() {
		validaLineaCredito(this.id);
	});
	$('#productoCreditoID').bind('keyup',function(e){
			if(this.value.length >= 2){
				lista('productoCreditoID', '2', '10', 'descripcion', $('#productoCreditoID').val(), 'listaProductosCredito.htm');
			}
	});

	$('#productoCreditoID').blur(function() {
		consultaProductosCredito(this.id);
	});

	$('#sucursalID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalID', '2', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});

	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		$('#fechaInicio').focus();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimiento').val();
			if (mayor(Xfecha, Yfecha))
			{
				mensajeSis("La Fecha de Inicio no debe ser mayor a la Fecha Fin.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#fechaInicio').focus();
		}
	});

	$('#fechaVencimiento').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaVencimiento').val();
		$('#fechaVencimiento').focus();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			if (mayor(Xfecha, Yfecha))
			{
				mensajeSis("La Fecha Fin no debe ser menor a la Fecha Inicio.");
				$('#fechaVencimiento').val(parametroBean.fechaSucursal);
				$('#fechaVencimiento').focus();
			}
		}else{
			$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			$('#fechaVencimiento').focus();
		}

	});

	$('#generar').click(function() {
		generarArchivo();
	});

	$('#formaGenerica').validate({
		rules: {
			fechaInicio: {
				required: true,
			},
			fechaVencimiento:{
				required: true,
			}
		},
		messages: {
			fechaInicio: {
				required: 'Especifique Fecha Inicio'

			},
			fechaVencimiento:{
				required: 'Especifique Fecha Fin'
			}
		}
	});

	// ***********  Inicio  validacion   ***********

	function validaLineaCredito(idControl) {
		var jqLinea  = eval("'#" + idControl + "'");
		var lineaCredito = $(jqLinea).val();

		var tipConAgropecuaria = 4;
		var lineaCreditoBeanCon = {
				'lineaCreditoID'	:lineaCredito
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(lineaCredito == '' || lineaCredito==0){
			$(jqLinea).val(0);
			limpiaFormulario();
		}
		else
		if(lineaCredito != '' && !isNaN(lineaCredito)){
				lineasCreditoServicio.consulta(tipConAgropecuaria, lineaCreditoBeanCon,function(linea) {
					if(linea!=null){
						agregaFormatoControles('formaGenerica');
						$('#clienteID').val(linea.clienteID);
						consultaCliente('clienteID');
						$('#productoCreditoID').val(linea.productoCreditoID);
						consultaProductosCredito('productoCreditoID');
						$('#sucursalID').val(linea.sucursalID);
						consultaSucursal('sucursalID');
						$('#estatus').val(linea.estatus);

					}else{
						mensajeSis("No Existe la Línea de Crédito");
						$('#lineaCreditoID').focus();
						$('#lineaCreditoID').val('');
						limpiaFormulario();
					}
				});
			}
		}

	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conCliente =6;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente == '' || numCliente==0){
			$(jqCliente).val(0);
			$('#nombreCliente').val('TODOS');
		}
		else
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
				if(cliente!=null){
					if(cliente.esMenorEdad != "S"){
							$('#clienteID').val(cliente.numero);
							$('#nombreCliente').val(cliente.nombreCompleto);
					}else{
						mensajeSis("El Cliente es Menor de Edad.");
						$('#clienteID').focus();
						$('#clienteID').select();
						$("#nombreCliente").val('');
					}
				}else{
					mensajeSis("No Existe el Cliente");
					$('#clienteID').focus();
					$(jqCliente).val(0);
					$('#nombreCliente').val('TODOS');
				}
			});
		}
	}

	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal == '' || numSucursal==0){
			$(jqSucursal).val(0);
			$('#nombreSucursal').val('TODOS');
		}
		else
		if(numSucursal != '' && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
				if(sucursal!=null){
					$('#sucursalID').val(sucursal.sucursalID);
					$('#nombreSucursal').val(sucursal.nombreSucurs);

				}else{
					mensajeSis("No Existe la Sucursal");
					$('#sucursalID').focus();
					$(jqSucursal).val(0);
					$('#nombreSucursal').val('TODOS');
				}
			});
		}
	}

	function consultaProductosCredito(idControl) {
		var jqProducto  = eval("'#" + idControl + "'");
		var numProducto = $(jqProducto).val();
		var conForanea =8;
		var ProductoCreditoCon = {
				'producCreditoID':numProducto
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProducto == '' || numProducto==0){
			$(jqProducto).val(0);
			$('#nombreProducto').val('TODOS');
		}
		else
		if(numProducto != '' && !isNaN(numProducto)){
			productosCreditoServicio.consulta(conForanea,ProductoCreditoCon,function(productos){
				if(productos!=null){
					agregaFormatoControles('formaGenerica');
					$('#nombreProducto').val(productos.descripcion);
					if(productos.esGrupal !='N'){
						mensajeSis("El Producto de Crédito debe de ser Individual");
						$('#productoCreditoID').focus();
						$('#productoCreditoID').val('');
						$('#nombreProducto').val('');
					}
				}else{
					mensajeSis("No Existe el Producto de crédito");
					$('#productoCreditoID').focus();
					$(jqProducto).val(0);
					$('#nombreProducto').val('TODOS');
				}
			});
		}
	}

/**
	 * Funcion para Generar el Reporte de Lineas de Credito AgroExcel
	 */
	function generarArchivo(){

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
		var tipoReporte 	= 0;
		var tipoLista   	= 0;

		var fechaInicio 	= $('#fechaInicio').val();
		var fechaFin 		= $('#fechaVencimiento').val();
		var lineaCredito    = $('#lineaCreditoID').val();
		var cliente         = $('#clienteID').val();
		var productoCred    = $('#productoCreditoID').val();
		var sucursal        = $('#sucursalID').val();
		var estatus 		= $("#estatus").val();

		var claveUsuario		= parametroBean.claveUsuario;
		var fechaSistema 		= parametroBean.fechaSucursal;

				/// VALORES TEXTO
		var nombreCliente = $('#nombreCliente').val();
		var nombreProducto = $('#nombreProducto').val();
		var nombreSucursal = $('#nombreSucursal').val();
		var nombreEstatus =$("#estatus option:selected").val();
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var nombreUsuario = parametroBean.nombreUsuario;

		if(nombreEstatus=='0'){
			nombreEstatus='';
		}else{
			nombreEstatus =$("#estatus option:selected").html();
		}
		if(estatus=='0'){
			estatus='';
		}
		if(lineaCredito=='0'){
			lineaCredito='';
		}
		if(nombreProducto=='TODOS'){
			nombreProducto='';
		}

		if( $('#excel').is(':checked') ){
			tipoReporte = catTipoRepLineasCredito.EXCEL;;
		}
		if( $('#pdf').is(':checked') ){
			tipoReporte = catTipoRepLineasCredito.PDF;
		}
		tipoLista = 1;

		$('#ligaGenerar').attr('href','lineasCreditoRepAgro.htm?fechaInicio='+fechaInicio+'&fechaVencimiento='+fechaFin
								+ '&lineaCreditoID='+lineaCredito+'&productoCreditoID='+productoCred+'&nombreProducto='+nombreProducto
								+ '&sucursalID='+sucursal+'&nombreSucursal='+nombreSucursal
								+ '&estatus='+estatus+'&nombreEstatus='+nombreEstatus
								+ '&nombreInstitucion='+nombreInstitucion
								+ '&claveUsuario='+claveUsuario.toUpperCase()+'&tipoReporte='+tipoReporte
								+ '&clienteID='+cliente+'&nombreCliente='+nombreCliente
								+ '&tipoLista='+tipoLista+'&fechaSistema='+fechaSistema
								+ '&fechaEmision='+fechaEmision
								+ '&horaEmision='+horaEmision+'&nombreUsuario='+nombreUsuario);
	}



//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

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
//	FIN VALIDACIONES DE REPORTES

	/*funcion valida fecha formato (yyyy-MM-dd)*/
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
				if (comprobarSiBisisesto(anio)){ numDias=29;}else{ numDias=28;};
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
	/***********************************/


});

function limpiaFormulario(){
	$('#clienteID').val('');
	$('#nombreCliente').val('');
	$('#creditoID').val('');
	$('#productoCreditoID').val('');
	$('#nombreProducto').val('');
	$('#sucursalID').val('');
	$('#nombreSucursal').val('');
	$('#estatus').val("0").selected = true;
}