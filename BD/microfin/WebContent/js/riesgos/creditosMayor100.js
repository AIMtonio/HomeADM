$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var parametroBean = consultaParametrosSession();   

	var catTipoReporte = { 
		'Excel'	: 1
	};	

	var catTipoConsulta = {
		'menorCienMil': 1
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	$('#fechaOperacion').val(parametroBean.fechaSucursal);
	$('#fechaSistema').val(parametroBean.fechaSucursal);
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
		$('#fechaOperacion').focus();
	}); 
	 
	$('#fechaOperacion').blur(function() { 
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
				consultaCreditosMayor100(this.id);
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
	
	
	// Funcion para generar en EXCEL Créditos menor a $ 100,000.00
	function generaExcel() {	
		var tr= catTipoReporte.Excel; 
		var fechaOperacion = $('#fechaOperacion').val();	 
		
		/// VALORES TEXTO
	
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var nomUsuario = parametroBean.nombreUsuario; 

		$('#ligaGenerar').attr('href','credMayor100Rep.htm?fechaOperacion='+fechaOperacion+'&tipoReporte='+tr+
				'&nombreInstitucion='+nombreInstitucion+'&nomUsuario='+nomUsuario);
	}
	
	// Función para consultar Créditos menor a $ 100,000.00
	function consultaCreditosMayor100(idControl){
		esTab = true;
		var jqFecha  = eval("'#" + idControl + "'");
		var fecha = $(jqFecha).val();	 
		
		var conMenorCienMilBean  = { 
				'fechaOperacion':fecha
		};	
		setTimeout("$('#cajaLista').hide();", 200);
		if(fecha != ''){	
		creditosMayor100Servicio.consulta(catTipoConsulta.menorCienMil,conMenorCienMilBean,function(consulta) {
			if(consulta!=null){
				$('#montoCarteraAnterior').val(consulta.montoCarteraAnterior);
				$('#saldoCarteraCredito').val(consulta.saldoCarteraCredito);
				$('#resultadoPorcentual').val(consulta.resultadoPorcentual);
				$('#parametroPorcentaje').val(consulta.parametroPorcentaje);
				$('#difLimiteEstablecido').val(consulta.difLimiteEstablecido);
				
				$('#saldoCartera').val(consulta.saldoCartera);
				$('#saldoTotalCartera').val(consulta.saldoTotalCartera);
				$('#resultadoPorcCredito').val(consulta.resultadoPorcCredito);
				$('#parametroPorcCredito').val(consulta.parametroPorcCredito);
				$('#difLimiteEstabCredito').val(consulta.difLimiteEstabCredito);
				
				$('#saldoCarteraCredito').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoCartera').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoTotalCartera').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
			}
		});	
	  }
	}
	
	function limpiaFormulario(){
		$('#montoCarteraAnterior').val('');
		$('#saldoCarteraCredito').val('');
		$('#resultadoPorcentual').val('');
		$('#parametroPorcentaje').val('');
		$('#difLimiteEstablecido').val('');
		$('#saldoCartera').val('');
		$('#saldoTotalCartera').val('');
		$('#resultadoPorcCredito').val('');
		$('#parametroPorcCredito').val('');
		$('#difLimiteEstabCredito').val('');
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
});

