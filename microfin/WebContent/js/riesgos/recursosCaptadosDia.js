$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = false;
	var parametroBean = consultaParametrosSession();   

	var catTipoReporte = { 
			'Excel'	: 1
	};	
	
	var catTipoConsulta = {
		'captadosDia':1
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
		else {
			consultaCaptadosDia(this.id);
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
			consultaCaptadosDia(this.id);
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
	
	// Función para consultar los Recursos Captados al Día
	function consultaCaptadosDia(idControl){
		limpiaFormulario();
		var jqFecha  = eval("'#" + idControl + "'");
		var fecha = $(jqFecha).val();	 
		
		var conCaptadosBean  = { 
				'fechaOperacion':fecha
		};	
		setTimeout("$('#cajaListaContenedor').hide();", 200);
		if(fecha != ''){
			bloquearPantallaCarga();
		recursosCaptadosDiaServicio.consulta(catTipoConsulta.captadosDia,conCaptadosBean,function(captados) {
			if(captados!=null){
				$('#montoCaptadoDia').val(captados.montoCaptadoDia);
				$('#ahorroPlazo').val(captados.ahorroPlazo);
				$('#ahorroMenores').val(captados.ahorroMenores);
				$('#ahorroOrdinario').val(captados.ahorroOrdinario);
				$('#ahorroVista').val(captados.ahorroVista);
				
				$('#cuentaSinMov').val(captados.cuentaSinMov);
				$('#depositoInversion').val(captados.depositoInversion);
				$('#montoPlazo30').val(captados.montoPlazo30);
				$('#montoPlazo60').val(captados.montoPlazo60);
				$('#montoPlazo90').val(captados.montoPlazo90);
				
				$('#montoPlazo120').val(captados.montoPlazo120);
				$('#montoPlazo180').val(captados.montoPlazo180);
				$('#montoPlazo360').val(captados.montoPlazo360);
				$('#montoInteresMensual').val(captados.montoInteresMensual);
				$('#captacionTradicional').val(captados.captacionTradicional);
				
				$('#carteraDiaAnterior').val(captados.carteraDiaAnterior);
				$('#carteraCredVigente').val(captados.carteraCredVigente);
				$('#carteraCredVencida').val(captados.carteraCredVencida);
				$('#totalCarteraCredito').val(captados.totalCarteraCredito);
				$('#resultadoPorcentual').val(captados.resultadoPorcentual);
				
				$('#parametroPorcentaje').val(captados.parametroPorcentaje);
				$('#difLimiteEstablecido').val(captados.difLimiteEstablecido);
				$('#saldoCaptadoDia').val(captados.saldoCaptadoDia);
				$('#salAhorroPlazo').val(captados.salAhorroPlazo);
				$('#salAhorroMenores').val(captados.salAhorroMenores);
				
				$('#salAhorroOrdinario').val(captados.salAhorroOrdinario);
				$('#salAhorroVista').val(captados.salAhorroVista);
				$('#salCuentaSinMov').val(captados.salCuentaSinMov);
				$('#saldDepInversion').val(captados.saldDepInversion);
				$('#saldoPlazo30').val(captados.saldoPlazo30);
				
				$('#saldoPlazo60').val(captados.saldoPlazo60);
				$('#saldoPlazo90').val(captados.saldoPlazo90);
				$('#saldoPlazo120').val(captados.saldoPlazo120);
				$('#saldoPlazo180').val(captados.saldoPlazo180);
				$('#saldoPlazo360').val(captados.saldoPlazo360);
				
				$('#saldoInteresMensual').val(captados.saldoInteresMensual);
				$('#salCapTradicional').val(captados.salCapTradicional);
				$('#saldoCartera').val(captados.saldoCartera);
				$('#saldoCredVigente').val(captados.saldoCredVigente);
				$('#saldoCredVencida').val(captados.saldoCredVencida);
				
				$('#saldoTotalCartera').val(captados.saldoTotalCartera);
				$('#saldoPorcentual').val(captados.saldoPorcentual);
				$('#saldoPorcentaje').val(captados.saldoPorcentaje);
				$('#saldoDiferencia').val(captados.saldoDiferencia); 
				

				$('#depositoInversion').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#montoPlazo30').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#montoPlazo60').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#montoPlazo90').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#montoPlazo120').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#montoPlazo180').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#montoPlazo360').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#montoInteresMensual').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#totalCarteraCredito').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoCaptadoDia').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#salAhorroPlazo').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#salAhorroMenores').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#salAhorroOrdinario').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#salAhorroVista').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldDepInversion').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoPlazo30').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoPlazo60').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoPlazo90').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoPlazo120').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoPlazo180').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoPlazo360').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#salCapTradicional').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoCartera').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoCredVigente').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoCredVencida').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoTotalCartera').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#cuentaSinMov').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#salCuentaSinMov').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoInteresMensual').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
			} $('#contenedorForma').unblock();
		});	
	   }
	}
	
	// Funcion para generar en EXCEL Recursos captados al dia
	function generaExcel() {	
		var tr= catTipoReporte.Excel; 
		var fechaOperacion = $('#fechaOperacion').val();	 
		
		/// VALORES TEXTO
	
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var nomUsuario = parametroBean.nombreUsuario; 

		$('#ligaGenerar').attr('href','recursosCaptadosDiaRep.htm?fechaOperacion='+fechaOperacion+'&tipoReporte='+tr+
				'&nombreInstitucion='+nombreInstitucion+'&nomUsuario='+nomUsuario);
	}
	
	function limpiaFormulario () {
		$('#montoCaptadoDia').val('');
		$('#ahorroPlazo').val('');
		$('#ahorroMenores').val('');
		$('#ahorroOrdinario').val('');
		$('#ahorroVista').val('');
		
		$('#depositoInversion').val('');
		$('#montoPlazo30').val('');
		$('#montoPlazo60').val('');
		$('#montoPlazo90').val('');
		$('#montoPlazo120').val('');
		
		$('#montoPlazo180').val('');
		$('#montoPlazo360').val('');
		$('#captacionTradicional').val('');
		$('#carteraDiaAnterior').val('');
		$('#carteraCredVigente').val('');
		
		$('#carteraCredVencida').val('');
		$('#totalCarteraCredito').val('');
		$('#resultadoPorcentual').val('');
		$('#parametroPorcentaje').val('');
		$('#difLimiteEstablecido').val('');
		
		$('#saldoCaptadoDia').val('');
		$('#salAhorroPlazo').val('');
		$('#salAhorroMenores').val('');
		$('#salAhorroOrdinario').val('');
		$('#salAhorroVista').val('');
		
		$('#saldDepInversion').val('');
		$('#saldoPlazo30').val('');
		$('#saldoPlazo60').val('');
		$('#saldoPlazo90').val('');
		$('#saldoPlazo120').val('');
		
		$('#saldoPlazo180').val('');
		$('#saldoPlazo360').val('');
		$('#salCapTradicional').val('');
		$('#saldoCartera').val('');
		$('#saldoCredVigente').val('');
		
		$('#saldoCredVencida').val('');
		$('#saldoTotalCartera').val('');
		$('#saldoPorcentual').val('');
		$('#saldoPorcentaje').val('');
		$('#saldoDiferencia').val('');
		
		$('#cuentaSinMov').val('');
		$('#salCuentaSinMov').val('');
		$('#montoInteresMensual').val('');
		$('#saldoInteresMensual').val('');

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

