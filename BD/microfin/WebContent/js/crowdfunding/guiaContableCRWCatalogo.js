esTab = true;

//Definicion de Constantes y Enums
var catTipoTransaccionCRW = {
	'graba':'1',
	'modifica':'2',
	'elimina':'3'
};

var catTipoConsultaCRW = {
	'principal':1,
	'foranea':2
};
$(document).ready(function() {

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {
	 	esTab = false;
	});

	deshabilita();
	$('#conceptoCRWID').focus();
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionTM').val(0);
	$('#tipoTransaccionTP').val(0);

	$.validator.setDefaults({
      submitHandler: function(event) {

      	if($('#tipoTransaccionCM').val()==1||$('#tipoTransaccionCM').val()==2||$('#tipoTransaccionCM').val()==3){
      		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'cuenta','funcionExitoConcepto', 'funcionFalloGuiaCRW');

   		}

		if($('#tipoTransaccionTM').val()==1 || $('#tipoTransaccionTM').val()==2 || $('#tipoTransaccionTM').val()==3 ){
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje', 'true', 'monedaID','funcionExitoMoneda', 'funcionFalloGuiaCRW');

   		}
   		if($('#tipoTransaccionTP').val()==1||$('#tipoTransaccionTP').val()==2||$('#tipoTransaccionTP').val()==3){
   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica3', 'contenedorForma', 'mensaje', 'true', 'numRetiros','funcionExitoPlazo', 'funcionFalloGuiaCRW');
   		}

      }
   });


   $(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#monedaID').change(function(){
		if($('#conceptoCRWID').val()!=0){
			consultaSubCuentaM($('#conceptoCRWID').val());
		}
	});

	$('#numRetiros').change(function(){
		if($('#conceptoCRWID').val()!=0){
			consultaSubCuentaP($('#conceptoCRWID').val());
		}

	});

	$('#grabaCM').click(function() {
		$('#tipoTransaccionCM').val(catTipoTransaccionCRW.graba);
	});
	$('#grabaMon').click(function() {
		$('#tipoTransaccionTM').val(catTipoTransaccionCRW.graba);
	});
	$('#grabaPla').click(function() {
		$('#tipoTransaccionTP').val(catTipoTransaccionCRW.graba);
	});


	$('#modificaCM').click(function() {
		$('#tipoTransaccionCM').val(catTipoTransaccionCRW.modifica);
	});
	$('#modificaMon').click(function() {
		$('#tipoTransaccionTM').val(catTipoTransaccionCRW.modifica);
	});
	$('#modificaPla').click(function() {
		$('#tipoTransaccionTP').val(catTipoTransaccionCRW.modifica);
	});


	$('#eliminaCM').click(function() {
		$('#tipoTransaccionCM').val(catTipoTransaccionCRW.elimina);
	});
	$('#eliminaMon').click(function() {
		$('#tipoTransaccionTM').val(catTipoTransaccionCRW.elimina);
	});
	$('#eliminaPla').click(function() {
		$('#tipoTransaccionTP').val(catTipoTransaccionCRW.elimina);
	});

	$('#conceptoCRWID').change(function() {
		validaConcepto('conceptoCRWID');
		$('#conceptoCRWID2').val($('#conceptoCRWID').val());
		$('#conceptoCRWID3').val($('#conceptoCRWID').val());


	});
	$('#conceptoCRWID').blur(function() {
		validaConcepto('conceptoCRWID');
		$('#conceptoCRWID2').val($('#conceptoCRWID').val());
		$('#conceptoCRWID3').val($('#conceptoCRWID').val());


	});


	$('#cuenta').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#cuenta').val();
			listaAlfanumerica('cuenta', '1', '2', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});

	consultaConceptosCRW();
  	consultaMoneda();

	$('#formaGenerica').validate({
		rules: {
			conceptoCRWID: 'required',
			cuenta		: {
				maxlength	: 	4
			}
		},

		messages: {
			conceptoCRWID: 'Especifique Concepto',
			cuenta		: {
				maxlength	: 	'Maximo Cuatro Digitos'
			}
		}
	});



	$('#formaGenerica2').validate({
		rules: {
			conceptoCRWID2: 'required',
			subCuenta		: {
				maxlength	: 	2
			}
		},

		messages: {
			conceptoCRWID2: 'Especifique Concepto',
			subCuenta		: {
				maxlength	: 	'Como maximo Dos Digitos'
			}
		}
	});

	$('#formaGenerica3').validate({
		rules: {
			conceptoCRWID3: 'required'
		},

		messages: {
			conceptoCRWID3: 'Especifique Concepto'
		}
	});


});


function deshabilita(){
	deshabilitaBoton('grabaCM', 'submit');
	deshabilitaBoton('grabaPla', 'submit');
	deshabilitaBoton('grabaMon', 'submit');

	deshabilitaBoton('modificaCM', 'submit');
	deshabilitaBoton('modificaPla', 'submit');
	deshabilitaBoton('modificaMon', 'submit');


	deshabilitaBoton('eliminaCM', 'submit');
	deshabilitaBoton('eliminaPla', 'submit');
	deshabilitaBoton('eliminaMon', 'submit');
}

