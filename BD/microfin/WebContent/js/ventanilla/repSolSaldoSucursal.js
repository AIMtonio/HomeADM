$(document).ready(function(){
	var tipoReporte =2;
	var nombreInstitucion='TODAS';
	var parametros = consultaParametrosSession();
	var sucursalID="";
	var nombreSucursal="";


	consultaSucursal();
	inicializaCampos();
	habilitaBoton('generarArchivo', 'submit');
	agregaFormatoControles('formaGenerica');
	
	$('#fechaIni').focus();
	

	
	$('#sucursalID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalID', '2', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});

	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	});

	
	
	
	$('#generar').click(function() {	
		
			generaReporte();
		
	}); 
	
		
	$('#fechaIni').change(function() {
		var Xfecha= $('#fechaIni').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaIni').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaIni').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaIni').val(parametroBean.fechaSucursal);
		}
	});

	// se valida que la fecha de carga no sea superior a la fecha del sistema
	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaIni').val();
		var Yfecha= $('#fechaFin').val();
		var Sfecha =parametroBean.fechaSucursal;
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			
			if ( mayor(Yfecha, Sfecha) )
			{
				alert("La Fecha Final es Mayor a la Fecha del Sistema")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			
			
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
	});


		
						
	function generaReporte(){
		
		 var horaEmision=hora();
			
		if($('#pdf').is(":checked") ){
			tipoReporte= 2; 
		}
		if($('#excel').is(":checked") ){
			tipoReporte= 1; 
		}
		
		url ='reporteSolSaldoSucursal.htm?'
			+'fechaIni=' +$('#fechaIni').val()
			+'&fechaFin='+$('#fechaFin').val()
			+'&sucursalID='+$('#sucursalID').val()
			+'&NombreSucursal='+$('#sucursalDes').val()
			+'&NombreInstitucion='+parametros.nombreInstitucion
			+'&NombreUsuario='	+parametros.claveUsuario
			+'&FechaReporte='	+parametros.fechaSucursal
			+'&HoraEmision='	+horaEmision
			+'&tipoReporte='+tipoReporte
			+'&tipoLista=1';
			   window.open(url);
	}

	function inicializaCampos(){
		$('#fechaIni').val(parametros.fechaSucursal);
		$('#fechaFin').val(parametros.fechaSucursal);
		$('#sucursalID').val('0');
		$('#sucursalDes').val('TODAS');
	}


		
	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal) && numSucursal != 0) {
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#sucursalDes').val(sucursal.nombreSucurs);
				} else {
					alert("No Existe la Sucursal");
					$('#sucursalID').val('0');
					$('#sucursalDes').val('TODAS');
					$('#sucursalID').focus();
				}
			});
		}else{
			$('#sucursalID').val('0');
			$('#sucursalDes').val('TODAS');
		}
	}
	
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
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
	
	function hora(){
		 var Digital=new Date();
		 var hours=Digital.getHours();
		 var minutes=Digital.getMinutes();
		 var seconds=Digital.getSeconds();
		
		 if (minutes<=9)
			 minutes="0"+minutes;
		 if (seconds<=9)
			 seconds="0"+seconds;
		return  hours+":"+minutes+":"+seconds;
	 }
	      

});
