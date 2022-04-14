$(document).ready(function() {
	/******* DEFINICION DE CONSTANTES Y NUMEROS DE CONSULTAS *******/
	esTab = false;

	//Definicion de Constantes y Enums
	var catTipoTransaccion = {
		'altaCtaMayor'		:'1',
		'modificaCtaMayor'	:'2',
		'eliminaCtaMayor'	:'3',
		'altaSubCta'		:'4',
		'modificaSubCta'	:'5',
		'eliminaSubCta'		:'6',
		'altaClaAct'		:'7',
		'modificaClaAct'	:'8',
		'eliminaClaAct'		:'9',
	};

	/******* FUNCIONES CARGA AL INICIAR PANTALLA *******/
	inicializaPantalla();
	consultaConceptoContableActivos();
	$("#conceptoActivoID").focus();

	/******* VALIDACIONES DE LA FORMA *******/
	$.validator.setDefaults({
		submitHandler: function(event) {

			if($('#tipoTransaccionCM').val() == 1 || $('#tipoTransaccionCM').val() == 2 || $('#tipoTransaccionCM').val() == 3) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'conceptoActivoID','funcionExito','funcionError');
			}
			if($('#tipoTransaccionSC').val() == 4 || $('#tipoTransaccionSC').val() == 5 || $('#tipoTransaccionSC').val() == 6) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje', 'true', 'tipoActivoID','funcionExito','funcionError');
			}
			if($('#tipoTransaccionCA').val() == 7 || $('#tipoTransaccionCA').val() == 8 || $('#tipoTransaccionCA').val() == 9) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica3', 'contenedorForma', 'mensaje', 'true', 'tipoActivoID3','funcionExito','funcionError');
			}
		}
	});

	$('#formaGenerica').validate({
		rules: {
			conceptoActivoID: 'required',
			cuenta		: {
				maxlength	: 	4
			}
		},

		messages: {
			conceptoActivoID: 'Especifique Concepto',
			cuenta		: {
				maxlength	: 	'Máximo Cuatro Dígitos'
			}
		}
	});

	$('#formaGenerica2').validate({
		rules: {
			tipoActivoID: 'required',
			subCuenta	: 'required'
		},

		messages: {
			tipoActivoID: 'Especifique Tipo de Activo',
			subCuenta	: 'Especifique la SubCuenta'
		}
	});

	$('#formaGenerica3').validate({
		rules: {
			tipoActivoID3: 'required',
			subCuenta3	: 'required'
		},

		messages: {
			tipoActivoID3: 'Especifique Tipo de Activo',
			subCuenta3	: 'Especifique la SubCuenta'
		}
	});

	/******* MANEJO DE EVENTOS *******/
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#grabaCM').click(function() {
		$('#tipoTransaccionCM').val(catTipoTransaccion.altaCtaMayor);
		$('#tipoTransaccionSC').val('');
		$('#tipoTransaccionCA').val('');
	});

	$('#modificaCM').click(function() {
		$('#tipoTransaccionCM').val(catTipoTransaccion.modificaCtaMayor);
		$('#tipoTransaccionSC').val('');
		$('#tipoTransaccionCA').val('');
	});

	$('#eliminaCM').click(function() {
		$('#tipoTransaccionCM').val(catTipoTransaccion.eliminaCtaMayor);
		$('#tipoTransaccionSC').val('');
		$('#tipoTransaccionCA').val('');
	});

	$('#grabaSC').click(function() {
		$('#conceptoActivoID2').val($('#conceptoActivoID').val());
		$('#tipoTransaccionSC').val(catTipoTransaccion.altaSubCta);
		$('#tipoTransaccionCM').val('');
		$('#tipoTransaccionCA').val('');
		$('#conceptoActivoID3').val('');
	});

	$('#modificaSC').click(function() {
		$('#conceptoActivoID2').val($('#conceptoActivoID').val());
		$('#tipoTransaccionSC').val(catTipoTransaccion.modificaSubCta);
		$('#tipoTransaccionCM').val('');
		$('#tipoTransaccionCA').val('');
		$('#conceptoActivoID3').val('');
	});

	$('#eliminaSC').click(function() {
		$('#conceptoActivoID2').val($('#conceptoActivoID').val());
		$('#tipoTransaccionSC').val(catTipoTransaccion.eliminaSubCta);
		$('#tipoTransaccionCM').val('');
		$('#tipoTransaccionCA').val('');
		$('#conceptoActivoID3').val('');
	});

	$('#grabaCA').click(function() {
		$('#conceptoActivoID3').val($('#conceptoActivoID').val());
		$('#tipoTransaccionCA').val(catTipoTransaccion.altaClaAct);
		$('#tipoTransaccionSC').val('');
		$('#tipoTransaccionCM').val('');
		$('#conceptoActivoID2').val('');
	});

	$('#modificaCA').click(function() {
		$('#conceptoActivoID3').val($('#conceptoActivoID').val());
		$('#tipoTransaccionCA').val(catTipoTransaccion.modificaClaAct);
		$('#tipoTransaccionSC').val('');
		$('#tipoTransaccionCM').val('');
		$('#conceptoActivoID2').val('');
	});

	$('#eliminaCA').click(function() {
		$('#conceptoActivoID3').val($('#conceptoActivoID').val());
		$('#tipoTransaccionCA').val(catTipoTransaccion.eliminaClaAct);
		$('#tipoTransaccionSC').val('');
		$('#tipoTransaccionCM').val('');
		$('#conceptoActivoID2').val('');
	});

	$('#conceptoActivoID').change(function() {
		funcionValidaConcepto(this.id);
	});

	$('#conceptoActivoID').blur(function() {
		if(esTab){
			funcionValidaConcepto(this.id);
		}
	});

	$('#cuenta').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = $('#cuenta').val();
		listaAlfanumerica('cuenta', '2', '2', camposLista, parametrosLista, 'listaCuentasContables.htm');
	});

	$('#cuenta').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
	});

	$('#tipoActivoID').bind('keyup', function(e){
		lista('tipoActivoID', '2', '1', 'descripcion', $('#tipoActivoID').val(),'listaTiposActivos.htm');
	});

	$('#tipoActivoID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			consultaTipoActivo(this.id, 'descripcionActivo', 1);
		}
	});

	$('#tipoActivoID3').bind('keyup', function(e){
		lista('tipoActivoID3', '2', '1', 'descripcion', $('#tipoActivoID3').val(),'listaTiposActivos.htm');
	});

	$('#tipoActivoID3').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			consultaTipoActivo(this.id, 'descripcionActivo3', 2);
		}
	});

	/*******  FUNCIONES PARA VALIDACIONES DE CONTROLES *******/
	// FUNCION VALIDA CONCEPTO CONTABLE
	function funcionValidaConcepto(idControl) {
		var jqConcepto = eval("'#" + idControl + "'");
		var numConcepto = $(jqConcepto).val();
		var tipCon = 1;
		var CuentaMayorBeanCon = {
			'conceptoActivoID'	:numConcepto
		};
		inicializaCtaMayor();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && numConcepto > 0){
			guiaContableActivosServicio.consulta(tipCon, CuentaMayorBeanCon,function(cuentaM) {
				if(cuentaM!=null){
					$('#cuenta').val(cuentaM.cuenta);
					$('#nomenclatura').val(cuentaM.nomenclatura);
					$('#nomenclaturaCC').val(cuentaM.nomenclaturaCC);
					$('#conceptoActivoID2').val(numConcepto);
					$('#conceptoActivoID3').val(numConcepto);
					deshabilitaBoton('grabaCM', 'submit');
					habilitaBoton('modificaCM', 'submit');
					habilitaBoton('eliminaCM', 'submit');
				}else{
					deshabilitaBoton('modificaCM', 'submit');
					deshabilitaBoton('eliminaCM', 'submit');
					habilitaBoton('grabaCM', 'submit');
					$('#cuenta').focus();
					$('#conceptoActivoID2').val('');
					$('#conceptoActivoID3').val('');
				}
			});
		}else{
			if($('#conceptoActivoID').val()==""){
				inicializaPantalla();
			}
		}
	}

	// FUNCION PARA LLENAR COMBO DE CONCEPTOS CONTABLES
	function consultaConceptoContableActivos() {
		dwr.util.removeAllOptions('conceptoActivoID');
		dwr.util.addOptions('conceptoActivoID', {"":'SELECCIONAR'});
		guiaContableActivosServicio.listaCombo(1, function(conceptosBean){
			dwr.util.addOptions('conceptoActivoID', conceptosBean, 'conceptoActivoID', 'descripcion');
		});
	}

	//FUNCIÓN CONSULTA LOS DATOS DEL TIPO DE ACTIVO
	function consultaTipoActivo(idControl, descripcionActivo, tipoClasificacion) {
		var jqNumero = eval("'#" + idControl + "'");
		var jqDescripcion = eval("'#" + descripcionActivo + "'");

		var tipoActivoID = $(jqNumero).val();
		setTimeout("$('#cajaLista').hide();", 200);
		inicializaSubCuenta();
		var numCon=1;
		var BeanCon = {
				'tipoActivoID':tipoActivoID
			};

		if(tipoActivoID != '' && !isNaN(tipoActivoID) && tipoActivoID > 0){
			tiposActivosServicio.consulta(numCon,BeanCon,function(tipoActivoBean) {
				if(tipoActivoBean!=null){
					if(tipoActivoBean.estatus == 'A'){
						$(jqDescripcion).val(tipoActivoBean.descripcion);

						//$('#descripcionActivo').val(tipoActivoBean.descripcion);
						if(tipoClasificacion == 1){
							consultaSubCtaTipoActivo($('#conceptoActivoID').val(),tipoActivoID);
						} else {
							consultaCtaTipoActivo($('#conceptoActivoID').val(),tipoActivoID);
						}

					}else{
						$(jqNumero).val('');
						$(jqDescripcion).val('');
						$(jqNumero).focus();
						mensajeSis('El Tipo de Activo no esta Activo');
					}
				}else{
					$(jqNumero).val('');
					$(jqDescripcion).val('');
					$(jqNumero).focus();
					mensajeSis('No Existe el Tipo de Activo');
				}
			});
		}else{
			if(isNaN(tipoActivoID)){
				$(jqNumero).val('');
				$(jqDescripcion).val('');
				$(jqNumero).focus();
				mensajeSis('No Existe el Tipo de Activo');
			}
		}
	}

	//FUNCIÓN CONSULTA SUBCUENTA DEL TIPO DE ACTIVO
	function consultaSubCtaTipoActivo(idConceptoActivoID, idTipoActivo) {

		var numCon=2;
		var BeanCon = {
			'conceptoActivoID'	:idConceptoActivoID,
			'tipoActivoID':idTipoActivo
		};
		$('#subCuenta').val('');
		guiaContableActivosServicio.consulta(numCon,BeanCon,function(Bean) {
			if(Bean!=null){
				$('#subCuenta').val(Bean.subCuenta);
				deshabilitaBoton('grabaSC', 'submit');
				habilitaBoton('modificaSC', 'submit');
				habilitaBoton('eliminaSC', 'submit');
			}else{
				habilitaBoton('grabaSC', 'submit');
				deshabilitaBoton('modificaSC', 'submit');
				deshabilitaBoton('eliminaSC', 'submit');
			}
		});
	}

	//FUNCIÓN CONSULTA SUBCUENTA DEL TIPO DE ACTIVO
	function consultaCtaTipoActivo(idConceptoActivoID, idTipoActivo) {

		var numCon = 3;
		var BeanCon = {
			'conceptoActivoID' : idConceptoActivoID,
			'tipoActivoID' : idTipoActivo
		};
		$('#subCuenta3').val('');
		guiaContableActivosServicio.consulta(numCon,BeanCon,function(Bean) {
			if(Bean!=null){
				$('#subCuenta3').val(Bean.subCuenta);
				deshabilitaBoton('grabaCA', 'submit');
				habilitaBoton('modificaCA', 'submit');
				habilitaBoton('eliminaCA', 'submit');
			}else{
				habilitaBoton('grabaCA', 'submit');
				deshabilitaBoton('modificaCA', 'submit');
				deshabilitaBoton('eliminaCA', 'submit');
			}
		});
	}


});// FIN DOCUMENT READY