function vacia(){
	$('#cuenta').focus();
	$('#cuenta').val('');
	$('#nomenclatura').val('');
	$('#nomenclaturaCR').val('');
	$('#subCuenta').val('');
	$('#subcuenta1').val('');
}


function consultaConceptosCRW() {
	dwr.util.removeAllOptions('conceptoCRWID');
	dwr.util.addOptions('conceptoCRWID', {0:'SELECCIONAR'});
	conceptosCRWServicio.listaCombo(1, function(conceptosCRW){
		dwr.util.addOptions('conceptoCRWID', conceptosCRW, 'conceptoCRWID', 'descripcion');
	});
}

function consultaMoneda() {
	dwr.util.removeAllOptions('monedaID');
	dwr.util.addOptions('monedaID', {0:'SELECCIONAR'});
	monedasServicio.listaCombo(3, function(monedas){
		dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
	});
}

function validaConcepto(idControl) {
	var jqConcepto = eval("'#" + idControl + "'");
	var numConcepto = $(jqConcepto).val();
	var tipConPrincipal = 1;
	var CuentaMayorCRW = {
		'conceptoCRWID'	:numConcepto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto) && esTab){
		if($('#conceptoCRWID').val()==0){
			vacia();
			deshabilita();
			inicializaForma('formaGenerica','conceptoCRWID');
		} else {
			cuentasMayorCRWServicio.consulta(tipConPrincipal, CuentaMayorCRW,function(cuentaM) {
					if(cuentaM!=null){
						$('#cuenta').val(cuentaM.cuenta);
						$('#nomenclatura').val(cuentaM.nomenclatura);
						$('#nomenclaturaCR').val(cuentaM.nomenclaturaCR);
						consultaSubCuentas(numConcepto);
						deshabilitaBoton('grabaCM', 'submit');
						habilitaBoton('modificaCM', 'submit');
						habilitaBoton('eliminaCM', 'submit');
					}else{
						consultaSubCuentas(numConcepto);
						deshabilitaBoton('modificaCM', 'submit');
						deshabilitaBoton('eliminaCM', 'submit');
						habilitaBoton('grabaCM', 'submit');
						vacia();
					}
			});
		}
	}
}

function consultaSubCuentas(numConcepto) {
	consultaSubCuentaM(numConcepto);
	consultaSubCuentaP(numConcepto);
}

function consultaSubCuentaM(numConcepto) {
	var SubMonedaBeanCon = {
		'conceptoCRWID'	:numConcepto,
		'monedaID'		:$('#monedaID').val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto) && esTab){
		subctaMonedaCRWServicio.consulta(catTipoConsultaCRW.principal, SubMonedaBeanCon,function(subCuentaM) {
			if(subCuentaM!=null){
				$('#conceptoCRWID2').val(subCuentaM.conceptoCRWID);
				$('#subCuenta').val(subCuentaM.subCuenta);
				deshabilitaBoton('grabaMon', 'submit');
				habilitaBoton('modificaMon', 'submit');
				habilitaBoton('eliminaMon', 'submit');
			}else{
				habilitaBoton('grabaMon', 'submit');
				deshabilitaBoton('modificaMon', 'submit');
				deshabilitaBoton('eliminaMon', 'submit');
				$('#subCuenta').val('');
			}
		});
	}
}

function consultaSubCuentaP(numConcepto) {
	var SubPlazoBeanCon = {
		'conceptoCRWID'	:numConcepto,
		'numRetiros'		:$('#numRetiros').val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto) && esTab){
		subctaPlazoCRWServicio.consulta(catTipoConsultaCRW.principal, SubPlazoBeanCon,function(subCuentaP) {
			if(subCuentaP!=null){
				$('#conceptoCRWID3').val(subCuentaP.conceptoCRWID);
				$('#subCuenta1').val(subCuentaP.subCuenta);
				deshabilitaBoton('grabaPla', 'submit');
				habilitaBoton('modificaPla', 'submit');
				habilitaBoton('eliminaPla', 'submit');
			}else{
				deshabilitaBoton('modificaPla', 'submit');
				deshabilitaBoton('eliminaPla', 'submit');
				habilitaBoton('grabaPla', 'submit');
				$('#subCuenta1').val('');
			}
		});
	}
}

function insertAtCaret(areaId,text) {
	var txtarea = document.getElementById(areaId);
	var scrollPos = txtarea.scrollTop;
	var strPos = 0;
	var br = ((txtarea.selectionStart || txtarea.selectionStart == '0') ? "ff" : (document.selection ? "ie" : false ) );
	if (br == "ie") {
		txtarea.focus();
		var range = document.selection.createRange();
		range.moveStart ('character', -txtarea.value.length);
		strPos = range.text.length;
	} else if (br == "ff") strPos = txtarea.selectionStart;

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
	} else if (br == "ff") {
		txtarea.selectionStart = strPos;
		txtarea.selectionEnd = strPos;
		txtarea.focus();
	}
	txtarea.scrollTop = scrollPos;
}

