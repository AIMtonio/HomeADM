var catTipoTransaccionActivos = {
	'carga' : '1',
	'procesa' : '2'
};

// Definicion de Constantes y Enums

$(document).ready(function() {
	esTab = true;

	var parametroBean = consultaParametrosSession();

	$('#sucursalID').val(parametroBean.sucursal);
	$('#fechaRegistro').focus();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	habilitaBoton('adjuntar', 'submit');
	deshabilitaBoton('procesar', 'submit');
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('verBitacora', 'submit');
	deshabilitaBoton('ocultar', 'submit');
	deshabilitaBoton('consultar', 'submit');


	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','transaccionID', 'funcionExito','funcionError');
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#fechaRegistro').val(parametroBean.fechaSucursal);


	$('#adjuntar').click(function() {
		if($('#fechaRegistro').val() != ''){
			$('#tipoTransaccion').val(catTipoTransaccionActivos.carga);
			subirArchivosActivos();
		}
	});

	$('#procesar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionActivos.procesa);
	});



	$('#fechaRegistro').change(function() {
		var Xfecha= $('#fechaRegistro').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaRegistro').val(parametroBean.fechaSucursal);
			}
			if($('#fechaRegistro').val() > parametroBean.fechaSucursal) {
				mensajeSis("La Fecha Inicial es Mayor a la Fecha del Sistema.");
				$('#fechaRegistro').val(parametroBean.fechaSucursal);
			}

		}else{
			$('#fechaRegistro').val(parametroBean.fechaSucursal);
		}
	});

	//------------ Validaciones de Controles -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			fechaRegistro :{
				required: true
			}
		},

		messages: {
			fechaRegistro :{
				required: 'Ingrese la Fecha de Carga.'
			}
		}
	});

	// Subir archivos de Pagos de Nomina
	function subirArchivosActivos() {
		var Xfecha= $('#fechaRegistro').val();
		if(Xfecha == ''){
			mensajeSis("Especifique la Fecha de Registro");
			$('#fechaRegistro').focus();
			agregaFormatoControles('formaGenerica');
		}else{
			var url ="cargaActivosFileUpload.htm?fechaRegistro="+$('#fechaRegistro').val();
			var leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
			var topPosition = (screen.height) ? (screen.height-500)/2 : 0;
			ventanaArchivoActivos = window.open(url,
					"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no," +
					"addressbar=0,menubar=0,toolbar=0"+
					"left="+leftPosition+
					",top="+topPosition+
					",screenX="+leftPosition+
					",screenY="+topPosition);
			deshabilitaBoton('procesar', 'submit');

		}
	}

	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
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
					if (comprobarSiBisisesto(anio)){
						numDias=29;
					} else {
						numDias=28;
					};
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
});


