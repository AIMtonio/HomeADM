$(document).ready(function(){
	
	var parametroBean = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');
	
	var catTipoReporte = {
		'PDF' : '1'	,	
		'Excel'	: '2'
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
	comboPlazas();
	comboSucursal();
	comboProdCredito();
	comboGestor();
	comboTipoGestion();
	comboSupervisor();
	comboResultados();
	comboRecomendacion();
	
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	
	$('#fechaInicioSeg').val(parametroBean.fechaSucursal);
	$('#fechaFinSeg').val(parametroBean.fechaSucursal);
	
	$('#pdf').attr("checked",true) ; 
	$('#detallado').attr("checked",true) ; 
	
	$('#selecProgramada').attr("checked",true) ; 
	$('#programada').val('S');
	$('#seguimiento').val('N');
	
	$('#excel').click(function() {
		if($('#excel').is(':checked')){	
			$('#tdPresentacion').show('slow');
		}
	});

	$('#pdf').click(function() {
		if($('#pdf').is(':checked')){	
			$('#tdPresentacion').show('slow');
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
	
	$('#selecProgramada').click(function(){
		if ($('#selecProgramada').is(':checked',true)){
			$('#programada').val('S');
		}
		else{
			$('#selecProgramada').attr('checked',false);
			$('#programada').val('N');
 	}
	});
	
	$('#selecSeguimiento').click(function(){
		if ($('#selecSeguimiento').is(':checked',true)){
			$('#seguimiento').val('S');
		}
		else{
			$('#selecSeguimiento').attr('checked',false);
			$('#seguimiento').val('N');
 	}
	});
	
	//-----------------------Métodovalidas y manejo de eventos-----------------------
	
	//Obtiene y valida la fecha de inicio de programacion de seguimiento
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
	
	
	//Obtiene y valida la fecha final de programacion de seguimiento
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

	//Obtiene y valida la fecha de inicio de ejecucion de seguimiento
	$('#fechaInicioSeg').change(function() {
		var Xfecha= $('#fechaInicioSeg').val();
		$('#fechaInicioSeg').focus();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicioSeg').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFinSeg').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) ){
					alert("La Fecha de Inicio no debe ser mayor a la Fecha Fin.");
					$('#fechaInicioSeg').val(parametroBean.fechaSucursal);
					$('#fechaInicioSeg').focus();
				}
			}
		}else{
			$('#fechaInicioSeg').val(parametroBean.fechaSucursal);
			$('#fechaInicioSeg').focus();
		}
	});
	
	
	//Obtiene y valida la fecha final de ejecucion de seguimiento
	$('#fechaFinSeg').change(function() {
		var Xfecha= $('#fechaInicioSeg').val();
		var Yfecha= $('#fechaFinSeg').val();
		$('#fechaFinSeg').focus();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFinSeg').val(parametroBean.fechaSucursal);
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha Fin no debe ser menor a la Fecha Inicio.");
				$('#fechaFinSeg').val(parametroBean.fechaSucursal);
				$('#fechaFinSeg').focus();
			}
		}else{
			$('#fechaFinSeg').val(parametroBean.fechaSucursal);
			$('#fechaFinSeg').focus();
		}
	});
	
	function comboCategorias(){
		var numConsulta = 4;
		dwr.util.removeAllOptions('categoriaID');
		dwr.util.addOptions('categoriaID', {'':'SELECCIONA'});

		catSegtoCategoriasServicio.listaCombo(numConsulta, function(categoria){
			dwr.util.addOptions('categoriaID', categoria, 'categoriaID', 'descripcion');
		});
	}
	
	function comboPlazas(){
		var numConsulta = 3;
		dwr.util.removeAllOptions('plazaID');
		dwr.util.addOptions('plazaID', {'':'SELECCIONA'});

		plazasServicio.listaConsulta(numConsulta, function(categoria){
			dwr.util.addOptions('plazaID', categoria, 'plazaID', 'nombre');
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

	function comboProdCredito(){
		var numConsulta = 2;
		dwr.util.removeAllOptions('prodCreditoID');
		dwr.util.addOptions('prodCreditoID', {'':'SELECCIONA'});

		productosCreditoServicio.listaCombo(numConsulta, function(producto){
			dwr.util.addOptions('prodCreditoID', producto, 'producCreditoID', 'descripcion');
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
	
	function comboTipoGestion(){
		var numConsulta = 2;
		dwr.util.removeAllOptions('tipoGestorID');
		dwr.util.addOptions('tipoGestorID', {'':'SELECCIONA'});

		catTiposGestionServicio.listaCombo(numConsulta, function(categoria){
			dwr.util.addOptions('tipoGestorID', categoria, 'tipoGestionID', 'descripcion');
		});
	}
	
	function comboSupervisor(){
		var numConsulta = 7;
		dwr.util.removeAllOptions('supervisorID');
		dwr.util.addOptions('supervisorID', {'':'SELECCIONA'});

		usuarioServicio.listaCombo(numConsulta, function(categoria){
			dwr.util.addOptions('supervisorID', categoria, 'usuarioID', 'nombreCompleto');
		});
	}

	function comboResultados(){
		var numConsulta = 1;
		var resultBean = {
				'descripcion' : '',
				'alcance'     : '',
				'estatus'     : ''
		};
		dwr.util.removeAllOptions('resultadoID');
		dwr.util.addOptions('resultadoID', {'':'SELECCIONA'});

		segtoResultadosServicio.listaCombo(resultBean, numConsulta, function(resultado){
			dwr.util.addOptions('resultadoID', resultado, 'resultadoSegtoID', 'descripcion');
		});
	}
	
	function comboRecomendacion(){
		var numConsulta = 1;
		var recomBean = {
				'descripcion' : '',
				'alcance'     : '',
				'estatus'     : ''
		};
		dwr.util.removeAllOptions('recomendacionID');
		dwr.util.addOptions('recomendacionID', {'':'SELECCIONA'});

		segtoRecomendasServicio.listaCombo(recomBean, numConsulta, function(categoria){
			dwr.util.addOptions('recomendacionID', categoria, 'recomendacionSegtoID', 'descripcion');
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

	function generaExcel() {
		$('#pdf').attr("checked",false) ;
		if($('#excel').is(':checked')){	
			var tipoReporte = catTipoReporte.Excel; 
	
			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaFin').val();
			var fechaInicioSeg = $('#fechaInicioSeg').val();
			var fechaFinSeg = $('#fechaFinSeg').val();
			var categoria = $('#categoriaID').val();
			var plaza = $('#plazaID').val();
			var sucursal = $('#sucursalID').val();
			var prodCred = $('#prodCreditoID').val();
			var gestor = $('#gestorID').val();
			var tipoGestor = $('#tipoGestorID').val();
			var supervisor = $('#supervisorID').val();
			var resultado = $('#resultadoID').val();
			var recomendacion = $('#recomendacionID').val();
			var categoriaDesc = $('#categoriaID option:selected').html();
			var plazaDesc = $('#plazaID option:selected').html();
			var sucursalDesc= $('#sucursalID option:selected').html(); 
			var prodCreditoDesc= $('#prodCreditoID option:selected').html();
			var gestorDesc= $('#gestorID option:selected').html();
			var tipoGestorDesc= $('#tipoGestorID option:selected').html();
			var supervisorDesc= $('#supervisorID option:selected').html();
			var resultadoDesc= $('#resultadoID option:selected').html();
			var recomendaDesc= $('#recomendacionID option:selected').html();
			var nomInstitucion = parametroBean.nombreInstitucion;
			var fechaEmision = parametroBean.fechaSucursal;
			var nomUsuario = parametroBean.nombreUsuario;
			var programada = $('#programada').val();
			var seguimiento = $('#seguimiento').val();
			
			var municipio = 0;		
			if (fechaInicio == '') {
				alert("Especifique la Fecha de Inicio");
				$('#fechaInicio').focus();	
				return false;
			}else if (fechaFin == '') {
				alert("Especifique la Fecha Fin");
				$('#fechaFin').focus();
				return false;			
			}
			var tipoLista = 1;  
			if($('#detallado').is(':checked'))	{
				tipoLista = 1;
			}
			else 			
				if($('#sumarizado').is(':checked'))	{
					tipoLista = 2;
			}

			$('#ligaGenerar').attr('href','eficaciaSeguimientoRep.htm?fechaInicio='+fechaInicio+'&fechaFin='+fechaFin+'&fechaInicioSeg='+fechaInicioSeg
				  +'&fechaFinSeg='+fechaFinSeg+'&selecProgramada='+programada+'&selecSeguimiento='+seguimiento+'&categoriaID='+categoria+'&plazaID='+plaza
				  +'&sucursalID='+sucursal+'&prodCreditoID='+prodCred+'&ejecutorID='+gestor+'&tipoGestorID='+tipoGestor+'&supervisorID='+supervisor
				  +'&resultadoID='+resultado+'&recomendacionID='+recomendacion+'&municipioID='+municipio+'&nomInstitucion='+nomInstitucion
				  +'&fechaEmision='+fechaEmision+'&nomUsuario='+nomUsuario+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+'&categoriaDesc='+categoriaDesc
				  +'&plazaDesc='+plazaDesc+'&sucursalDesc='+sucursalDesc+'&prodCreditoDesc='+prodCreditoDesc+'&gestorDesc='+gestorDesc+
				  '&tipoGestorDesc='+tipoGestorDesc+'&supervisorDesc='+supervisorDesc+'&resultadoDesc='+resultadoDesc+'&recomendaDesc='+recomendaDesc);
				}
			}



	
	function generaPDF() {
		if($('#pdf').is(':checked')){	
			$('#excel').attr("checked",false); 
			var tipoReporte = catTipoReporte.PDF;
			
			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaFin').val();
			var fechaInicioSeg = $('#fechaInicioSeg').val();
			var fechaFinSeg = $('#fechaFinSeg').val();
			var categoria = $('#categoriaID').val();
			var plaza = $('#plazaID').val();
			var sucursal = $('#sucursalID').val();
			var prodCred = $('#prodCreditoID').val();
			var gestor = $('#gestorID').val();
			var tipoGestor = $('#tipoGestorID').val();
			var supervisor = $('#supervisorID').val();
			var resultado = $('#resultadoID').val();
			var recomendacion = $('#recomendacionID').val();
			var categoriaDesc = $('#categoriaID option:selected').html();
			var plazaDesc = $('#plazaID option:selected').html();
			var sucursalDesc= $('#sucursalID option:selected').html(); 
			var prodCreditoDesc= $('#prodCreditoID option:selected').html();
			var gestorDesc= $('#gestorID option:selected').html();
			var tipoGestorDesc= $('#tipoGestorID option:selected').html();
			var supervisorDesc= $('#supervisorID option:selected').html();
			var resultadoDesc= $('#resultadoID option:selected').html();
			var recomendaDesc= $('#recomendacionID option:selected').html();
			var nomInstitucion = parametroBean.nombreInstitucion;
			var fechaEmision = parametroBean.fechaSucursal;
			var nomUsuario = parametroBean.nombreUsuario;
			var programada = $('#programada').val();
			var seguimiento = $('#seguimiento').val();
			var municipio = 0;		
			if (fechaInicio == '') {
				alert("Especifique la Fecha de Inicio");
				$('#fechaInicio').focus();	
				return false;
			}else if (fechaFin == '') {
				alert("Especifique la Fecha Fin");
				$('#fechaFin').focus();
				return false;
			}
			var numeroReporte = 1;
			if($('#detallado').is(':checked')){
				numeroReporte = 1;
			}
			else 			
				if($('#sumarizado').is(':checked'))	{
					numeroReporte = 2;
			} 
			$('#ligaGenerar').attr('href','eficaciaSeguimientoRep.htm?fechaInicio='+fechaInicio+'&fechaFin='+fechaFin+'&fechaInicioSeg='+fechaInicioSeg
				  +'&fechaFinSeg='+fechaFinSeg+'&selecProgramada='+programada+'&selecSeguimiento='+seguimiento+'&categoriaID='+categoria+'&plazaID='+plaza
				  +'&sucursalID='+sucursal+'&prodCreditoID='+prodCred+'&ejecutorID='+gestor+'&tipoGestorID='+tipoGestor+'&supervisorID='+supervisor
				  +'&resultadoID='+resultado+'&recomendacionID='+recomendacion+'&municipioID='+municipio+'&nomInstitucion='+nomInstitucion
				  +'&fechaEmision='+fechaEmision+'&nomUsuario='+nomUsuario+'&tipoReporte='+tipoReporte+'&numeroReporte='+numeroReporte 
				  +'&categoriaDesc='+categoriaDesc+'&plazaDesc='+plazaDesc+'&sucursalDesc='+sucursalDesc+'&prodCreditoDesc='+prodCreditoDesc
				  +'&gestorDesc='+gestorDesc+'&tipoGestorDesc='+tipoGestorDesc+'&supervisorDesc='+supervisorDesc+'&resultadoDesc='+resultadoDesc
				  +'&recomendaDesc='+recomendaDesc);
				}
			}
	
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


	