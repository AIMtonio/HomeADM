$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = false;
	var parametroBean = consultaParametrosSession();   

	var catTipoReporte = { 
			'Excel'	: 1
	};	

	var catTipoConsulta = {
		'carteraVencida':1
	};
			
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	$('#fechaOperacion').val(parametroBean.fechaSucursal);
	$('#fechaOperacion').focus();

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
			else{
				consultaCarteraVencida(this.id);
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
				else{
					consultaCarteraVencida(this.id);
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

	// ***********  Inicio  validacion   ***********

	// Funcion para generar en EXCEL información de créditos en cartera vencida
	function generaExcel() {	
		var tr= catTipoReporte.Excel; 
		var fechaOperacion = $('#fechaOperacion').val();	 
		
		/// VALORES TEXTO
	
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var nomUsuario = parametroBean.nombreUsuario; 

		$('#ligaGenerar').attr('href','carteraVencidaRep.htm?fechaOperacion='+fechaOperacion+'&tipoReporte='+tr+
				'&nombreInstitucion='+nombreInstitucion+'&nomUsuario='+nomUsuario);
	}
	
	// Función para consultar la cartera vencida
	function consultaCarteraVencida(idControl){
		var jqFecha  = eval("'#" + idControl + "'");
		var fecha = $(jqFecha).val();	 
		
		var conCarteraBean  = { 
				'fechaOperacion':fecha
		};	
		setTimeout("$('#cajaLista').hide();", 200);
		if(fecha != ''){	
			bloquearPantallaCarga();
		carteraVencidaServicio.consulta(catTipoConsulta.carteraVencida,conCarteraBean,function(cartera) {
			if(cartera!=null){
				$('#montoCarteraCredVen').val(cartera.montoCarteraCredVen);
				$('#saldoCarteraCreVen').val(cartera.saldoCarteraCreVen);
				$('#saldoCarteraCredito').val(cartera.saldoCarteraCredito);
				$('#resultadoPorcentual').val(cartera.resultadoPorcentual);
				$('#parametroPorcentaje').val(cartera.parametroPorcentaje);
				
				$('#difLimiteEstablecido').val(cartera.difLimiteEstablecido);
				$('#saldoCarteraCreVencida').val(cartera.saldoCarteraCreVencida);
				$('#resultadoPorcCar').val(cartera.resultadoPorcCar);
				$('#difLimiteEstabCar').val(cartera.difLimiteEstabCar);
				$('#parametroPorcCar').val(cartera.parametroPorcCar);
				
				$('#montoCarteraCredVen').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoCarteraCreVen').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoCarteraCredito').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoCarteraCreVencida').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
			} $('#contenedorForma').unblock();
		});	
	   }
	}

	function limpiaFormulario (){
		$('#montoCarteraCredVen').val('');
		$('#saldoCarteraCreVen').val('');
		$('#saldoCarteraCredito').val('');
		$('#resultadoPorcentual').val('');
		$('#parametroPorcentaje').val('');
		$('#difLimiteEstablecido').val('');
		$('#saldoCarteraCreVencida').val('');
		$('#resultadoPorcCar').val('');
		$('#difLimiteEstabCar').val('');
		$('#parametroPorcCar').val('');
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

