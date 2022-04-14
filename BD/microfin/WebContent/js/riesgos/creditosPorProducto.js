$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = false;
	var parametroBean = consultaParametrosSession(); 

	var catTipoReporte = { 
		'Excel'	: 3
	};	

	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	$('#fechaOperacion').val(parametroBean.fechaSucursal);
	$('#fechaOperacion').focus();
	$('#divMonto').hide();
	$('#divSaldo').hide();
	
	$(':text').focus(function() {	
		esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	
	$('#fechaOperacion').change(function() {
		esTab = false;

		var Xfecha= $('#fechaOperacion').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==true)$('#fechaOperacion').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaSucursal;
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha Especificada no Debe ser Mayor a la del Sistema.");
				$('#fechaOperacion').focus();
				$('#fechaOperacion').val(parametroBean.fechaSucursal);
				limpiaFormulario();
			}
		else {
			consultaMontoProducto();
			consultaSaldoProducto();
			
		}
	   }
	
	});
	   
	
	$('#fechaOperacion').blur(function() {
		if(esTab){

		var Xfecha= $('#fechaOperacion').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==true)$('#fechaOperacion').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaSucursal;
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha Especificada no Debe ser Mayor a la del Sistema.");
				$('#fechaOperacion').focus();
				$('#fechaOperacion').val(parametroBean.fechaSucursal);
				limpiaFormulario();
			}
		else {
			consultaMontoProducto();
			consultaSaldoProducto();
			
		}
	   }
		}
	
	});
	   

	
	   
	 
	$('#generar').click(function() { 
			generaExcel();
	});
	
	// Validaciones de la forma
	 $('#formaGenerica').validate({
		 rules: {
			 fechaOperacion: {
				 required: true,
				 date: true
			 },
		 },	
		 
		 messages: {
			 fechaOperacion: {
				 required:'Especifique Fecha Operación.',
				 date: 'Fecha Incorrecta.'
			 },
			 } 
		 });
	
	// Funcion para generar en EXCEL información de Créditos por Producto
	function generaExcel() {	
		var tr= catTipoReporte.Excel; 
		var fechaOperacion = $('#fechaOperacion').val();	 
		
		/// VALORES TEXTO
	
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var nomUsuario = parametroBean.nombreUsuario; 

		$('#ligaGenerar').attr('href','credPorProductoRep.htm?fechaOperacion='+fechaOperacion+'&tipoReporte='+tr+
				'&nombreInstitucion='+nombreInstitucion+'&nomUsuario='+nomUsuario);
	}

	  
	//Funcion para Consultar el Monto de Cartera por Producto
	function consultaMontoProducto(){
		$('#divMontoProducto').val('');
		var fechaOperacion = $('#fechaOperacion').val();	
		var params = {};		
	
		params['tipoLista'] = 1;
		params['fechaOperacion'] = fechaOperacion;
		bloquearPantallaCarga();
		
		$.post("credPorProductoGrid.htm", params, function(data){
			if(data.length >0) { 
				$('#divMontoProducto').html(data);
				$('#divMontoProducto').show();
				$('#divMonto').show();
				agregaFormatoControles('divMontoProducto');
				totalMontoCarteraProducto(this.id);

			}else{
				$('#divMontoProducto').html("");
				$('#divMontoProducto').show();
			}			
		}); 
		
	}
	
	
	//Funcion para Consultar el Saldo de Cartera por Producto
	function consultaSaldoProducto(){
		$('#divSaldoProducto').val('');
		var fechaOperacion = $('#fechaOperacion').val();	
		var params = {};		
	
		params['tipoLista'] = 2;
		params['fechaOperacion'] = fechaOperacion;
		

		$.post("credPorProductoGrid.htm", params, function(data){
			if(data.length >0) { 
				$('#divSaldoProducto').html(data);
				$('#divSaldoProducto').show();
				$('#divSaldo').show();
				agregaFormatoControles('divSaldoProducto');
				
				totalSaldoCarteraProducto(this.id);
				   
			}else{
				$('#divSaldoProducto').html("");
				$('#divSaldoProducto').show();
			}		
			$('#contenedorForma').unblock();
		}); 
	}
	
	
	function limpiaFormulario(){
		$('#montoProductoCredito').val('');
		$('#saldoCarteraCredito').val('');
		$('#divMontoProducto').html("");
		$('#divMontoProducto').hide();
		$('#divMonto').hide();
		$('#divSaldoProducto').html("");
		$('#divSaldoProducto').hide();
		$('#divSaldo').hide();
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
				alert("Formato de Fecha no Válido (aaaa-mm-dd).");
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
	/***********************************/
	
	//funcion que bloquea la pantalla mientras se cargan los datos
	 function bloquearPantallaCarga() {
	 	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	 	$('#contenedorForma').block({
	 		message : $('#mensaje'),
	 		css : {
	 			border : 'none',
	 			background : 'none'
	 		}
	 	});
	
	 }
});




	//funcion para obtener la suma de montos de créditos por producto
	function totalMontoProducto(){
			var sumaMonto=0;
			$('input[name=monto]').each(function() {
				var numero = this.id.substr(5, this.id.length);
				var montoCartera= eval("'#monto" + numero + "'");
				var montoCarteraTotal=$(montoCartera).asNumber();
				sumaMonto=sumaMonto+montoCarteraTotal;
			});
			return sumaMonto;
	}
	
	//funcion para obtener el total de montos de los productos
	function totalMontoCarteraProducto(control){
			var totalMonto=totalMontoProducto(); 
			$('#montoProductoCredito').val(totalMonto);
			$($('#montoProductoCredito').val(totalMonto)).formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});
	}

	
	//funcion para obtener la suma de saldos de crédito por producto
	function totalSaldoProducto(){
			var sumaSaldo=0;
			$('input[name=saldo]').each(function() {
				var numero2 = this.id.substr(5, this.id.length);
				var saldoCartera= eval("'#saldo" + numero2 + "'");
				var saldoCarteraTotal=$(saldoCartera).asNumber();
				sumaSaldo=sumaSaldo+saldoCarteraTotal;
			});
			return sumaSaldo;
	}
	
	//funcion para obtener el total de saldos de los productos
	function totalSaldoCarteraProducto(control){
			var totalSaldo=totalSaldoProducto(); 
			$('#saldoCarteraCredito').val(totalSaldo);
			$($('#saldoCarteraCredito').val(totalSaldo)).formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});
	}
