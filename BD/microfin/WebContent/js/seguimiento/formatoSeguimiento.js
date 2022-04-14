$(document).ready(function(){
	
	var parametroBean = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');
	
	var catTipoReporte = {
		'PDF' : '1'	
	};
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$(':text').focus(function() {
		esTab = false; 
	});
	
	comboCategorias();
	comboSucursal();
	comboGestor();
	
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	
	//-----------------------Métodovalidas y manejo de eventos-----------------------
	
	//Obtiene y valida la fecha de inicio
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		$('#fechaInicio').focus();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) ){
					alert("La Fecha de Inicio no debe ser mayor a la Fecha Fin.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
					$('#fechaInicio').focus();
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#fechaInicio').focus();
		}
	});
	
	
	//Obtiene y valida la fecha final
	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		$('#fechaFin').focus();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha Fin no debe ser menor a la Fecha Inicio.");
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
			$('#fechaFin').focus();
		}
	});


	function comboCategorias(){
		var numConsulta = 3;
		dwr.util.removeAllOptions('categoriaID');
		dwr.util.addOptions('categoriaID', {'':'SELECCIONA'});

		catSegtoCategoriasServicio.listaCombo(numConsulta, function(categoria){
			dwr.util.addOptions('categoriaID', categoria, 'categoriaID', 'descripcion');
		}); 
	}
	
	function comboSucursal(){
		var numConsulta = 2;
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions('sucursalID', {'':'SELECCIONA'});

		sucursalesServicio.listaCombo(numConsulta, function(categoria){
			dwr.util.addOptions('sucursalID', categoria, 'sucursalID', 'nombreSucurs');
		});
	}

	function comboGestor(){
		var numConsulta = 6;
		dwr.util.removeAllOptions('gestorID');
		dwr.util.addOptions('gestorID', {'':'SELECCIONA'});

		usuarioServicio.listaCombo(numConsulta, function(categoria){
			dwr.util.addOptions('gestorID', categoria, 'usuarioID', 'nombreCompleto');
		});
	}
	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {			
			fechaInicio: {
				required: true,
			},
			fechaFin:{
				required: true,
			}
		},		
		messages: {
			fechaInicio: {
				required: 'Especifique Fecha Inicio'

			},
			fechaFin:{
				required: 'Especifique Fecha Fin'
			}
		}
	});
	

	//funcion para generar el reporte en PDF
	$('#generar').click(function() {
			var tipoReporte = catTipoReporte.PDF;
			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaFin').val();
			var categoria = $('#categoriaID').val();
			var sucursal = $('#sucursalID').val();
			var gestor = $('#gestorID').val();
			var categoriaDesc = $('#categoriaID option:selected').html();
			var sucursalDesc= $('#sucursalID option:selected').html(); 
			var gestorDesc= $('#gestorID option:selected').html();
			var nomInstitucion = parametroBean.nombreInstitucion;
			var fechaEmision = parametroBean.fechaSucursal;
			var nomUsuario = parametroBean.claveUsuario;
			 
			$('#ligaGenerar').attr('href','formatoSeguimientoRep.htm?fechaInicio='+fechaInicio+'&fechaFin='+fechaFin
					  +'&categoriaID='+categoria+'&sucursalID='+sucursal+'&gestorID='+gestor+'&nomInstitucion='+nomInstitucion
					  +'&fechaEmision='+fechaEmision+'&nomUsuario='+nomUsuario.toUpperCase()+'&tipoReporte='+tipoReporte+'&categoriaDesc='+categoriaDesc
					  +'&sucursalDesc='+sucursalDesc+'&gestorDesc='+gestorDesc);
			});	

	
	//funcion para validar las fechas
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
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("Formato de Fecha no Válida (aaaa-mm-dd)");
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
});


	