$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var parametroBean = consultaParametrosSession();

	var catTipoCreditoSusp = {
			'PDF'		: 1,
			'Excel'		: 2 
	};	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaSucursal();
	consultaProductoCredito();
	
	$('#pdf').attr("checked",true);

	$(':text').focus(function() {	
		esTab = false;
	});

	$('#excel').click(function() {
		if($('#excel').is(':checked')){	
			$('#tdPresenacion').hide('slow');
		}
	});

	$('#pdf').click(function() {
		if($('#pdf').is(':checked')){	
			$('#tdPresenacion').show('slow');
		}
	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var fechaFin = $('#fechaFinal').val();
		if ( mayor(Xfecha, fechaFin) )
		{
			mensajeSis("La Fecha de Inicio no puede ser mayor a la Fecha de Fin.")	;
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaFinal').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var fechaFin = $('#fechaFinal').val();
		var fechaSuc = parametroBean.fechaSucursal;
        
			if ( menor(fechaFin, Xfecha) )
			{
				mensajeSis("La Fecha de Fin no debe ser menor a la Fecha Inicial.")	;
				$('#fechaFinal').val(parametroBean.fechaSucursal);
			}
			if ( mayor(fechaFin, fechaSuc) )
			{
				mensajeSis("La Fecha de Fin no puede ser mayor a la Fecha del Sistema.")	;
				$('#fechaFinal').val(parametroBean.fechaSucursal);
			}
	});

	$('#generar').click(function() { 

		if($('#pdf').is(":checked") ){
			generaPDF();
		}

		if($('#excel').is(":checked") ){
			generaExcel();
		}

	});

	$('#formaGenerica').validate({
		rules: {
			fechaInicial :{
				required: true
			},
			atrasoFinal :{
				required: true
			}
		},
		
		messages: {
			fechaInicial :{
				required: 'Especifique la fecha inicial.'
			}
			,atrasoFinal :{
				required: 'Especifique la fecha final.'
			}
		}
	});

	
	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'Todas'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFinal').val(parametroBean.fechaSucursal);

	function consultaProductoCredito() {		
		var tipoCon = 2;
		dwr.util.removeAllOptions('productoCreditoID'); 
		dwr.util.addOptions( 'productoCreditoID', {'0':'Todas'});
		productosCreditoServicio.listaCombo(tipoCon, function(productos){
			dwr.util.addOptions('productoCreditoID', productos, 'producCreditoID', 'descripcion');
		});
	}

	function generaExcel() {
		$('#pdf').attr("checked",false) ;
		if($('#excel').is(':checked')){	
			var tr= catTipoCreditoSusp.Excel; 
			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFinal = $('#fechaFinal').val();	
			var sucursal = $("#sucursalID option:selected").val();
			var producto = $("#productoCreditoID option:selected").val();
			
			/// VALORES TEXTO
			var nombreSucursal = $("#sucursalID option:selected").val();
			var nombreProducto = $("#productoCreditoID option:selected").val();
			if(nombreSucursal=='0'){
				nombreSucursal='';
			}
			else{
				nombreSucursal = $("#sucursalID option:selected").html();
			}

			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#productoCreditoID option:selected").html();
			}

			var pagina = 'carCreditoSuspReporte.htm?fechaInicio='+fechaInicio+'&fechaFinal='+
							fechaFinal+'&sucursalID='+sucursal+'&nombreSucursal='+nombreSucursal+'&productoCreditoID='+producto+
							'&tipoReporte='+tr+'&nombreProducto='+nombreProducto;
		    $('#ligaGenerar').attr('href',pagina);
		    window.open(pagina,'_blank');

		}
	}

	function generaPDF() {	
		if($('#pdf').is(':checked')){	
			$('#excel').attr("checked",false); 
			var tr= catTipoCreditoSusp.PDF;
			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFinal = $('#fechaFinal').val();	
			var sucursal = $("#sucursalID option:selected").val();
			var producto = $("#productoCreditoID option:selected").val();
			
			/// VALORES TEXTO
			var nombreSucursal = $("#sucursalID option:selected").val();
			var nombreProducto = $("#productoCreditoID option:selected").val();

			if(nombreSucursal=='0'){
				nombreSucursal='';
			}
			else{
				nombreSucursal = $("#sucursalID option:selected").html();
			}

			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#productoCreditoID option:selected").html();
			}

			var pagina = 'carCreditoSuspReporte.htm?fechaInicio='+fechaInicio+'&fechaFinal='+
					fechaFinal+'&sucursalID='+sucursal+'&nombreSucursal='+nombreSucursal+'&productoCreditoID='+producto+
					'&tipoReporte='+tr+'&nombreProducto='+nombreProducto;
					$('#ligaGenerar').attr('href',pagina);
				window.open(pagina,'_blank');


		}
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
	
	function menor(fecha, fecha2){ // valida si fecha < fecha2
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);

		if (xAnio < yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes < yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia < yDia){
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