//FUNCION INICIALIZA PANTALLA
function inicializaPantalla(){
	//CAMPOS CUENTA MAYOR
	deshabilitaBoton('grabaCM', 'submit');
	deshabilitaBoton('modificaCM', 'submit');
	deshabilitaBoton('eliminaCM', 'submit');
	$('#cuenta').val('');
	$('#nomenclatura').val('');
	$('#nomenclaturaCC').val('');

	//SUBCUENTA
	deshabilitaBoton('grabaSC', 'submit');
	deshabilitaBoton('modificaSC', 'submit');
	deshabilitaBoton('eliminaSC', 'submit');
	$('#tipoActivoID').val('');
	$('#descripcionActivo').val('');
	$('#subCuenta').val('');

	//SUBCUENTA
	deshabilitaBoton('grabaCA', 'submit');
	deshabilitaBoton('modificaCA', 'submit');
	deshabilitaBoton('eliminaCA', 'submit');
	$('#tipoActivoID3').val('');
	$('#descripcionActivo3').val('');
	$('#subCuenta3').val('');

}
//FUNCION INICIALIZA CUENTAS MAYOR
function inicializaCtaMayor(){
	//CAMPOS CUENTA MAYOR
	deshabilitaBoton('grabaCM', 'submit');
	deshabilitaBoton('modificaCM', 'submit');
	deshabilitaBoton('eliminaCM', 'submit');
	$('#cuenta').val('');
	$('#nomenclatura').val('');
	$('#nomenclaturaCC').val('');
}

