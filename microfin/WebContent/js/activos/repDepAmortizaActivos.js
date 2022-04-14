var parametroBean = consultaParametrosSession();

$(document).ready(function() {
	esTab = false;

    /**
     * Lista de Depreciacio y AMortizacion de Activos
     */
	var catTipoLisDepAmortizaActivos = {
		'reporteContable'	: 1,
		'reporteFiscal' 	: 2,
		'reporteAmbos'	 	: 3
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
	 * Fecha Inicio Depreciacion y Amortizacion de Activos
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
	 * Fecha Final Depreciacion y Amortizacion de Activos
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
	 * Funcion para Generar el Reporte de Depreciacion y Amortizacion de Activos en Excel
	 */
	function generaExcel(){

		var fechaEmision = parametroBean.fechaSucursal;
		var fecha = new Date();

		var segundos  = fecha.getSeconds();
		var minutos = fecha.getMinutes();
		var horas = fecha.getHours();

		if(fecha.getHours()<10){
			horas = "0"+fecha.getHours();
		}
		if(fecha.getMinutes()<10){
			minutos = "0"+fecha.getMinutes();
		}
		if(fecha.getSeconds()<10){
			segundos = "0"+fecha.getSeconds();
		}

		var horaEmision = horas+":"+minutos+":"+segundos;
		var tipoReporte 	= 0;
		var tipoLista   	= 0;
		var fechaInicio 	= $('#fechaInicio').val();
		var fechaFin 		= $('#fechaFin').val();
		var centroCosto 	= $('#centroCosto').val();
		var tipoActivo 		= $('#tipoActivo').val();
		var clasificacion 	= $('#clasificacion').val();
		var estatus 		= $("#estatus").val();


		var nombreInstitucion 	= parametroBean.nombreInstitucion;
		var claveUsuario		= parametroBean.claveUsuario;
		var fechaSistema 		= parametroBean.fechaSucursal;

		// Valores de Texto
		var descCentroCosto 	= $('#centroCosto').val()+ ' - ' + $('#descCentroCosto').val();
		var descTipoActivo 		= $('#tipoActivo').val() + ' - ' + $('#descTipoActivo').val();
		var descClasificacion 	= $('#clasificacion').val() + ' - ' + $('#clasificacion option:selected').text();
		var descEstatus 		= $("#estatus").val() + ' - '+ $("#estatus option:selected").text();

		if( $('#centroCosto').val() == 0 || $('#centroCosto').val() == '0' ){
			descCentroCosto = $('#descCentroCosto').val();
		}

		if($("#tipoActivo").val() == 0 || $('#tipoActivo').val() == '0' ){
			descTipoActivo = $('#descTipoActivo').val();
		}

		if( $('#clasificacion').val() == ''){
			descClasificacion = $("#clasificacion option:selected").text();
		}

		if($("#estatus").val() == ''){
			descEstatus = $("#estatus option:selected").text();
		}

		if($('#reporteContable').is(':checked')){

			tipoReporte = catTipoLisDepAmortizaActivos.reporteContable;
			tipoLista = catTipoLisDepAmortizaActivos.reporteContable;

			var pagina ='reporteDepnAmort.htm?fechaInicio='+fechaInicio+'&fechaFin='+fechaFin
									+ '&centroCosto='+centroCosto+'&tipoActivo='+tipoActivo+ '&clasificacion='+clasificacion
									+ '&estatus='+estatus+'&descCentroCosto='+descCentroCosto
									+ '&descTipoActivo='+descTipoActivo+'&descClasificacion='+descClasificacion
									+ '&descEstatus='+descEstatus+'&nombreInstitucion='+nombreInstitucion
									+ '&claveUsuario='+claveUsuario.toUpperCase()+'&tipoReporte='+tipoReporte
									+ '&tipoLista='+tipoLista+'&fechaSistema='+fechaSistema
									+ '&fechaEmision='+fechaEmision
									+ '&horaEmision='+horaEmision;
			window.open(pagina);

		}else if($('#reporteFiscal').is(':checked')){

			tipoReporte = catTipoLisDepAmortizaActivos.reporteFiscal;
			tipoLista = catTipoLisDepAmortizaActivos.reporteFiscal;

			var pagina ='reporteDepnAmort.htm?fechaInicio='+fechaInicio+'&fechaFin='+fechaFin
									+ '&centroCosto='+centroCosto+'&tipoActivo='+tipoActivo+ '&clasificacion='+clasificacion
									+ '&estatus='+estatus+'&descCentroCosto='+descCentroCosto
									+ '&descTipoActivo='+descTipoActivo+'&descClasificacion='+descClasificacion
									+ '&descEstatus='+descEstatus+'&nombreInstitucion='+nombreInstitucion
									+ '&claveUsuario='+claveUsuario.toUpperCase()+'&tipoReporte='+tipoReporte
									+ '&tipoLista='+tipoLista+'&fechaSistema='+fechaSistema
									+ '&fechaEmision='+fechaEmision
									+ '&horaEmision='+horaEmision;
			window.open(pagina);
		}else if($('#reporteAmbos').is(':checked')){

			tipoReporte = catTipoLisDepAmortizaActivos.reporteAmbos;
			tipoLista = catTipoLisDepAmortizaActivos.reporteAmbos;

			var pagina ='reporteDepnAmort.htm?fechaInicio='+fechaInicio+'&fechaFin='+fechaFin
									+ '&centroCosto='+centroCosto+'&tipoActivo='+tipoActivo+ '&clasificacion='+clasificacion
									+ '&estatus='+estatus+'&descCentroCosto='+descCentroCosto
									+ '&descTipoActivo='+descTipoActivo+'&descClasificacion='+descClasificacion
									+ '&descEstatus='+descEstatus+'&nombreInstitucion='+nombreInstitucion
									+ '&claveUsuario='+claveUsuario.toUpperCase()+'&tipoReporte='+tipoReporte
									+ '&tipoLista='+tipoLista+'&fechaSistema='+fechaSistema
									+ '&fechaEmision='+fechaEmision
									+ '&horaEmision='+horaEmision;
			window.open(pagina);
		}
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
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
	dwr.util.removeAllOptions('clasificacion');
	tiposActivosServicio.listaCombo(1, function(beanLista){
		dwr.util.addOptions('clasificacion', {'':'TODAS'});
		dwr.util.addOptions('clasificacion', beanLista, 'clasificaActivoID', 'descripcion');
	});
}
