$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	fechaVacia = '1900-01-01';
	var parametroBean = consultaParametrosSession();   
	consultaInstitucion();
	$('#fecha').focus();
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	 $('#div2013').hide();
	 $('#div2014').hide();
	 $('#div2013').hide();
	$('#div2014').hide();
	$('#version').hide();
	$('#div2017').hide();
	$('#version2017').hide();

	 $('#excel').attr("checked",true); 
	 
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
	  	}
	});	
	
	$('#año13').click(function() {
		$('#año14').attr("checked",false); 
		$('#año13').attr("checked",true); 
		 $('#div2013').show();
		 $('#div2014').hide();
		 $('#excel').attr("checked",true); 
		 $('#csv').attr("checked",false); 
		 $('#excel2').attr("checked",false); 
		 

	});
	
	$('#año14').click(function() {
		$('#año14').attr("checked",true); 
		$('#año13').attr("checked",false); 
		 $('#div2013').hide();
		 $('#div2014').show();
		 $('#excel2').attr("checked",true); 
		 $('#excel').attr("checked",false); 
		 $('#csv').attr("checked",false); 
	});
	
	$('#excel').click(function() {
		$('#csv').attr("checked",false); 
		$('#excel').attr("checked",true); 

	});
	
	$('#csv').click(function() {
		$('#csv').attr("checked",true); 
		$('#excel').attr("checked",false); 
	});
	
	$('#excel2').click(function() {
		$('#csv').attr("checked",false); 
		$('#excel').attr("checked",false); 
		$('#excel2').attr("checked",true); 

	});

	$('#excel2017').click(function() {
		$('#csv2017').attr("checked",false); 
		$('#excel2017').attr("checked",true);

	});
	
	$('#csv2017').click(function() {
		$('#csv2017').attr("checked",true); 
		$('#excel2017').attr("checked",false); 
	});

	var fecha = parametroBean.fechaAplicacion;
	$('#fecha').val(fecha);
	
	$('#generar').click(function() { 
		var varFecha = $('#fecha').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if (varFecha == fechaVacia || varFecha == ''){ 
			mensajeSis('Favor de Especificar una Fecha Valida');
			$('#fecha').focus();
		}
		else if($('#excel2').is(":checked") && $('#año14').is(":checked")){ 

			consultaFechaCorteExcel(varFecha);
		}
		else if($('#excel').is(":checked") && $('#año13').is(":checked")){ 
			consultaFechaCorteExcel2013(varFecha);
		}
		else if($('#csv').is(":checked") && $('#año13').is(":checked")){ 
			consultaFechaCorteCSV(varFecha);
		}else if($('#excel2017').is(":checked") && $('#anio2017').is(":checked")){

			consultaFechaCorte2017(varFecha,1);
		}else if($('#csv2017').is(":checked") && $('#anio2017').is(":checked")){
			consultaFechaCorte2017(varFecha,2);
		}
	});

	$('#fecha').change(function() {
		var Xfecha= $('#fecha').val();
		if(Xfecha == '1900-01-01'){
			mensajeSis("Debe de Indicar una Fecha no Vacia");
			$('#fecha').val(parametroBean.fechaSucursal);
		}else{
			if(Xfecha=='')$('#fecha').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaSucursal;
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha es Mayor a la Fecha del Sistema.")	;
				$('#fecha').val(parametroBean.fechaSucursal);
			}
   		}
	});

	$('#fecha').blur(function() {
		var Xfecha= $('#fecha').val();
		if(Xfecha == '1900-01-01'){
			mensajeSis("Dede de indicar una Fecha no Vacia");
			$('#fecha').val(parametroBean.fechaSucursal);
		}else{
			if(esFechaValida(Xfecha)){
				if(Xfecha=='')$('#fecha').val(parametroBean.fechaSucursal);
				var Yfecha= parametroBean.fechaSucursal;
				if ( mayor(Xfecha, Yfecha) )
				{
					mensajeSis("La Fecha es Mayor a la Fecha del Sistema.")	;
					$('#fecha').val(parametroBean.fechaSucursal);
				} 
			}else{
				$('#fecha').val(parametroBean.fechaSucursal);
			}
		}
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			fecha: {
				required: true,
				date : true
				}
		},
		messages: {
			fecha: {
				required: 'Especificar Fecha',
				date : 'Fecha Incorrecta'}
		}		
	});
	
	/*Consulta para obtener una fecha de corte de saldos creditos 2013*/
	function consultaFechaCorteExcel2013(varFecha){
		setTimeout("$('#cajaLista').hide();", 200);
		
		var tipoReporte = 2;
		var tipoEntidad = 6;
		
		if(varFecha != ''){
			var creditoBeanCon = { 
			'fechaCorte':varFecha
			};
			
			creditosServicio.consulta(4,creditoBeanCon,function(credito) {
				if(credito!=null){
					esTab=true;	
					if(credito.fechaCorte!= varFecha){
						mensajeSis("No se encontró información para la fecha: "+varFecha+
								"\nLa última fecha con información es: "+ credito.fechaCorte);
						$('#fecha').val(credito.fechaCorte);
						$('#fecha').focus();
					}else{
						pagina='RepCarteraporTipoCredA0411.htm?fecha='+varFecha+'&tipoReporte='+tipoReporte+'&tipoEntidad='+tipoEntidad;
						window.open(pagina);
					}
				}
			});
		}
	}
	
	/*Consulta para obtener una fecha de corte de saldos creditos 2014 */
	function consultaFechaCorteExcel(varFecha){
		setTimeout("$('#cajaLista').hide();", 200);
		var tipoReporte = 1;
		var tipoEntidad = 6;
		
		if(varFecha != ''){
			var creditoBeanCon = { 
			'fechaCorte':varFecha
			};
			
			creditosServicio.consulta(4,creditoBeanCon,function(credito) {
				if(credito!=null){
					esTab=true;	
					if(credito.fechaCorte!= varFecha){
						mensajeSis("No se encontró información para la fecha: "+varFecha+
								"\nLa última fecha con información es: "+ credito.fechaCorte);
						$('#fecha').val(credito.fechaCorte);
						$('#fecha').focus();
					}else{
						pagina='RepCarteraporTipoCredA0411.htm?fecha='+varFecha+'&tipoReporte='+tipoReporte+'&tipoEntidad='+tipoEntidad;
						window.open(pagina);
					}
				}
			});
		}
	}

	/*Consulta para obtener una fecha de corte de saldos creditos en CSV */
	function consultaFechaCorteCSV(varFecha){
		setTimeout("$('#cajaLista').hide();", 200);
		var tipoReporte = 3;
		var tipoEntidad = 6;
		
		if(varFecha != ''){
			var creditoBeanCon = { 
			'fechaCorte':varFecha
			};
			
			creditosServicio.consulta(4,creditoBeanCon,function(credito) {
				if(credito!=null){
					esTab=true;	
					if(credito.fechaCorte!= varFecha){
						mensajeSis("No se encontró información para la fecha: "+varFecha+
								"\nLa última fecha con información es: "+ credito.fechaCorte);
						$('#fecha').val(credito.fechaCorte);
						$('#fecha').focus();
					}else{
						pagina='RepCarteraporTipoCredA0411.htm?fecha='+varFecha+'&tipoReporte='+tipoReporte+'&tipoEntidad='+tipoEntidad;
						window.open(pagina);
					}
				}
			});
		}
	}

	/*Consulta para obtener una fecha de corte de saldos creditos 2014 */
	function consultaFechaCorte2017(varFecha,varTipoReporte){
		setTimeout("$('#cajaLista').hide();", 200);
		var tipoReporte = varTipoReporte;
		var tipoEntidad = 3;
		if(varFecha != ''){
			var creditoBeanCon = { 
			'fechaCorte':varFecha
			};
			
			creditosServicio.consulta(4,creditoBeanCon,function(credito) {
				if(credito!=null){
					esTab=true;	
					if(credito.fechaCorte!= varFecha){
						mensajeSis("No se encontró información para la fecha: "+varFecha+
								"\nLa última fecha con información es: "+ credito.fechaCorte);
						$('#fecha').val(credito.fechaCorte);
						$('#fecha').focus();
					}else{
						pagina='RepCarteraporTipoCredA0411.htm?fecha='+varFecha+'&tipoReporte='+tipoReporte+'&tipoEntidad='+tipoEntidad;
						window.open(pagina);
					}
				}
			});
		}
	}

	
	function consultaInstitucion(){
	   var tipoConsulta = 9;
	   var bean = { 
				'empresaID'		: 1		
			};
		
		paramGeneralesServicio.consulta(tipoConsulta, bean,function(Institucion){
			   tipoInstitucion = Institucion.valorParametro;
			   	validaRegulatorioInstitucion();

		   });
   }

   function validaRegulatorioInstitucion(){
	   	var mensajeRegulatorio = '<div style="border: 1px solid #f3f5f6;width: 250px;margin: 0 auto;"><div style="background: #1d4e77;color: #fff;padding: 5px 10px;border-radius: 5px 5px 0px 0px;">Mensaje:</div> '
					+ '<div style="background: #f3f5f6;padding: 5px 10px;text-align: justify;">Estimado Usuario el Regulatorio seleccionado no Aplica para su Tipo de Institución.</div> '
					+ ' <div class="footer"></div></div>';

		//" 
		 var regulatorio = {
				   'clave' : 'A0411'
		   }
		   var numConsulta = 1;
		   

	   	regulatorioInsServicio.consulta(numConsulta,regulatorio,function(valida){
			   if(valida.aplica == 'N'){
				  $('#tblRegulatorio').html(mensajeRegulatorio);
			   }else{ 
			   		if (tipoInstitucion==6){
			   				$('#div2013').show();
	 					$('#div2014').hide();
			   			$('#version').show();
			   			$('#div2017').hide();
			   			$('#version2017').hide();
			   		}else{
			   			$('#div2013').hide();
	 					$('#div2014').hide();
			   			$('#version').hide();
			   			$('#div2017').show();
			   			$('#version2017').show();
			   			$('#csv').attr("checked",false); 
						$('#excel').attr("checked",false); 
						$('#excel2').attr("checked",false); 

			   			
			   		}
			   }
		   });
		   
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
	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha!= "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
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
				mensajeSis("Fecha introducida errónea  ");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea  ");
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
});
