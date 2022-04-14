$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	fechaVacia = '1900-01-01';
	var parametroBean = consultaParametrosSession();   
	
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
	  	}
	});	
	
	$('#excel').click(function() {
		$('#csv').attr("checked",false); 
		$('#excel').attr("checked",true); 

	});
	
	$('#csv').click(function() {
		$('#csv').attr("checked",true); 
		$('#excel').attr("checked",false); 
	});
	
	
	var fecha = parametroBean.fechaAplicacion;
	$('#fecha').val(fecha);
	
	$('#generar').click(function() { 
		var varFecha = $('#fecha').val();
		var varanioversion= $('input[name=version]:checked').val();
		var tipoConsulta = 4;
		
		setTimeout("$('#cajaLista').hide();", 200);
		
		if (varFecha == fechaVacia || varFecha == ''){ 
			alert('Favor de Especificar una Fecha Valida');
			$('#fecha').focus();
		}
		else if($('#excel').is(":checked")){ 
			consultaFechaSaldosExcel(varFecha, tipoConsulta, varanioversion);
		}
		else if($('#csv').is(":checked")){ 
			consultaFechaSaldosCSV(varFecha,tipoConsulta, varanioversion);
		}
	});
	

   $('#fecha').change(function() {
		var Xfecha= $('#fecha').val();
		if(Xfecha == '1900-01-01'){
			alert("Debe de Indicar una Fecha no Vacia");
			$('#fecha').val(parametroBean.fechaSucursal);
		}else{
			if(Xfecha=='')$('#fecha').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaSucursal;
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha es Mayor a la Fecha del Sistema.")	;
				$('#fecha').val(parametroBean.fechaSucursal);
			}
   		}
	});

	$('#fecha').blur(function() {
		var Xfecha= $('#fecha').val();
		if(Xfecha == '1900-01-01'){
			alert("Dede de indicar una Fecha no Vacia");
			$('#fecha').val(parametroBean.fechaSucursal);
		}else{
			if(esFechaValida(Xfecha)){
				if(Xfecha=='')$('#fecha').val(parametroBean.fechaSucursal);
				var Yfecha= parametroBean.fechaSucursal;
				if ( mayor(Xfecha, Yfecha) )
				{
					alert("La Fecha es Mayor a la Fecha del Sistema.")	;
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
	
	/* Consulta para obtener la Ultima Fecha de Generacion Saldos  */
	function consultaFechaSaldosExcel(varFecha, tipoConsulta, version){
		setTimeout("$('#cajaLista').hide();", 200);		
		var tipoReporte = 3;
		var tipoLista = 1;
		if(varFecha != '' && varFecha != fechaVacia){			
			var creditoBeanCon = { 
					'fechaCorte':varFecha
			};
			creditosServicio.consulta(tipoConsulta, creditoBeanCon,function(credito) {
				if(credito!=null){
					esTab=true;
					if(credito.fechaCorte != varFecha){
						
						if (credito.fechaCorte == fechaVacia || credito.fechaCorte == ''){ 
							alert('No existe Información para Generar el Reporte');
							$('#fecha').focus();
						}else{ 
							alert("No se encontró información para la fecha: "+varFecha+
									"\nLa última fecha con información es: "+ credito.fechaCorte);
							$('#fecha').val(credito.fechaCorte);
							$('#fecha').focus();
						}
					}else{
						pagina='RepDesagregadoC0451.htm?fecha='+credito.fechaCorte+'&tipoReporte='+tipoReporte+ '&tipoLista='+tipoLista+ '&version='+ version;
						window.location=pagina;
					}
				}
			});
		}
	}
	
	/* Consulta para obtener la Ultima Fecha de Generacion Saldos  */
	function consultaFechaSaldosCSV(varFecha, tipoConsulta, version){
		var tipoReporte = 4;
		var tipoLista = 2;
		
		setTimeout("$('#cajaLista').hide();", 200);	
		
		if(varFecha != '' && varFecha != fechaVacia){			
			var creditoBeanCon = { 
					'fechaCorte':varFecha
			};
			creditosServicio.consulta(tipoConsulta, creditoBeanCon,function(credito) {
				if(credito!=null){
					esTab=true;
					if(credito.fechaCorte != varFecha){
						
						if (credito.fechaCorte == fechaVacia || credito.fechaCorte == ''){ 
							alert('No existe Información para Generar el Reporte');
							$('#fecha').focus();
						}else{ 
							alert("No se encontró información para la fecha: "+varFecha+
									"\nLa última fecha con información es: "+ credito.fechaCorte);
							$('#fecha').val(credito.fechaCorte);
							$('#fecha').focus();
						}
					}else{
						pagina='RepDesagregadoC0451.htm?fecha='+credito.fechaCorte+'&tipoReporte='+tipoReporte+ '&tipoLista='+tipoLista +'&version=' +version;
						window.location=pagina;
					}
				}
			});
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
	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha!= "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("formato de fecha no válido (aaaa-mm-dd)");
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
				alert("Fecha introducida errónea  ");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea  ");
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
