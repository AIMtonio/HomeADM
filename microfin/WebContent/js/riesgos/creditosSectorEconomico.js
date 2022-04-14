$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = false;
	var parametroBean = consultaParametrosSession(); 

	var catTipoReporte = { 
		'Excel'	: 3
	};	

	var catTipoConsulta = {
		'montoCartera': 1,
		'saldoCartera': 4
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
			bloquearPantallaCarga();
			consultaMontoActividad();
			consultaSaldoActividad();
			consultaMontoCartera(this.id);
			consultaSaldoCartera(this.id);
			
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
			bloquearPantallaCarga();
			consultaMontoActividad();
			consultaSaldoActividad();
			consultaMontoCartera(this.id);
			consultaSaldoCartera(this.id);
			
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
	
	// Funcion para generar en EXCEL información de Créditos por Sector Económico
	function generaExcel() {	
			var tr= catTipoReporte.Excel; 
			var fechaOperacion = $('#fechaOperacion').val();	 
			
			/// VALORES TEXTO
		
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var nomUsuario = parametroBean.nombreUsuario; 

			$('#ligaGenerar').attr('href','credSectorEconomicoRep.htm?fechaOperacion='+fechaOperacion+'&tipoReporte='+tr+
					'&nombreInstitucion='+nombreInstitucion+'&nomUsuario='+nomUsuario
			);
		}

	  
	//Funcion para Consultar el Monto de Cartera por Sector Económico
	function consultaMontoActividad(){
		$('#divMontoActividad').val('');
		var fechaOperacion = $('#fechaOperacion').val();	
		var params = {};		
	
		params['tipoLista'] = 1;
		params['fechaOperacion'] = fechaOperacion;
		
		$.post("credSectorEconomicoGrid.htm", params, function(data){
			if(data.length >0) { 
				$('#divMontoActividad').html(data);
				$('#divMontoActividad').show();
				$('#divMonto').show();
				agregaFormatoControles('divMontoActividad');
				   
			}else{
				$('#divMontoActividad').html("");
				$('#divMontoActividad').show();
			} 
			
		}); 
		
	}
	
	//Funcion para Consultar el Saldo de Cartera por Sector Económico
	function consultaSaldoActividad(){
		$('#divSaldoActividad').val('');
		var fechaOperacion = $('#fechaOperacion').val();	
		var params = {};		
	
		params['tipoLista'] = 2;
		params['fechaOperacion'] = fechaOperacion;
		
		
		$.post("credSectorEconomicoGrid.htm", params, function(data){
			if(data.length >0) { 
				$('#divSaldoActividad').html(data);
				$('#divSaldoActividad').show();
				$('#divSaldo').show();
				agregaFormatoControles('divSaldoActividad');
				totalSaldoCarteraSectorEconomico();
				
				var contador = 0;
				var jqMontoAho ="";
				$('input[name=saldo]').each(function() {	
					contador = contador + 1;
					jqMontoAho = eval("'#saldo"+contador+"'");
					$(jqMontoAho).formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
				});
				   
			}else{
				$('#divSaldoActividad').html("");
				$('#divSaldoActividad').show();
			}	 $('#contenedorForma').unblock();	
		}); 
	}

	
	// Función para consultar el Monto de la Cartera de Crédito
	function consultaMontoCartera(idControl){
		var jqFecha  = eval("'#" + idControl + "'");
		var fecha = $(jqFecha).val();	 
		
		var conCarteraBean  = { 
				'fechaOperacion':fecha
		};	
		setTimeout("$('#cajaLista').hide();", 200);
		if(fecha != ''){	
			
		creditosSectorEconomicoServicio.consulta(catTipoConsulta.montoCartera,conCarteraBean,function(producto) {
			if(producto!=null){
				$('#montoActEconomica').val(producto.montoActEconomica);	
			}  
		});	
	   }
	}
	
	// Función para consultar el Saldo de la Cartera de Crédito
	function consultaSaldoCartera(idControl){
		var jqFecha  = eval("'#" + idControl + "'");
		var fecha = $(jqFecha).val();	 
		
		var conCarteraBean  = { 
				'fechaOperacion':fecha
		};	
		setTimeout("$('#cajaLista').hide();", 200);
		if(fecha != ''){	
			
		creditosSectorEconomicoServicio.consulta(catTipoConsulta.saldoCartera,conCarteraBean,function(producto) {
			if(producto!=null){
				$('#totalCarteraCredito').val(producto.totalCarteraCredito);
				
				$('#totalCarteraCredito').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});			
			}
		});	
	   }
	}

	
	function limpiaFormulario(){
		$('#montoActEconomica').val('');
		$('#saldoCarteraCredito').val('');
		$('#totalCarteraCredito').val('');		
		$('#divMontoActividad').html("");
		$('#divMontoActividad').hide();
		$('#divMonto').hide();
		$('#divSaldoActividad').html("");
		$('#divSaldoActividad').hide();
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
				alert("Formato de Fecha no Válido (aaaa-mm-dd)");
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


	//funcion para obtener la suma de los saldos de créditos por sector económico
	function saldoCarteraSector(){
		var suma=0;
		$('input[name=saldo]').each(function() {
			var numero = this.id.substr(5, this.id.length);
			var montoCartera= eval("'#saldo" + numero + "'");
			var montoCateraTotal=$(montoCartera).asNumber();
			suma=suma+montoCateraTotal;
		});
		return suma;
	}
	
	//funcion para obtener el total del saldo de créditos por sector económico
	function totalSaldoCarteraSectorEconomico(control){
		var totalCartera=saldoCarteraSector();
		$('#saldoCarteraCredito').val(totalCartera);
		$($('#saldoCarteraCredito').val(totalCartera)).formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
		});
	}