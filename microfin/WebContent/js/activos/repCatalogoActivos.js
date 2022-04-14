$(document).ready(function() {
	esTab = false;

	/**
	 * Parametros de Sesion
	 */
	var parametroBean = consultaParametrosSession();

	/**
	 * Tipo de Reporte a Generar
	 */
    var catTipoCatalogoActivos = {
			'Excel'	: 1
	};

    /**
     * Lista de Catalogo de Activos
     */
	var catTipoLisCatalogoActivos = {
		'catalogoActivosExcel' : 1
	};

	/**
	 *  Metodos y Manejo de Eventos
	 */
	agregaFormatoControles('formaGenerica');

	funcionCargaComboClasificacion();
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#fechaInicio').focus();

	$('#excel').attr("checked",true) ;

	$(':text').focus(function() {
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	/**
	 * Reporte de Excel
	 */
	$('#excel').click(function() {
		if($('#excel').is(':checked')){
			$('#tdPresentacion').show('slow');
		}
	});

	/**
	 * Generar Reporte
	 */
	$('#generar').click(function() {
		if($('#excel').is(":checked") ){
			generaExcel();
		}
	});

	/**
	 * Fecha Inicio Catalogo Activos
	 */
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		$('#fechaInicio').focus();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if (mayor(Xfecha, Yfecha))
			{
				mensajeSis("La Fecha Inicio no debe ser mayor a la Fecha Fin.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#fechaInicio').focus();
		}
	});

	/**
	 * Fecha Final Catalogo Activos
	 */
	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		$('#fechaFin').focus();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);

			if (mayor(Yfecha, parametroBean.fechaSucursal)){
				mensajeSis("La Fecha Fin no debe ser mayor a la Fecha del Sistema.");
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}else{
				if (mayor(Xfecha, Yfecha))
				{
					mensajeSis("La Fecha Fin no debe ser menor a la Fecha Inicio.");
					$('#fechaFin').val(parametroBean.fechaSucursal);
					$('#fechaFin').focus();
				}
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
			$('#fechaFin').focus();
		}

	});

	$('#centroCosto').bind('keyup',function(e){
		lista('centroCosto', '2', '1', 'descripcion', $('#centroCosto').val(), 'listaCentroCostos.htm');
	});

	$('#centroCosto').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			funcionConsultaCentroCostos(this.id);
		}
	});

	$('#tipoActivo').bind('keyup', function(e){
		lista('tipoActivo', '2', '3', 'descripcion', $('#tipoActivo').val(),'listaTiposActivos.htm');
	});

	$('#tipoActivo').change(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			funcionConsultaTipoActivo(this.id);
		}
	});

	/**
	 * Validaciones
	 */
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

	/**
	 * Funcion para Generar el Reporte de Catalogo de Activos en Excel
	 */
	function generaExcel(){
			// Declaracion de variables
			var tipoReporte = catTipoCatalogoActivos.Excel;
			var tipoLista   = catTipoLisCatalogoActivos.catalogoActivosExcel;
			var fechaInicio = $('#fechaInicio').val();
			var fechaFin 	= $('#fechaFin').val();
			var centroCosto = $('#centroCosto').val();
			var tipoActivo 	= $('#tipoActivo').val();
			var clasificacion 	= $('#clasificaActivoID').val();
			var estatus 	= $("#estatus option:selected").val();


			var nombreInstitucion 	= parametroBean.nombreInstitucion;
			var claveUsuario		= parametroBean.claveUsuario;
			var fechaSistema 		= parametroBean.fechaSucursal;

			// Valores de Texto
			var descCentroCosto;
			if(centroCosto == 0){
				descCentroCosto = 'TODOS';
			}else{
				descCentroCosto = centroCosto + '-' + $('#descCentroCosto').val();
			}

			var descTipoActivo;
			if(tipoActivo == 0){
				descTipoActivo = 'TODOS';
			}else{
				descTipoActivo = tipoActivo + '-' + $('#descTipoActivo').val();
			}

			var descClasificacion;
			if(clasificacion == ""){
				descClasificacion = 'TODOS';
			}else{
				descClasificacion = clasificacion + '-' + $('#clasificaActivoID option:selected').text();
			}

			var descEstatus;
			if(estatus == ""){
				descEstatus = 'TODOS';
			}else{
				descEstatus = estatus + '-' + $("#estatus option:selected").text();
			}


			var pagina ='repCatalogoActivos.htm?fechaInicio='+fechaInicio+'&fechaFin='+fechaFin
									+ '&centroCosto='+centroCosto+'&tipoActivo='+tipoActivo+ '&clasificacion='+clasificacion
									+ '&estatus='+estatus+'&descCentroCosto='+descCentroCosto
									+ '&descTipoActivo='+descTipoActivo+'&descClasificacion='+descClasificacion
									+ '&descEstatus='+descEstatus+'&nombreInstitucion='+nombreInstitucion
									+'&claveUsuario='+claveUsuario.toUpperCase()+'&tipoReporte='+tipoReporte
									+ '&tipoLista='+tipoLista+'&fechaSistema='+fechaSistema;
		window.open(pagina);
	}


	/**
	 * Funcion para validar las fechas
	 */
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

	/**
	 * Funcion valida fecha formato (yyyy-MM-dd)
	 */
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de fecha no válido (aaaa-mm-dd).");
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;}
				break;
			default:
				mensajeSis("Fecha introducida errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea.");
				return false;
			}
			return true;
		}
	}

	/**
	 * Funcion para comprobar el año bisiesto
	 */
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}

	// FUNCION CONSULTA CENTRO DE COSTOS
	function funcionConsultaCentroCostos(idControl) {
		var jqNumCentroCosto = eval("'#" + idControl + "'");
		var numCentroCosto = $(jqNumCentroCosto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var numCon=1;
		var BeanCon = {
			'centroCostoID':numCentroCosto
		};

		if(numCentroCosto != '' && !isNaN(numCentroCosto) && numCentroCosto > 0){
			centroServicio.consulta(numCon,BeanCon,function(centro) {
				if(centro!=null){
					$('#descCentroCosto').val(centro.descripcion);
				}else{
					$(jqNumCentroCosto).val('0');
					$('#descCentroCosto').val('TODOS');
					$(jqNumCentroCosto).focus();
					mensajeSis('No Existe el Centro de Costos');}
			});
		}else{
			if(isNaN(numCentroCosto)){
				$(jqNumCentroCosto).val('0');
				$('#descCentroCosto').val('TODOS');
				$(jqNumCentroCosto).focus();
				mensajeSis('No Existe el Centro de Costos');
			}else{
				if(numCentroCosto == 0 || numCentroCosto == ''){
					$(jqNumCentroCosto).val('0');
					$('#descCentroCosto').val('TODOS');
				}
			}
		}
	}

	// FUNCION CONSULTAR TIPO DE ACTIVO
	function funcionConsultaTipoActivo(idControl){
		var jqNumero = eval("'#" + idControl + "'");
		var tipoActivoID = $(jqNumero).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var numCon=1;
		var BeanCon = {
			'tipoActivoID':tipoActivoID
		};

		if(tipoActivoID != '' && !isNaN(tipoActivoID) && tipoActivoID > 0){
			tiposActivosServicio.consulta(numCon,BeanCon,function(tipoActivoBean) {
				if(tipoActivoBean!=null){
					$('#descTipoActivo').val(tipoActivoBean.descripcionCorta);
				}else{
					$(jqNumero).val('0');
					$('#descTipoActivo').val('TODOS');
					$(jqNumero).focus();
					mensajeSis('No Existe el Tipo de Activo');
				}
			});
		}else{
			if(isNaN(tipoActivoID)){
				$(jqNumero).val('0');
				$('#descTipoActivo').val('TODOS');
				$(jqNumero).focus();
				mensajeSis('No Existe el Tipo de Activo');
			}else{
				if(tipoActivoID == '' || tipoActivoID == 0){
					$(jqNumero).val('0');
					$('#descTipoActivo').val('TODOS');
				}
			}
		}
	}

}); // fin ready


function funcionCargaComboClasificacion(){
	dwr.util.removeAllOptions('clasificaActivoID');
	tiposActivosServicio.listaCombo(1, function(beanLista){
		dwr.util.addOptions('clasificaActivoID', {'':'TODAS'});
		dwr.util.addOptions('clasificaActivoID', beanLista, 'clasificaActivoID', 'descripcion');
	});
}