function ayuda(){
	var data;
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
			'<div id="ContenedorAyuda">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Descripción de Layout:</legend>'+
			'<table id="tablaLista" border="0" cellpadding="0" cellspacing="0" width="100%">'+
				'<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Número:</b></td><td id="contenidoAyuda" align="left"><b>Indica el Número Interno Consecutivo del Activo.</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Tipo de Activo:</b></td><td id="contenidoAyuda" align="left"><b>Indica ID del Tipo de Activo.</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Descripción:</b></td><td id="contenidoAyuda" align="left"><b>Indica la Descripción del Activo.</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Tiempo Amort. (M):</b></td><td id="contenidoAyuda" align="left"><b>Indica el Tiempo de la Amortización.</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Fecha de Adquisición:</b></td><td id="contenidoAyuda" align="left"><b>Indica la Fecha de Adquisición del Activo.</b></td>'+
				'</tr>'+
                '<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>No. de Factura:</b></td><td id="contenidoAyuda" align="left"><b>Indica el Número de Factura (Opcional).</b></td>'+
				'</tr>'+
                '<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>No. de Serie:</b></td><td id="contenidoAyuda" align="left"><b>Indica el Número de Serie (Opcional).</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Monto Original Inversión:</b></td><td id="contenidoAyuda" align="left"><b>Indica el Monto de la Inversión.</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Depreciado Acumulado:</b></td><td id="contenidoAyuda" align="left"><b>Indica el Monto Depreciado Acumulado .</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Total por Depreciar:</b></td><td id="contenidoAyuda" align="left"><b>Indica el Monto Total por Depreciar.</b></td>'+
				'</tr>'+
				 '<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>% de Depreciación Fiscal de Tipo de Activo:</b></td><td id="contenidoAyuda" align="left"><b>Indica el Porcentaje de Depreciación que tendra tipo de Activo.</b></td>'+
				'</tr>'+
                '<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Póliza Factura:</b></td><td id="contenidoAyuda" align="left"><b>Indica el Número de Poliza de Factura.</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Centro de Costos:</b></td><td id="contenidoAyuda" align="left"><b>Indica el ID del Centro de Costos.</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Cuenta Contable Registros:</b></td><td id="contenidoAyuda" align="left"><b>Indica la Cuenta Contable a la que se va a afectar .</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Cuenta Contable Depreciación:</b></td><td id="contenidoAyuda" align="left"><b>Indica la Cuenta Contable a la que se va a afectar.</b></td>'+
				'</tr>'+
			'</table>'+
			'<br>'+
			'<div id="ContenedorAyuda">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Formato del Archivo Pagos de Crédito</legend>'+
			'<table border="1" id="tablaLista" width="100%">'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Número </b></td>'+
					'<td id="encabezadoAyuda"><b>Tipo de Activo </b></td>'+
					'<td id="encabezadoAyuda"><b>Descripción </b></td>'+
					'<td id="encabezadoAyuda"><b>Tiempo Amort. (M) </b></td>'+
					'<td id="encabezadoAyuda"><b>Fecha de Adquisición </b></td>'+

					'<td id="encabezadoAyuda"><b>No de Factura </b></td>'+
					'<td id="encabezadoAyuda"><b>No de Serie </b></td>'+
					'<td id="encabezadoAyuda"><b>Monto Original Inversión </b></td>'+
					'<td id="encabezadoAyuda"><b>Depreciado Acumulado </b></td>'+
					'<td id="encabezadoAyuda"><b>Total por Depreciar </b></td>'+

					'<td id="encabezadoAyuda"><b>% de Depreciación Fiscal de Tipo de Activo</b></td>'+
					'<td id="encabezadoAyuda"><b>Póliza Factura </b></td>'+
					'<td id="encabezadoAyuda"><b>Centro de Costos </b></td>'+
					'<td id="encabezadoAyuda"><b>Cuenta Contable Registros </b></td>'+
					'<td id="encabezadoAyuda"><b>Cuenta Contable Depreciación </b></td>'+
				'</tr>'+
				'<tr>'+
					'<td colspan="0" id="contenidoAyuda"><b>1</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>1</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>Activo Carga Masivao</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>12</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>1990-01-01</b></td>'+

					'<td colspan="0" id="contenidoAyuda"><b>20200101-01</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>HJRW920221K70</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>$50,000.00</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>$1,500.00</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>$1,500.00</b></td>'+

					'<td colspan="0" id="contenidoAyuda"><b>30.00%</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>1</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>1</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>190303920100</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>190301060000</b></td>'+
				'</tr>'+
			'</table>'+
			'</div></div>'+
			'</fieldset>';

	$('#ejemploArchivo').html(data);
	$.blockUI({
		message: $('#ejemploArchivo'),
		css: {
			top:  ($(window).height() - 400) /2 + 'px',
			left: ($(window).width() - 400) /2 + 'px',
			width: '500px'
		}
	});
	$('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
}

function habilitaBotones(){
	var archivo = $('#nombreArchivo').val();
	if($('#numero').val() == 0 || $('#numero').val() == '0'){
		habilitaBoton('procesar', 'submit');
		$('#nombreArchivo').val(archivo);
	}
}

function funcionError(){
}

function funcionExito(){
	var parametroBean = consultaParametrosSession();
	$('#nombreArchivo').val('');
	$('#numero').val('');
	$('#transaccionID').val('');
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	deshabilitaBoton('procesar', 'submit');
	agregaFormatoControles('formaGenerica');
}
