$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();
	var fechaFinMes;
	var mesFecha;

	var catTipoListaRepBuroCred = {
  		'repBuroCred'	: 7

	};

	var catTipoRepBuroCred = {
  		'repTxt'	: 1,
  		'repExcel'	: 2,
		'repExt'	: 3
	};
	var catTipoPersona = {
  		'personaFisica'	: 1,
  		'personaMoral'	: 2
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();
	$('#fechaInicio').focus();



	$(':text').focus(function() {
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#txt').attr("checked",true);
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#intl').hide();
	$('#lblIntl').hide();
	$('#tipoFormatoCinta').val(1);

	$('#moral').click(function(){
		$('#fisica').attr("checked",false) ;
		$('#diario').attr('disabled', true);
		$('#mensual').attr("checked",true) ;
		$('#generar').focus();
		validaFechaMes();
		$('#tipoPersona').val('M');
		$('#intl').show();
		$('#lblIntl').show();
		$('#ext').hide();
		$('#lblExt').hide();
		$('#txt').show();
		$('#lblTxt').show();
		$('#txt').attr("checked",true) ;

		$('#mensualVtaCartera').attr('readOnly',true);	
		$('#mensualVtaCartera').attr('disabled',true);	


	});
	$('#fisica').click(function(){
		$('#diario').attr('disabled', false);
		$('#moral').attr("checked",false) ;
		$('#diario').show();
		$('#ldiario').show();
		$('#diario').attr("checked",true);
		$('#tipoPersona').val('F');
		//Tipo de formato cinta de buro
		$('#intl').hide();
		$('#lblIntl').hide();
		$('#tipoFormatoCinta').val(1);
		$('#txt').attr("checked",true);
		$('#intl').attr("checked",false);
		$('#ext').attr("checked",false);
		$('#ext').hide();
		$('#lblExt').hide();

		$('#mensualVtaCartera').attr('readOnly',false);	
		$('#mensualVtaCartera').attr('disabled',false);	

	});

	$('#txt').click(function(){
		$('#tipoReporte').val(1);
		//Se indica que el tipo 1 es formato csv
		$('#intl').attr("checked",false);
		$('#ext').attr("checked",false);
		$('#tipoFormatoCinta').val(1);
	});
	
	/*
	 * @Descripion: Metodo del click de formato intl
	 **/
	$('#intl').click(function(){
		$('#txt').attr("checked",false);
		$('#ext').attr("checked",false);
		$('#tipoReporte').val(1);
		//Se indica que el tipo 2 es formato INTL
		$('#tipoFormatoCinta').val(2);
	});

	/*
	 * @Descripion: Metodo del click de formato ext
	 **/
	$('#ext').click(function(){
		$('#txt').attr("checked",false);
		$('#intl').attr("checked",false);
		$('#tipoReporte').val(1);
		//Se indica que el tipo 3 es formato EXT
	});

	//Se invocan las funcions onclick
	$('#fisica').click();
	$('#txt').click();

	$('#fechaInicio').change(function(){

		if($('#diario').is(':checked')){
			var Xfecha= $('#fechaInicio').val();
			if(esFechaValida(Xfecha)){
				if(Xfecha == ''){
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}else{
				var Yfecha = parametroBean.fechaAplicacion;
				if( mayor(Xfecha , Yfecha)){
					if($('#diario').is(':checked')){
					mensajeSis("La Fecha no Debe ser Mayor a la del Sistema")	;
					$('#fechaInicio').val(parametroBean.fechaSucursal);
					regresarFoco('fechaInicio');
					}
				}else{
					if(!esTab){
						regresarFoco('fechaInicio');
					}
				}
			  }
			}else{
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				regresarFoco('fechaInicio');
			}
		}else{

			validaFechaMes();
		}
	});

	$('#fechaInicio').blur(function(){

		if($('#diario').is(':checked')){
			var Xfecha= $('#fechaInicio').val();
			if(esFechaValida(Xfecha)){
				if(Xfecha == ''){
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}else{
				var Yfecha = parametroBean.fechaAplicacion;
				if( mayor(Xfecha , Yfecha)){
					if($('#diario').is(':checked')){
					mensajeSis("La Fecha no Debe ser Mayor a la del Sistema")	;
					$('#fechaInicio').val(parametroBean.fechaSucursal);
					regresarFoco('fechaInicio');
					}
				}else{
					if(!esTab){
						regresarFoco('fechaInicio');
					}
				}
			  }
			}else{
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				regresarFoco('fechaInicio');
			}
		}else{

			validaFechaMes();
		}
	});


	function validaFechaMes(){

		if($('#mensual').is(':checked') || $('#mensualVtaCartera').is(':checked')){

			var Xfecha = $('#fechaInicio').val();
			var Zfecha = parametroBean.fechaAplicacion;
			var fechaFinMes = validarFechaPeriodo(parametroBean.fechaSucursal.split('-'));

			if( mayor(Xfecha , Zfecha)){
				mensajeSis("La Fecha no Debe ser Mayor a la del Sistema");
				$('#fechaInicio').val(fechaFinMes);
				regresarFoco('fechaInicio');

			}else if(mayor(Xfecha , fechaFinMes)){
				$('#fechaInicio').val(fechaFinMes);
			}
	   }
	}


	$('#mensual').click(function(){
		validaFechaMes();

		if ( $("#formaGenerica input[name='fisica']:radio").is(':checked') ||
			 $("#formaGenerica input[name='moral']:radio").is(':checked') ) {
			$('#ext').hide();
			$('#lblExt').hide();
			$('#txt').show();
			$('#lblTxt').show();
		} else {
			$('#ext').show();
			$('#lblExt').show();
			$('#txt').hide();
			$('#lblTxt').hide();
		}

		if ( $("#formaGenerica input[name='fisica']:radio").is(':checked') ) {
			$('#txt').attr("checked",true);
		}
	});

	$('#diario').click(function(){
		$('#fechaInicio').val(parametroBean.fechaSucursal);
		
		if ( $("#formaGenerica input[name='fisica']:radio").is(':checked') ) {
			$('#ext').hide();
			$('#lblExt').hide();
			$('#txt').show();
			$('#lblTxt').show();
			$('#txt').attr("checked",true);
		} else {
			$('#ext').show();
			$('#lblExt').show();
			$('#txt').hide();
			$('#lblTxt').hide();
		}
	});

	$('#semanal').click(function(){
		$('#fechaInicio').val(parametroBean.fechaSucursal);

		if ( $("#formaGenerica input[name='fisica']:radio").is(':checked') ) {
			$('#ext').show();
			$('#lblExt').show();
			$('#txt').show();
			$('#lblTxt').show();
			$('#txt').attr("checked",false);
			$('#ext').attr("checked",true);
			$('#tipoFormatoCinta').val(3);
		} else {
			$('#ext').hide();
			$('#lblExt').hide();
			$('#txt').show();
			$('#lblTxt').show();
			$('#ext').attr("checked",false);
		}
	});

	$('#mensualVtaCartera').click(function(){
		validaFechaMes();

		if ( $("#formaGenerica input[name='fisica']:radio").is(':checked') ) {
			$('#ext').hide();
			$('#lblExt').hide();
			$('#txt').show();
			$('#lblTxt').show();
			$('#txt').attr("checked",true);
		} else {
			$('#ext').show();
			$('#lblExt').show();
			$('#txt').hide();
			$('#lblTxt').hide();
		}
	});

	$('#generar').click(function(){
		if($('#txt').is(":checked") && $('#fisica').is(":checked")){
			generaTxt();
			generarReporteCovid();
		}else if($('#txt').is(":checked") || $('#intl').is(":checked") && $('#moral').is(":checked") ){
			generaPersonaMoral();
			generarReporteCovid();
		} else if($('#ext').is(":checked") && $('#fisica').is(":checked") && $('#semanal').is(":checked") ){
			$('#tipoFormatoCinta').val(3);
			generaExt();
		}
		else	event.preventDefault();
	});


	function generaPersonaMoral() {
		if($('#txt').is(':checked') || $('#intl').is(":checked")){
			var	per=catTipoPersona.personaMoral;
			var tr= catTipoRepBuroCred.repTxt;
			var tl= catTipoListaRepBuroCred.repBuroCred;
			var fechaInicio = $('#fechaInicio').val();
			var tiempoReporte = "";
			var tipoCinta = $('#tipoFormatoCinta').val();
			if($('#diario').is(':checked')){
				tiempoReporte = $('#diario').val();
			}
			if($('#semanal').is(':checked')){
				tiempoReporte = $('#semanal').val();
			}
			if($('#mensual').is(':checked')){
				tiempoReporte = $('#mensual').val();
			}
			if($('#mensualVtaCartera').is(':checked')){
				tiempoReporte = $('#mensualVtaCartera').val();
			}

			$('#ligaGenerar').attr('href','reporteEnvBuroCredito.htm?fechaInicio='+fechaInicio+'&tipoReporte='+tr+'&tipoLista='+tl+'&tipoPersona='+per+'&tiempoReporte='+tiempoReporte+'&tipoFormatoCinta='+tipoCinta);
		}
	}

	function generaTxt(){
		if($('#txt').is(':checked')){
			$('#excel').attr("checked",false);
			var	per=catTipoPersona.personaFisica;
			var tr= catTipoRepBuroCred.repTxt;
			var tl= catTipoListaRepBuroCred.repBuroCred;
			var fechaInicio = $('#fechaInicio').val();
			var tiempoReporte = "";
			var tipoCinta = $('#tipoFormatoCinta').val();
			if($('#diario').is(':checked')){
				tiempoReporte = $('#diario').val();
			}
			if($('#semanal').is(':checked')){
				tiempoReporte = $('#semanal').val();
			}
			if($('#mensual').is(':checked')){
				tiempoReporte = $('#mensual').val();
			}
			if($('#mensualVtaCartera').is(':checked')){
				tiempoReporte = $('#mensualVtaCartera').val();
			}

			$('#ligaGenerar').attr('href','reporteEnvBuroCredito.htm?fechaInicio='+fechaInicio+'&tipoReporte='+tr+'&tipoLista='+tl+'&tiempoReporte='+tiempoReporte+'&tipoPersona='+per+'&tipoFormatoCinta='+tipoCinta);

		}
	}

	function generaExt(){
		if ( $('#ext').is(':checked') ) {
			var	per=catTipoPersona.personaFisica;
			var tr= catTipoRepBuroCred.repExt;
			var tl= catTipoListaRepBuroCred.repBuroCred;
			var fechaInicio = $('#fechaInicio').val();
			var tipoCinta = $('#tipoFormatoCinta').val();
			var	tiempoReporte = $('#semanal').val();

			$('#ligaGenerar').attr('href','reporteEnvBuroCredito.htm?fechaInicio='+fechaInicio+'&tipoReporte='+tr+'&tipoLista='+tl+'&tiempoReporte='+tiempoReporte+'&tipoPersona='+per+'&tipoFormatoCinta='+tipoCinta);

		}
	}
	//Metodo para generar el reporte de creditos diferidos
	function generarReporteCovid(){
		//Solo se genera para reporte mensuales
		if($('#mensual').is(':checked')){
			var	per = $('#tipoPersona').val();
			var tr = 2;
			var tl= 1;
			var fechaInicio = $('#fechaInicio').val();
			var tiempoReporte = "";
			if($('#diario').is(':checked')){
				tiempoReporte = $('#diario').val();
			}
			if($('#semanal').is(':checked')){
				tiempoReporte = $('#semanal').val();
			}
			if($('#mensual').is(':checked')){
				tiempoReporte = $('#mensual').val();
			}
			if($('#mensualVtaCartera').is(':checked')){
				tiempoReporte = $('#mensualVtaCartera').val();
			}
			var ligaGenerar = '';
			ligaGenerar = 'reporteCovidBuroCredito.htm?fechaInicio='+fechaInicio+'&tipoReporte='+tr+'&tipoLista='+tl+'&tiempoReporte='+tiempoReporte+'&tipoPersona='+per;
			window.open(ligaGenerar, '_blank');
		};

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



		function menor(fecha, fecha2){
			//0|1|2|3|4|5|6|7|8|9|
			//2 0 1 2 / 1 1 / 2 0
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
//		FIN VALIDACIONES DE REPORTES

		/*funcion valida fecha formato (yyyy-MM-dd)*/
		function esFechaValida(fecha){

			if (fecha != undefined && fecha.value != "" ){
				var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
				if (!objRegExp.test(fecha)){
					mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd)");
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
					if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
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

		//Regresar el foco a un campo de texto.
		function regresarFoco(idControl){
			var jqControl=eval("'#"+idControl+"'");
			setTimeout(function(){
				$(jqControl).focus();
			 },0);
		}

		function validarFechaPeriodo(fecha){
			var fechaActual=(parametroBean.fechaAplicacion).split('-');
			var anioActual= fechaActual[0];
			var fechaCompleta='';
			var ano=fecha[0];
			var mes = fecha[1];
			var dia = fecha[2];
			mes=parseInt(mes);


			if(mes==1){
				ano=ano-1;
				mes=12;
			}else{
				mes=mes-1;
			}
			if( mes==1 || mes==3 || mes==5 || mes==7 || mes==8 || mes==10 || mes==12){
				dia=31;
			}else if(mes==4 || mes==6 || mes==9 || mes==11){
				dia=30;
			}else if(mes==2){
				if(comprobarSiBisisesto(ano)){
					dia=29;
				}else{

					dia=28;
				}
			}

			mes<10? mes=('0'+mes):mes;
			fechaCompleta=ano+"-"+mes+"-"+dia;
			fechaFinMes = fechaCompleta;
			return fechaCompleta;
		}

		function validaFechaMensual(){
			if($('#mensual').is(':checked')){
				$('#fechaInicio').val(validarFechaPeriodo($('#fechaInicio').val().split('-')));
			}
		}

});
