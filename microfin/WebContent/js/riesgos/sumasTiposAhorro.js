$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = false;
	var parametroBean = consultaParametrosSession(); 

	var catTipoReporte = { 
		'Excel'	: 1
	};	

	var catTipoConsulta = {
		'sumaTipoAhorro' : 1	
	};
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	$('#fechaOperacion').val(parametroBean.fechaSucursal);
	$('#fechaOperacion').focus();
	$('#montoSocio').hide();
	
	$(':text').focus(function() {	
		esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#fechaOperacion').change(function() {
		var Xfecha= $('#fechaOperacion').val();
		esTab = false;
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
			consultaSumaTipoAhorro(this.id);
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
			consultaSumaTipoAhorro(this.id);
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
	
	// Funcion para generar en EXCEL Sumas por Tipos de Ahorro
	function generaExcel() {	
		var tr= catTipoReporte.Excel; 
		var fechaOperacion = $('#fechaOperacion').val();	 
		
		/// VALORES TEXTO
	
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var nomUsuario = parametroBean.nombreUsuario; 

		$('#ligaGenerar').attr('href','sumaTiposAhorroRep.htm?fechaOperacion='+fechaOperacion+'&tipoReporte='+tr+
				'&nombreInstitucion='+nombreInstitucion+'&nomUsuario='+nomUsuario);
	 }

	// Función para consultar Suma Ahorros e Inversiones
	function consultaSumaTipoAhorro(idControl){
		limpiaFormulario();
		var jqFecha  = eval("'#" + idControl + "'");
		var fecha = $(jqFecha).val();	 
		
		var conTipoAhoBean  = { 
				'fechaOperacion':fecha
		};	
		setTimeout("$('#cajaListaContenedor').hide();", 200);
		if(fecha != ''){	
			bloquearPantallaCarga();
			sumaTiposAhorroServicio.consulta(catTipoConsulta.sumaTipoAhorro,conTipoAhoBean,function(suma) {
			if(suma!=null){
				$('#montoCaptadoDia').val(suma.montoCaptadoDia);
				$('#ahorroMenores').val(suma.ahorroMenores);
				$('#ahorroOrdinario').val(suma.ahorroOrdinario);  
				$('#ahorroVista').val(suma.ahorroVista);  
				$('#cuentaSinMov').val(suma.cuentaSinMov);

				$('#depositoInversion').val(suma.depositoInversion);
				$('#montoPlazo30').val(suma.montoPlazo30);
				$('#montoPlazo60').val(suma.montoPlazo60);
				$('#montoPlazo90').val(suma.montoPlazo90);
				$('#montoPlazo120').val(suma.montoPlazo120);
				
				$('#montoPlazo180').val(suma.montoPlazo180);
				$('#montoPlazo360').val(suma.montoPlazo360);
				$('#montoInteresMensual').val(suma.montoInteresMensual);
				$('#montoVistaOrdinario').val(suma.montoVistaOrdinario);
				$('#porcentualAhorroVista').val(suma.porcentualAhorroVista);

				$('#montoInversion').val(suma.montoInversion);
				$('#porcentualInversiones').val(suma.porcentualInversiones);
				$('#saldoCaptadoDia').val(suma.saldoCaptadoDia);
				$('#salAhorroMenores').val(suma.salAhorroMenores);
				$('#salAhorroOrdinario').val(suma.salAhorroOrdinario);

				$('#salAhorroVista').val(suma.salAhorroVista);
				$('#salCuentaSinMov').val(suma.salCuentaSinMov);
				$('#saldDepInversion').val(suma.saldDepInversion);
				$('#saldoPlazo30').val(suma.saldoPlazo30);
				$('#saldoPlazo60').val(suma.saldoPlazo60);

				$('#saldoPlazo90').val(suma.saldoPlazo90);
				$('#saldoPlazo120').val(suma.saldoPlazo120);
				$('#saldoPlazo180').val(suma.saldoPlazo180);
				$('#saldoPlazo360').val(suma.saldoPlazo360);
				$('#saldoInteresMensual').val(suma.saldoInteresMensual);

				$('#saldoVistaOrdinario').val(suma.saldoVistaOrdinario);
				$('#salPorcentualAhorroVista').val(suma.salPorcentualAhorroVista);
				$('#saldoInversion').val(suma.saldoInversion);
				$('#salPorcentualInversiones').val(suma.salPorcentualInversiones);
				$('#diferenciaAhorroVista').val('60 / 85');
				
				$('#diferenciaInversiones').val('15 / 40');
				$('#salDiferenciaAhorroVista').val('60 / 85');
				$('#salDiferenciaInversiones').val('15 / 40');

				$('#depositoInversion').formatCurrency({
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
				
				$('#salCuentaSinMov').formatCurrency({
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
				
				$('#saldoInteresMensual').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});

				$('#saldoVistaOrdinario').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
				$('#montoVistaOrdinario').formatCurrency({
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

				$('#saldoInversion').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});

				$('#montoInversion').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				
			}  $('#contenedorForma').unblock();
		});	
	   }
	}
	

	function limpiaFormulario (){
		$('#montoCaptadoDia').val('');
		$('#ahorroMenores').val('');
		$('#ahorroOrdinario').val('');  
		$('#ahorroVista').val('');  
		$('#cuentaSinMov').val('');

		$('#depositoInversion').val('');
		$('#montoPlazo30').val('');
		$('#montoPlazo60').val('');
		$('#montoPlazo90').val('');
		$('#montoPlazo120').val('');
		
		$('#montoPlazo180').val('');
		$('#montoPlazo360').val('');
		$('#montoInteresMensual').val('');
		$('#montoVistaOrdinario').val('');
		$('#porcentualAhorroVista').val('');
		
		$('#montoInversion').val('');
		$('#porcentualInversiones').val('');
		$('#saldoCaptadoDia').val('');
		$('#salAhorroMenores').val('');
		$('#salAhorroOrdinario').val('');
		
		$('#salAhorroVista').val('');
		$('#salCuentaSinMov').val('');
		$('#saldDepInversion').val('');
		$('#saldoPlazo30').val('');
		$('#saldoPlazo60').val('');
		
		$('#saldoPlazo90').val('');
		$('#saldoPlazo120').val('');
		$('#saldoPlazo180').val('');
		$('#saldoPlazo360').val('');
		$('#saldoInteresMensual').val('');
		
		$('#saldoVistaOrdinario').val('');
		$('#salPorcentualAhorroVista').val('');
		$('#saldoInversion').val('');
		$('#salPorcentualInversiones').val('');

		$('#diferenciaAhorroVista').val('');
		$('#diferenciaInversiones').val('');
		$('#salDiferenciaAhorroVista').val('');
		$('#salDiferenciaInversiones').val('');
		
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



