$(document).ready(function(){
	esTab = false;
	var parametroBean = consultaParametrosSession();

	$(':text').focus(function() {
		esTab = false;
	});

	$('#fechaCorte').val(parametroBean.fechaSucursal);
	$('#saldoMinimo').val(0.0);
	$('#tipoRep').focus();

	agregaFormatoControles('formaGenerica');
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#formaGenerica').validate({
		rules:{
			tipoRep:{
				required : true
			},
			fechaCorte:{
				required: true
			},
			saldoMinimo:{
				required: true
			}
		},
		messages:{
			tipoRep:{
				required: 'Especifique un Tipo de Reporte'
			},
			fechaCorte:{
				required: 'Especifique una Fecha de Corte'
			},
			saldoMinimo:{
				required:'Indique el Saldo Mínimo'
			}
		}
		
	});

	$('#genera').click(function() { 
		if($('#fechaCorte').val()==''){
			mensajeSis("Seleccione una Fecha de Corte");
			$('#fechaCorte').focus();
		}else{
			if($('#saldoMinimo').val()==''){
				mensajeSis("El Saldo Mínimo está vacío");
				$('#saldoMinimo').focus();	
			}else{
				if($('#tipoRep').val()==0){
					mensajeSis("Seleccione un Tipo de Reporte");
					$('#tipoRep').focus();	
				}else{
					if($('#pdf').is(":checked") ){
						generaPDF();
					}
					if($('#excel').is(":checked") ){
						generaExcel();
					}
			}	}
		}	
	});

	$('#tipoRep').change(function(){
		ocultaCartera();
		$('#fechaCorte').val(parametroBean.fechaSucursal);		
	});

	$('#pdf').click(function() {
		$('#excel').attr("checked",false); 
	});
	$('#excel').click(function() {
		$('#pdf').attr("checked",false); 
	});

	$('#detallado').click(function() {
		$('#sumarizado').attr("checked",false); 
		$('#detReporte').val('D');
	});
	$('#sumarizado').click(function() {
		$('#detallado').attr("checked",false); 
		$('#detReporte').val('G');
	});
	$('#incluirGL').click(function() {
		$('#incluirGLN').attr("checked",false); 
		$('#incluirGL').val('S');

	});
	$('#incluirGLN').click(function() {
		$('#incluirGL').attr("checked",false); 
		$('#incluirGL').val('N');
	});

	$('#incluirCuentaSAN').click(function() {
		$('#incluirCuentaSA').attr("checked",false); 
		$('#incluirCuentaSA').val('N');

	});
	$('#incluirCuentaSA').click(function() {
		$('#incluirCuentaSAN').attr("checked",false); 
		$('#incluirCuentaSA').val('S');
	});
	$('#fechaCorte').change(function(){
		var Xfecha= $('#fechaCorte').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if(Xfecha==''){
			$('#fechaCorte').val(parametroBean.fechaSucursal);
		}else{
				if(esFechaValida(Xfecha)){
				if (mayor(Xfecha, Yfecha)){
					mensajeSis("La Fecha Capturada es Mayor a la del Sistema");
					$('#fechaCorte').val(parametroBean.fechaSucursal);
					$('#fechaCorte').focus();
				}else{
					if(esTab==false){
						$('#fechaCorte').focus();
					}
				}
				}else{
					$('#fechaCorte').val(parametroBean.fechaSucursal);
					$('#fechaCorte').focus();
				}
		}
	});
	
	$('#fechaCorte').blur(function(){		
		var Xfecha= $('#fechaCorte').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if (esTab == true) {
			if(esFechaValida(Xfecha)){					
				if ( mayor(Xfecha, Yfecha) ){
					mensajeSis("La Fecha Capturada es Mayor a la del Sistema");
					$('#fechaCorte').val(parametroBean.fechaSucursal);
					$('#fechaCorte').focus();
				}
			}else{
				$('#fechaCorte').val(parametroBean.fechaSucursal);
				$('#fechaCorte').focus();
			}
		}
	});

	function generaPDF() {	
		if($('#pdf').is(':checked')){	

			if($('#detallado').is(':checked')){
				$('#detReporte').val('D');
			}else if($('#sumarizado').is(':checked')){
				$('#detReporte').val('G');
			}
			$('#excel').attr("checked",false);
			
			controlQuitaFormatoMoneda('saldoMinimo'); 
			var fechaCorte    		= $('#fechaCorte').val();	
			var incluirGL  			= $('#incluirGL').val();	 
			var saldoMinimo    		= $('#saldoMinimo').val();
			var incluirCuentaSA  	= $('#incluirCuentaSA').val();	
			var detReporte    		= $('#detReporte').val();	
			var tipoRep 			= $('#tipoRep').val();							
			var usuario      		= parametroBean.claveUsuario;
			var horaEmision  	    = hora();
			var nombreInstitucion 	=  parametroBean.nombreInstitucion;
			var fechaEmision 		= parametroBean.fechaSucursal; 

			if($('#tipoRep').val()==1 && $('#detallado').is(':checked')) {	 		
				var tipoReporte  		= 1; 
			}else if($('#tipoRep').val()==1 && $('#sumarizado').is(':checked')){
				var tipoReporte  		= 2;
			}else if($('#tipoRep').val()==2 && $('#detallado').is(':checked')){
				var tipoReporte  		= 3;
			}else if($('#tipoRep').val()==2 && $('#sumarizado').is(':checked')){
				var tipoReporte  		= 4;
			}

			var pagina='reporteEstadistico.htm?'+'tipoReporte='+tipoReporte+'&fechaCorte='+fechaCorte+'&incluirGL='+incluirGL+'&fechaEmision='+fechaEmision+
					'&saldoMinimo='+saldoMinimo+'&incluirCuentaSA='+incluirCuentaSA+'&detReporte='+detReporte+'&tipoRep='+tipoRep+
					'&horaEmision='+horaEmision+'&nombreInstitucion='+nombreInstitucion+'&claveUsuario='+usuario+'&tipoReporte='+tipoReporte;
				window.open(pagina);
			agregaFormatoMoneda('formaGenerica');
		}	
	}


	function generaExcel() {

		if($('#detallado').is(':checked')){
				$('#detReporte').val('D');
			}else if($('#sumarizado').is(':checked')){
				$('#detReporte').val('G');
			}

		$('#pdf').attr("checked",false) ;
		if($('#excel').is(':checked')){	
			
			controlQuitaFormatoMoneda('saldoMinimo');
			var fechaCorte    		= $('#fechaCorte').val();	
			var incluirGL  			= $('#incluirGL').val();	 
			var saldoMinimo    		= $('#saldoMinimo').val();
			var incluirCuentaSA  	= $('#incluirCuentaSA').val();	
			var detReporte    		= $('#detReporte').val();	
			var tipoRep 			= $('#tipoRep').val();														
			var usuario      		= parametroBean.claveUsuario;
			var horaEmision  	    = hora();
			var nombreInstitucion 	=  parametroBean.nombreInstitucion; 
			var fechaEmision 		= parametroBean.fechaSucursal;


			if($('#tipoRep').val()==1 && $('#detallado').is(':checked')) {	 		
				var tipoReporte  		= 5; 
			}else if($('#tipoRep').val()==1 && $('#sumarizado').is(':checked')){
				var tipoReporte  		= 6;
			}else if($('#tipoRep').val()==2 && $('#detallado').is(':checked')){
				var tipoReporte  		= 7;
			}else if($('#tipoRep').val()==2 && $('#sumarizado').is(':checked')){
				var tipoReporte  		= 8;
			}

		var pagina='reporteEstadistico.htm?'+'tipoReporte='+tipoReporte+'&fechaCorte='+fechaCorte+'&incluirGL='+incluirGL+'&fechaEmision='+fechaEmision+
				'&saldoMinimo='+saldoMinimo+'&incluirCuentaSA='+incluirCuentaSA+'&detReporte='+detReporte+'&tipoRep='+tipoRep+
				'&horaEmision='+horaEmision+'&nombreInstitucion='+nombreInstitucion+'&claveUsuario='+usuario+'&tipoReporte='+tipoReporte;
			window.open(pagina);

		agregaFormatoMoneda('formaGenerica');

		}
		
	}

	function ocultaCartera(){
		if($('#tipoRep').val()==1){
			$('#incluyeGL').hide();
			$('#saldo').hide();
			$('#incluyeCuentas').hide();

		}else if($('#tipoRep').val()==2 || $('#tipoRep').val()==0){
			$('#incluyeGL').show();
			$('#saldo').show();
			$('#incluyeCuentas').show();
		}
	}


	// FUNCION QUE REGRESA LA HORA 
	function hora(){	
		 var Digital=new Date();
		 var hours=Digital.getHours();
		 var minutes=Digital.getMinutes();
		 var seconds=Digital.getSeconds();
		 if (minutes<=9)
		 minutes="0"+minutes;
		 if (seconds<=9)
		 seconds="0"+seconds;
		return  hours+":"+minutes;
	 }
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
				mensajeSis("Fecha Introducida Errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha Introducida Errónea.");
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
	function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
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
		
});

