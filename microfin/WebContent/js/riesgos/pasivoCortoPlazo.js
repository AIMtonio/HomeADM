$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = false;
	var parametroBean = consultaParametrosSession();   

	var catTipoReporte = { 
		'Excel'	: 1
	};
	
	var catTipoConsulta = {
		'pasivoCtoPlazo' : 1	
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
			consultaPasivoCtoPlazo(this.id);
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
			consultaPasivoCtoPlazo(this.id);
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
	
	
	// Funcion para generar en EXCEL información de Pasivo a Corto Plazo
	function generaExcel() {	
		var tr= catTipoReporte.Excel; 
		var fechaOperacion = $('#fechaOperacion').val();	 
		
		/// VALORES TEXTO
	
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var nomUsuario = parametroBean.nombreUsuario; 

		$('#ligaGenerar').attr('href','pasivoCortoPlazoRep.htm?fechaOperacion='+fechaOperacion+'&tipoReporte='+tr+
				'&nombreInstitucion='+nombreInstitucion+'&nomUsuario='+nomUsuario);
	}
	
	// Función para consultar información de Pasivo a Corto Plazo
	function consultaPasivoCtoPlazo(idControl){
		limpiaFormulario();
		var jqFecha  = eval("'#" + idControl + "'");
		var fecha = $(jqFecha).val();	 
		
		var conPasivoBean  = { 
				'fechaOperacion':fecha
		};	
		setTimeout("$('#cajaListaContenedor').hide();", 200);
		if(fecha != ''){	
			bloquearPantallaCarga();
			pasivoCortoPlazoServicio.consulta(catTipoConsulta.pasivoCtoPlazo,conPasivoBean,function(pasivo) {
			if(pasivo!=null){
				$('#montoCapCierreDia').val(pasivo.montoCapCierreDia);
				$('#ahorroMenores').val(pasivo.ahorroMenores);
				$('#ahorroOrdinario').val(pasivo.ahorroOrdinario);
				$('#ahorroVista').val(pasivo.ahorroVista);
				$('#montoPlazo30').val(pasivo.montoPlazo30);
				
				$('#resultadoPorcentual').val(pasivo.resultadoPorcentual);
				$('#parametroPorcentaje').val(pasivo.parametroPorcentaje);
				$('#difLimiteEstablecido').val(pasivo.difLimiteEstablecido);
				$('#saldoCaptadoDia').val(pasivo.saldoCaptadoDia);
				$('#salAhorroMenores').val(pasivo.salAhorroMenores);
				
				$('#salAhorroOrdinario').val(pasivo.salAhorroOrdinario);
				$('#salAhorroVista').val(pasivo.salAhorroVista);
				$('#saldoPlazo30').val(pasivo.saldoPlazo30);
				$('#saldoPorcentual').val(pasivo.saldoPorcentual);
				$('#saldoPorcentaje').val(pasivo.saldoPorcentaje);
				
				$('#saldoDiferencia').val(pasivo.saldoDiferencia);
				
				$('#montoPlazo30').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#saldoCaptadoDia').formatCurrency({
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
				
				$('#saldoPlazo30').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
			} $('#contenedorForma').unblock();
		});	
	   }
	}
	
	function limpiaFormulario (){
		$('#montoCapCierreDia').val('');
		$('#ahorroMenores').val('');
		$('#ahorroOrdinario').val('');
		$('#ahorroVista').val('');
		$('#montoPlazo30').val('');
		$('#resultadoPorcentual').val('');
		$('#parametroPorcentaje').val('');
		$('#difLimiteEstablecido').val('');
		$('#saldoCaptadoDia').val('');
		$('#salAhorroMenores').val('');
		$('#salAhorroOrdinario').val('');
		$('#salAhorroVista').val('');
		$('#saldoPlazo30').val('');
		$('#saldoPorcentual').val('');
		$('#saldoPorcentaje').val('');
		$('#saldoDiferencia').val('');
		
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