function ayuda(){
	var data;
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura:</legend>'+
			'<div id="ContenedorAyuda">'+
			'<table id="tablaLista">'+
				'<tr align="left">'+
					'<td id="encabezadoLista">&CM</td><td id="contenidoAyuda" align="left"><b>Cuentas de Mayor</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista">&TP</td><td id="contenidoAyuda" align="left"><b> SubCuenta por Tipo (Billetes o Monedas)</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista">&TM</td><td id="contenidoAyuda" align="left"><b> SubCuenta por Tipo de Moneda</b></td>'+
				'</tr>'+

			'</table>'+
			'<br>'+
			'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
			'<div id="ContenedorAyuda">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo: Cuenta Divisa</legend>'+

			'<table id="tablaLista">'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Cuenta: </b></td>'+
					'<td id="contenidoAyuda" colspan="8">1010</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" colspan="9"><b>Nomenclatura:</b></td>'+
				'</tr>'+
				'<tr align="center" id="contenidoAyuda" >'+
					'<td>&CM</td><td>-</td><td>01</td>'+
					'<td>-</td><td>&TM</td><td>-</td>'+
					'<td>&TP</td><td>-</td><td>00</td>'+
				'</tr>'+
				'<tr>'+
					'<td colspan="9" id="encabezadoAyuda"><b>Cuenta Completa:</b></td>'+
				'</tr>'+
				'<tr align="center" id="contenidoAyuda">'+
					'<td>1010</td><td>-</td><td>01</td>'+
					'<td>-</td><td>01</td><td>-</td>'+
					'<td>01</td><td>-</td><td>01</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Descripci&oacute;n:</b></td>'+
					'<td colspan="8" id="contenidoAyuda"><i></i></td>'+
				'</tr>'+
			'</table>'+
			'</div></div>'+
			'</fieldset>'+
			'</fieldset>';

	$('#ContenedorAyuda').html(data);
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: {
                top:  ($(window).height() - 400) /2 + 'px',
                left: ($(window).width() - 400) /2 + 'px',
                width: '400px'
            } });
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
}

function ayudaCR(){
	var data;
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
			'<div id="ContenedorAyuda">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura Centro Costo:</legend>'+
			'<table id="tablaLista">'+
				'<tr align="left">'+
					'<td id="encabezadoLista">&SO</td><td id="contenidoAyuda"><b>Sucursal Origen</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista" >&SC</td><td id="contenidoAyuda"><b>Sucursal Cliente</b></td>'+
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
					'<td id="contenidoAyuda">&SC</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Ejemplo 3:</b></td>'+
					'<td id="contenidoAyuda">15</td>'+
				'</tr>'+
			'</table>'+
			'</div></div>'+
			'</fieldset>'+
			'</fieldset>';

	$('#ContenedorAyuda').html(data);
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: {
                top:  ($(window).height() - 400) /2 + 'px',
                left: ($(window).width() - 400) /2 + 'px',
                width: '400px'
            } });
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
}
function inicializaTipoTrans(tipo){
	var idExcluidos = [];

	// Concepto (Cuenta Mayor)
	if(tipo == 1){
		idExcluidos = [ 'conceptoCRWID', 'monedaID', 'subCuenta', 'numRetiros', 'subCuenta1' ]
	}
	// Por Tipo de Moneda
	if(tipo == 2){
		idExcluidos = [ 'conceptoCRWID', 'cuenta', 'nomenclatura', 'nomenclaturaCR', 'subCuenta', 'numRetiros', 'subCuenta1' ]
	}
	// Por Plazo
	if(tipo == 3){
		idExcluidos = [ 'conceptoCRWID', 'cuenta', 'nomenclatura', 'nomenclaturaCR', 'monedaID', 'subCuenta', 'numRetiros' ]
	}
	limpiaFormaCompleta('formaGenerica', true, idExcluidos);
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionTM').val(0);
	$('#tipoTransaccionTP').val(0);
}
function funcionExitoConcepto(){
	inicializaTipoTrans(1);
	deshabilitaBoton('modificaCM', 'submit');
	deshabilitaBoton('eliminaCM', 'submit');
	deshabilitaBoton('grabaCM', 'submit');
}

function funcionExitoMoneda(){
	inicializaTipoTrans(2);
	deshabilitaBoton('modificaMon', 'submit');
	deshabilitaBoton('eliminaMon', 'submit');
	deshabilitaBoton('grabaMon', 'submit');
}

function funcionExitoPlazo(){
	inicializaTipoTrans(3);
	deshabilitaBoton('modificaPla', 'submit');
	deshabilitaBoton('eliminaPla', 'submit');
	deshabilitaBoton('grabaPla', 'submit');
}

function funcionFalloGuiaCRW(){
}