//FUNCION INICIALIZA SUB CUENTA
function inicializaSubCuenta(){
	//SUBCUENTA
	deshabilitaBoton('grabaSC', 'submit');
	deshabilitaBoton('modificaSC', 'submit');
	deshabilitaBoton('eliminaSC', 'submit');
	$('#descripcionActivo').val('');
	$('#subCuenta').val('');
}

//FUNCION INICIALIZA SUB ACTIVO
function inicializaSubActivo(){
	//SUBCUENTA
	deshabilitaBoton('grabaCA', 'submit');
	deshabilitaBoton('modificaCA', 'submit');
	deshabilitaBoton('eliminaCA', 'submit');
	$('#descripcionActivo3').val('');
	$('#subCuenta3').val('');
}

function insertAtCaret(areaId,text) {
	var txtarea = document.getElementById(areaId);
	var scrollPos = txtarea.scrollTop;
	var strPos = 0;
	var br = ((txtarea.selectionStart || txtarea.selectionStart == '0') ?
			"ff" : (document.selection ? "ie" : false ) );
	if (br == "ie") {
		txtarea.focus();
		var range = document.selection.createRange();
		range.moveStart ('character', -txtarea.value.length);
		strPos = range.text.length;
	}
	else if (br == "ff") strPos = txtarea.selectionStart;
	var front = (txtarea.value).substring(0,strPos);
	var back = (txtarea.value).substring(strPos,txtarea.value.length);
	txtarea.value=front+text+back;
	strPos = strPos + text.length;
	if (br == "ie") {
		txtarea.focus();
		var range = document.selection.createRange();
		range.moveStart ('character', -txtarea.value.length);
		range.moveStart ('character', strPos);
		range.moveEnd ('character', 0);
		range.select();
	}
	else if (br == "ff") {
	txtarea.selectionStart = strPos;
	txtarea.selectionEnd = strPos;
	txtarea.focus();
	}
	txtarea.scrollTop = scrollPos;
}

