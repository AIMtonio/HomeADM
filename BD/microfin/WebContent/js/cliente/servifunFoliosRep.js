$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();   

	var catTipoLisServifunFoliosRep  = {
			'servifunFoliosRep'	: 1
	};	

	var catTipoServifunFoliosRep = { 
			'PDF'		: 1,
			'Excel'		: 2 
	};	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	
	consultaSucursal();		
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	
	
	$('#pdf').attr("checked",true) ;
	$(':text').focus(function() {	
		esTab = false;
	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) ){
				if($('#fechaFin').val() !=''){
					alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
				
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

	});

	$('#generar').click(function() { 
		if($('#pdf').is(":checked") ){
			generaPDF();
		}
		if($('#excel').is(":checked") ){
			generaExcel();
		}
	});
	
	$('#formaGenerica').validate({
		rules: {
			fechaInicio :{
				required: true,
			},
			fechaFin :{
				required: true
			}
		},
		
		messages: {
			fechaInicio :{
				required: 'Ingrese la Fecha de Inicio',
			}
			,fechaFin :{
				required: 'Ingrese la Fecha Final'
			}
		}
	});


	
	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'TODAS'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	
	function generaExcel() {
		$('#pdf').attr("checked",false) ;		
		if($('#excel').is(':checked')){	
			var tr= catTipoServifunFoliosRep.Excel; 
			var tl= catTipoLisServifunFoliosRep.servifunFoliosRep;  
			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFin = $('#fechaFin').val();	
			var sucursal = $("#sucursalID option:selected").val();			
			var usuario = 	parametroBean.claveUsuario;			
			var fechaEmision = parametroBean.fechaSucursal;	
			
			/// VALORES TEXTO
			var nombreSucursal = $("#sucursalID option:selected").val();
			var nombreEstatus = $("#estatus option:selected").val();
			
			var nombreUsuario = parametroBean.nombreUsuario; 			
			var nombreInstitucion =  parametroBean.nombreInstitucion; 		
			
			if(nombreSucursal == '0'){
				nombreSucursal = '';
			}else{
				nombreSucursal = $("#sucursalID option:selected").html();
			}


			$('#ligaGenerar').attr('href','reporteServifunFolios.htm?fechaInicio='+fechaInicio+'&fechaFin='+
					fechaFin+'&fechaEmision='+fechaEmision+'&sucursalID='+sucursal+'&claveUsuario='+usuario+'&tipoReporte='+tr+
					'&nombreSucursal='+nombreSucursal+'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion+'&tipoLista='+tl+'&estatus='+nombreEstatus	
			);

		}
	}

	function generaPDF() {	
		if($('#pdf').is(':checked')){	 
			$('#excel').attr("checked",false); 
			
			var tr= catTipoServifunFoliosRep.PDF; 
			var tl= catTipoLisServifunFoliosRep.servifunFoliosRep;  
			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFin = $('#fechaFin').val();	
			var sucursal = $("#sucursalID option:selected").val();
			
			var usuario = 	parametroBean.claveUsuario;
			
			var fechaEmision = parametroBean.fechaSucursal;
		
			
			/// VALORES TEXTO
			var nombreSucursal = $("#sucursalID option:selected").val();
			var nombreEstatus = $("#estatus option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario; 			
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			
			if(nombreSucursal=='0'){
				nombreSucursal='';
			}else{
				nombreSucursal = $("#sucursalID option:selected").html();
			}
			
			$('#ligaGenerar').attr('href','reporteServifunFolios.htm?fechaInicio='+fechaInicio+'&fechaFin='+
					fechaFin+'&fechaEmision='+fechaEmision+'&sucursalID='+sucursal+'&claveUsuario='+usuario+'&tipoReporte='+tr+
					'&nombreSucursal='+nombreSucursal+'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion+'&tipoLista='+tl+'&estatus='+nombreEstatus	
			);

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
//	FIN VALIDACIONES DE REPORTES

	/*funcion valida fecha formato (yyyy-MM-dd)*/
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
	/***********************************/


});