// FUNCION MUESTRA MENSAJE DE AYUDA
function ayuda(idCampo){
	var data;

	switch(idCampo) {
		case 'nomenclatura':
			data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
						'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura:</legend>'+
						'<div id="ContenedorAyuda">'+
						'<table id="tablaLista">'+
							'<tr align="left">'+
								'<td id="encabezadoLista">&CM</td><td id="contenidoAyuda" align="left"><b>Cuentas de Mayor</b></td>'+
							'</tr>'+
							'<tr align="left">'+
								'<td id="encabezadoLista">&TA</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Tipo de Activo</b></td>'+
							'</tr>'+
							'<tr align="left">'+
								'<td id="encabezadoLista">&TS</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Clasificación de Activo</b></td>'+
							'</tr>'+
						'</table>'+
						'<br>'+
					'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
						'<div id="ContenedorAyuda">'+
						'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo: Cuenta de Depreciación</legend>'+

						'<table id="tablaLista">'+
								'<tr>'+
									'<td id="encabezadoAyuda"><b>Cuenta: </b></td>'+
									'<td id="contenidoAyuda" colspan="8">2101</td>'+
								'</tr>'+
							'<tr>'+
									'<td id="encabezadoAyuda" colspan="9"><b>Nomenclatura:</b></td>'+
							'</tr>'+
							'<tr align="center" id="contenidoAyuda" >'+
									'<td>&CM</td><td>-</td><td>&TA</td>'+
									'<td>-</td><td>&TS</td><td>-</td>'+
									'<td>01</td><td>-</td><td>01</td>'+
							'</tr>'+
							'<tr>'+
									'<td colspan="9" id="encabezadoAyuda"><b>Cuenta Completa:</b></td>'+
							'</tr>'+
							'<tr align="center" id="contenidoAyuda">'+
									'<td>1800</td><td>-</td><td>01</td>'+
									'<td>-</td><td>01</td><td>-</td>'+
									'<td>01</td><td>-</td><td>01</td>'+
							'</tr>'+
							'<tr>'+
								'<td id="encabezadoAyuda"><b>Desripción: </b></td>'+
								'<td id="contenidoAyuda" colspan="8">DEPRECIACION ACUMULADA MOBILIARIO</td>'+
							'</tr>'+
							'<tr>'+
						'</table>'+
						'</div></div>'+
					'</fieldset>'+
				'</fieldset>';
		break;
		case 'nomenclaturaCC':
			data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
						'<div id="ContenedorAyuda">'+
						'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura Centro Costo:</legend>'+
						'<table id="tablaLista">'+
								'<tr align="left">'+
									'<td id="encabezadoLista">&SO</td><td id="contenidoAyuda"><b>Sucursal Origen</b></td>'+
								'</tr>'+
								'<tr>'+
									'<td id="encabezadoLista" >&SA</td><td id="contenidoAyuda"><b>Sucursal Activo</b></td>'+
								'</tr>'+
						'</table>'+
						'<br>'+
				 '<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
						'<div id="ContenedorAyuda">'+
						'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplos: </legend>'+
						'<table id="tablaLista">'+
							'<tr>'+
									'<td id="encabezadoAyuda"><b>Ejemplo 1: </b></td>'+
									'<td id="contenidoAyuda">&SO</td>'+
							'</tr>'+
							'<tr>'+
									'<td id="encabezadoAyuda"><b>Ejemplo 2:</b></td>'+
									'<td id="contenidoAyuda">&SA</td>'+
							'</tr>'+
							'<tr>'+
									'<td id="encabezadoAyuda"><b>Ejemplo 3:</b></td>'+
									'<td id="contenidoAyuda">15</td>'+
							'</tr>'+
						'</table>'+
						'</div></div>'+
					'</fieldset>'+
				 '</fieldset>';
		break;
		default:
			data = "";
	}

	$('#ContenedorAyuda').html(data);
	$.blockUI({
		message: $('#ContenedorAyuda'),
			css: {
				top:  ($(window).height() - 400) /2 + 'px',
				left: ($(window).width() - 400) /2 + 'px',
				width: '400px'
			}
	});
	$('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
}

//FUNCION QUE SE EJECUTA CUANDO EL RESULTADO FUE EXITO
function funcionExito(){

	if($('#tipoTransaccionCM').val() == 1 || $('#tipoTransaccionCM').val() == 2 || $('#tipoTransaccionCM').val() == 3) {
		inicializaCtaMayor();
	}
	if($('#tipoTransaccionSC').val() == 4 || $('#tipoTransaccionSC').val() == 5 || $('#tipoTransaccionSC').val() == 6) {
		inicializaSubCuenta();
	}
	if($('#tipoTransaccionCA').val() == 7 || $('#tipoTransaccionCA').val() == 8 || $('#tipoTransaccionCA').val() == 9) {
		inicializaSubActivo();
	}
	$('#tipoTransaccionCM').val('');
	$('#tipoTransaccionSC').val('');
	$('#tipoTransaccionCA').val('');
	$('#conceptoActivoID2').val('');
	$('#conceptoActivoID3').val('');
}

// FUNCION QUE SE EJECUTA CUANDO EL RESULTADO FUE ERROR
function funcionError(){

}