var tabButton = 50;
$(document).ready(function() {
	var paramSesion = consultaParametrosSession();
	esTab = true;

	// DefiniciÓn de Constantes y Enums
	var catTipoTransaccionInverciones = {
			'agrega' : 1 ,
			'modifica' :2
	};

	var catTipoListaMonedas = {
			'combo' : 3
	};

	var catTipoConsultaAportaciones = {
			'general' : 2,

	};

	var catTipoListaTipoAportacion = {
			'principal':1
		};
	$('#reinvertir2').attr("checked",true);
	cargaComboReinvertir(2);
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	$('#diasPeriodo').hide();
	$('#diasPeriodo').val('');
	$('#lbldiasPeriodo').hide();
	$('#lblpagoIntCal').hide();
	$('#trMaxPuntos').hide();
	$('#maxPuntos').val('');
	$('#trMinPuntos').hide();
	$('#minPuntos').val('');
	$('#diasPago').hide();
	$('#diasPago').val('');
	$('#lbldiasPago').hide();
	$('#lblpagoIntCap').hide();

	consultaMoneda();
	muestraOcultaSegunAnclaje();

	$('#tipoPagoInt').blur(function() {
		var tipoPagoInt =$('#tipoPagoInt').val();
		muestraCampoDias(tipoPagoInt);
		muestraCampoPagoIntCal(tipoPagoInt);
		muestraCamposProgramado(tipoPagoInt);
	});


	$('#fechaCreacion').val(paramSesion.fechaAplicacion);
	agregaFormatoControles('formaGenerica');
	$(':text').focus(function() {
	 	esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje',
						'true', 'tipoAportacionID', 'funcionExito','funcionFallo');
			}
	});

	$('#tipoAportacionID').focus();

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#tipoAportacionID').bind('keyup',function(e){

		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "descripcion";
		 parametrosLista[0] = $('#tipoAportacionID').val();

		lista('tipoAportacionID', 2, catTipoListaTipoAportacion.principal, camposLista,parametrosLista, 'listaTiposAportaciones.htm');
	});

	$('#diasPago').bind('keyup',function (e) {

		// Valida que dolo acepte números y comas
		var objRegExpD=/^[0-9,]+$/;
		var cad=$('#diasPago').val();
			if (!objRegExpD.test(cad)){
				mensajeSis("Solo números separados por comas (12,24,10)");
				$('#diasPago').val('');
				return false;
			}

		// valida que el numero sea mayor o igual a 1 y menor o igual a 28
		var arreNumeros=cad.split(',');
		arreNumeros.forEach(function(num) {
		  	if (parseInt(num) > 28 || parseInt(num) < 1){
				mensajeSis("El rango de días permitidos es de 1 - 28.");
				$('#diasPago').val('');
				return false;
			}
		});
	});

	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionInverciones.agrega);
		habilitaControl('tipoReinversion');
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionInverciones.modifica);
		habilitaControl('tipoReinversion');
	});

	$('#maximoEdad').blur(function(){
		if(esTab){
			validaRango(this.id);
		}

	});

	$('#minimoEdad').blur(function(){
		if(esTab){
		validaRango(this.id);
		}
	});

	$('input[name="anclaje"]').change(function (event){
		if($('input[name=anclaje]:checked').val() === 'S'){
			if($('#especificaTasaSi').is(':checked')){
				mensajeSis("Para la Funcionalidad de Anclajes no está permitida la Especificación de Tasa");
				$('#anclajeSi').attr("checked",false);
				$('#anclajeNo').attr("checked",true);
			}
			$('#tasaMontoGlobalNo').attr("checked",true);
			habilitaTasaMGlobal(false);
		} else {
			muestraOcultaSegunAnclaje();
			$('#minimoAnclaje').val('');
			habilitaTasaMGlobal(true);
		}
	});

	$('#especificaTasaSi').click(function(){
		validaEspTasa();
	});

	$('#especificaTasaNo').click(function(){
		$('#trMaxPuntos').hide();
		$('#maxPuntos').val('');
		$('#trMinPuntos').hide();
		$('#minPuntos').val('');
	});

	$('input[name="tasaMontoGlobal"]').change(function (event){
		muestraIncluyeGpo('tdIncluyeGpo',$('input[name=tasaMontoGlobal]:checked').val());
	});

	$('input[name="tasaFV"]').change(function (event){
		if($('input[name=tasaFV]:checked').val() === 'V'){
			if($('#especificaTasaSi').is(':checked')){
				mensajeSis("Para el Cálculo de Interés con Tasa Variable no está permitida la Especificación de Tasa.");
				$('#tasaV').attr("checked",false);
				$('#tasaF').attr("checked",true);
			}
			$('#tasaMontoGlobalNo').attr("checked",true);
			habilitaTasaMGlobal(false);
		} else {
			habilitaTasaMGlobal(true);
		}
	});

	// valida en rango de edades
	function validaRango(idControl){
		var jqRango = eval("'#" + idControl + "'");
		if( $('#minimoEdad').val() != '' && $('#maximoEdad').val() != '' &&
				!isNaN($('#minimoEdad').val()) && !isNaN($('#maximoEdad').val())){
			if( $('#maximoEdad').asNumber() > 150){
				mensajeSis('La Edad no Puede ser Mayor a 150');
				$(jqRango).val('');
				$(jqRango).focus();
			}else if($('#minimoEdad').asNumber() > $('#maximoEdad').asNumber() || $('#minimoEdad').asNumber() == $('#maximoEdad').asNumber()){
				mensajeSis('El Rango Final debe Ser Mayor que el Rango Inicial.');
				$(jqRango).val('');
				$(jqRango).focus();
			}else if($(jqRango).asNumber() < 0 || $(jqRango).asNumber() == 0){
				mensajeSis('Especifique un Número Mayor que Cero');
				$(jqRango).val('');
				$(jqRango).focus();
			}
		}else if($('#minimoEdad').val() != '' && !isNaN($('#minimoEdad').val()) ){
			if($(jqRango).asNumber() < 0 || $(jqRango).asNumber() == 0){
				mensajeSis('Especifique un Número Mayor que Cero');
				$(jqRango).val('');
				$(jqRango).focus();
			}
		}
		else if($('#maximoEdad').val() != '' && !isNaN($('#maximoEdad').val()) ){
			if($(jqRango).asNumber() < 0 || $(jqRango).asNumber() == 0){
				mensajeSis('Especifique un Número Mayor que Cero');
				$(jqRango).val('');
				$(jqRango).focus();
			}
		}
	}

	function consultaMoneda() {
		dwr.util.removeAllOptions('monedaSelect');
		dwr.util.addOptions('monedaSelect', {'':'SELECCIONAR'});
		monedasServicio.listaCombo(catTipoListaMonedas.combo, function(monedas){
		dwr.util.addOptions('monedaSelect', monedas, 'monedaID', 'descripcion');
		});
	}


	$('#tipoAportacionID').blur(function() {
		if(esTab){
		validaTipoAportacion(this);
		}
	});

	$('#fechaInscripcion').change(function() {
		var Yfecha= $('#fechaInscripcion').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha ==''){
				$('#fechaInscripcion').val(parametroBean.fechaSucursal);
			}
				if($('#fechaInscripcion').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Inscripción  es Mayor a la Fecha del Sistema.");
					$('#fechaInscripcion').val(parametroBean.fechaSucursal);
				}

		}else{
			$('#fechaInscripcion').val(parametroBean.fechaSucursal);
		}

	});

	/*==== Función valida fecha formato (yyyy-MM-dd) =====*/
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
				if (comprobarSiBisisesto(anio)){ numDias=29}else{ numDias=28};
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


	$('#tipoReinversion').change(function(){
		if($('#tipoReinversion').val() == 'N'){
			$('#reinvertir1').attr("disabled",true);
			$('#reinvertir2').attr("checked",true);
			$('#reinvertir3').attr("disabled",true);
			$('#reinvertir4').attr("disabled",true);
		}else{
			$('#reinvertir1').attr("checked",true);
			$('#reinvertir1').attr("disabled",false);
			$('#reinvertir2').attr("disabled",false);
			$('#reinvertir4').attr("disabled",false);
		}
	});

	$('#reinvertir1').click(function(){
		cargaComboReinvertir(1);
	});

	$('#reinvertir2').click(function(){
		cargaComboReinvertir(2);
	});

	$('#reinvertir3').click(function(){
		cargaComboReinvertir(3);
	});
	$('#reinvertir4').click(function(){
		cargaComboReinvertir(4);
	});
function cargaComboReinvertir(tipo){
	dwr.util.removeAllOptions('tipoReinversion');

	if (tipo == 1) {
		dwr.util.addOptions( "tipoReinversion", {'C':'SOLO CAPITAL', 'CI': 'CAPITAL MÁS INTERÉS','I': 'INDISTINTO'});
		$('#tipoReinversion').val('C').selected;
		habilitaControl('tipoReinversion');
	}else if(tipo == 2){
		dwr.util.addOptions( "tipoReinversion", {'N':'NO REALIZA INVERSIÓN'});
		$('#tipoReinversion').val('N').selected;
		deshabilitaControl('tipoReinversion');
	}else if(tipo == 3){
		dwr.util.addOptions( "tipoReinversion", {'I': 'INDISTINTO'});
		$('#tipoReinversion').val('I').selected;
		deshabilitaControl('tipoReinversion');
	}else {
		dwr.util.addOptions( "tipoReinversion", {'E': 'POSTERIOR'});
		$('#tipoReinversion').val('E').selected;
		deshabilitaControl('tipoReinversion');
	}

}


	function validaTipoAportacion(){
		var tipoAportacion = $('#tipoAportacionID').val();
		setTimeout("$('#cajaLista').hide();", 200);

		if(tipoAportacion != '' && !isNaN(tipoAportacion)){

			if(tipoAportacion == '0'){
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','tipoAportacionID');
				inicializaCampos();
				$('#fechaInscripcion').val("");
				$('#reinvertir2').attr("checked",true);
				muestraOcultaSegunAnclaje();
				$('#tasaF').attr('checked',true);
				$('#pagoIntCalIgual').attr('checked',true);
				$('#reinvertir2').attr('checked',true);
				$('#tipoReinversion').val('N').selected;
			}else{
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var tiposAportacionesBean = {
		                'tipoAportacionID':tipoAportacion,
		                'monedaId':0
		        };
				dwr.util.removeAllOptions('tipoReinversion');

				tiposAportacionesServicio.consulta(catTipoConsultaAportaciones.general, tiposAportacionesBean,{ async: false, callback: function(tiposAportaciones){
					if(tiposAportaciones!=null){
						dwr.util.setValues(tiposAportaciones);
						// REINVERSION --------------------
						evaluaReinversion(tiposAportaciones.reinversion,tiposAportaciones.reinvertir);

						muestraOcultaSegunAnclaje();
						consultaComboTipoPagoInt(tiposAportaciones.tipoPagoInt);
						muestraCampoPagoIntCal(tiposAportaciones.tipoPagoInt);

						if(tiposAportaciones.fechaInscripcion=='1900-01-01'){
							$('#fechaInscripcion').val("");

						}else{
							$('#fechaInscripcion').val(tiposAportaciones.fechaInscripcion);
						}

						if(tiposAportaciones.diaInhabil == 'SD'){
							$('#sabaDomi').attr('checked',true);
						}
						else{
							$('#soloDomi').attr('checked',true);
						}

						if(tiposAportaciones.diaInhabil == null){
							$('#sabaDomi').attr('checked',true);
						}

						$('#minimoApertura').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});

						$('#minimoAnclaje').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});

						if(tiposAportaciones.pagoIntCal == 'I'){
							$('#pagoIntCalIgual').attr('checked',true);
						}
						else{
							$('#pagoIntCalDev').attr('checked',true);
						}
						if(tiposAportaciones.pagoIntCal == ''){
							$('#pagoIntCalIgual').attr('checked',true);
						}

						if(tiposAportaciones.especificaTasa == 'N'){
							$('#trMaxPuntos').hide();
							$('#trMinPuntos').hide();
							$('#maxPuntos').val('');
							$('#minPuntos').val('');
						}else {
							$('#trMaxPuntos').show();
							$('#trMinPuntos').show();
						}

						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('modifica', 'submit');

						if(tiposAportaciones.pagoIntCapitaliza == 'S'){
							$('#pagoIntCapitalizaSi').attr('checked',true);
						}else if(tiposAportaciones.pagoIntCapitaliza == 'N'){
							$('#pagoIntCapitalizaNo').attr('checked',true);
						}else{
							$('#pagoIntCapitalizaIn').attr('checked',true);
						}
						muestraCamposProgramado(tiposAportaciones.tipoPagoInt);

					}else{
						mensajeSis("No Existe el Tipo de Aportación");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						$('#tipoAportacionID').val('');
						$('#tipoAportacionID').focus();
						$('#tipoAportacionID').select();
						inicializaCampos();
						inicializaForma('formaGenerica','tipoAportacionID');
						$('#tasaF').attr('checked',true);
						$('#pagoIntCalIgual').attr('checked',true);
					}

				}
			});

			}
			$('input[name="tasaMontoGlobal"]').change();
			$('input[name="tasaFV"]').change();
			$('input[name="anclaje"]').change();
		}
	}



	$('#formaGenerica').validate({
		rules: {
			tipoAportacionID: 'required',
			descripcion: 'required',
			monedaSelect: 'required',
			tipoReinversion: 'required',
			minimoApertura:{
				number: true,
				maxlength:24
			},
			minimoAnclaje:{
				maxlength:24
			},
			minimoApertura:{
				required: true,
				number: true
			},
			tipoPagoInt: 'required',
			diasPeriodo: {
				required : function() {
					if(($('#tipoPagoInt').val() == 'P')
					||(($('#tipoPagoInt').val() == 'V,F,P'))
					||(($('#tipoPagoInt').val() == 'V,P'))
					||(($('#tipoPagoInt').val() == 'F,P'))){
						return true;
						}else {
							return false;
							}
					}
			},
			pagoIntCal: {
				required : function() {
					if(($('#tipoPagoInt').val() == 'P')
					||(($('#tipoPagoInt').val() == 'V,F,P'))
					||(($('#tipoPagoInt').val() == 'V,P'))
					||(($('#tipoPagoInt').val() == 'F,P'))
					||(($('#tipoPagoInt').val() == 'F,V'))
					||(($('#tipoPagoInt').val() == 'F'))){
						return true;
						}else {
							return false;
							}
					}
			},
			maxPuntos:{
				required :function(){return $('#especificaTasaSi').is(':checked')}
			},
			minPuntos:{
				required :function(){return $('#especificaTasaSi').is(':checked')}
			},
			tasaMontoGlobal:{
				required: true
			},
			incluyeGpoFam:{
				required : function() { return $('#incluyeGpoFamSi').is(":visible");}
			},
			diasPago: {
				required : function() {
					if(($('#tipoPagoInt').val() == 'E')
					||(($('#tipoPagoInt').val() == 'V,E'))){
						return true;
					}else {
						return false;
					}
				}
			}
		},


		messages: {
			tipoAportacionID: 'Especifique Número.',
			descripcion: 'Especifique la Descripción.',
			monedaSelect : 'Especifique un Tipo de Moneda',
			tipoReinversion: 'Especifique un Tipo de Reinversión',
			minimoApertura:{
				number:'Sólo Números',
				maxlength:'Máximo 24 Caracteres.'
			},
			minimoAnclaje:{
				maxlength:'Máximo 24 Caracteres.'
			},
			minimoApertura:{
				required: 'Especifique Monto Mínimo de Apertura.',
				number: 'Sólo Números.'
			},
			tipoPagoInt: 'Especifique la Forma de Pago de Interés.',
			diasPeriodo: {
				required : 'Especifique el Número de Días de Periodo.'
			},
			pagoIntCal: 'Especifique el Tipo de Pago de Interés.',
			maxPuntos:{
				required :'Especifique el Máximo de Puntos.'
			},
			minPuntos:{
				required :'Especifique el Mínimo de Puntos.'
			},
			tasaMontoGlobal:{
				required: 'Especifique Tasa Monto Global.'
			},
			incluyeGpoFam:{
				required : 'Especifique Incluye Grupo Familiar.'
			},
			diasPago: {
				required : 'Especifique el Número de Días de Pago.'
			}
		}
	});

	//**************  anclaje ***************//
	function muestraOcultaSegunAnclaje(){
		if($('#anclajeNo').is(':checked')){
			$('#trMinimoAnclaje').hide();
		}
		else if($('#anclajeSi').is(':checked')){
			$('#trMinimoAnclaje').show();
		}
	}


	//------------ EVALUA INVERSION
	function evaluaReinversion(reinversion, reinvertir){
		dwr.util.removeAllOptions('tipoReinversion');

		if (reinversion == 'S') {
			dwr.util.addOptions( "tipoReinversion", {'C':'SOLO CAPITAL', 'CI': 'CAPITAL MÁS INTERÉS','I': 'INDISTINTO'});
			habilitaControl('tipoReinversion');
			$('#reinvertir1').attr('checked',true);
			$('#reinvertir2').attr('checked',false);
			$('#reinvertir3').attr('checked',false);
			$('#reinvertir4').attr('checked',false);
			$('#tipoReinversion').val(reinvertir).selected;
		}

		if (reinversion == 'I') {
			dwr.util.addOptions( "tipoReinversion", {'I': 'INDISTINTO'});
			deshabilitaControl('tipoReinversion');;
			$('#reinvertir1').attr('checked',false);
			$('#reinvertir2').attr('checked',false);
			$('#reinvertir3').attr('checked',true);
			$('#reinvertir4').attr('checked',false);
			$('#tipoReinversion').val('I').selected;
		}

		if (reinversion == 'N') {
			dwr.util.addOptions( "tipoReinversion", {'N':'NO REALIZA INVERSIÓN'});
			deshabilitaControl('tipoReinversion');
			$('#reinvertir1').attr('checked',false);
			$('#reinvertir2').attr('checked',true);
			$('#reinvertir3').attr('checked',false);
			$('#reinvertir4').attr('checked',false);
			$('#tipoReinversion').val('N').selected;
		}

		if (reinversion == 'E') {
			dwr.util.addOptions( "tipoReinversion", {'E':'POSTERIOR'});
			deshabilitaControl('tipoReinversion');
			$('#reinvertir1').attr('checked',false);
			$('#reinvertir2').attr('checked',false);
			$('#reinvertir3').attr('checked',false);
			$('#reinvertir4').attr('checked',true);
			$('#tipoReinversion').val('E').selected;
		}
	}

	function consultaComboTipoPagoInt(tipoPagoInt) {
		var tp= tipoPagoInt.split(',');
		var tamanio = tp.length;
	 	for (var i=0;i<tamanio;i++) {
			var tip = tp[i];
			var jqTipo = eval("'#tipoPagoInt option[value="+tip+"]'");
			$(jqTipo).attr("selected","selected");
			muestraCampoDias(tipoPagoInt);
		}
	}

	function muestraCampoDias(tipoPagoInt){
		var tipoPago  = eval("'" + tipoPagoInt + "'");
		var Periodo ='P';
		var valor= tipoPago.split(",");
		for(var i=0; i< valor.length; i++){
			var tipoPagInt = valor[i];
			if(tipoPagInt == Periodo){
				$('#diasPeriodo').show();
				$('#lbldiasPeriodo').show();
				$('#lblpagoIntCal').show();
			}else{
				$('#diasPeriodo').hide();
				$('#lbldiasPeriodo').hide();
				$('#lblpagoIntCal').hide();
			}
		}
	}

	function muestraCampoPagoIntCal(valTipoPagoInt){
	    if((valTipoPagoInt.includes("P")) || (valTipoPagoInt.includes("F"))){
	    	$('#lblpagoIntCal').show();
	    }else{
	    	$('#lblpagoIntCal').hide();
	    }
	}

	function muestraCamposProgramado(tipoPagoInt){
		var tipoPago  = eval("'" + tipoPagoInt + "'");
		var Programado ='E';
		var valor= tipoPago.split(",");

			if(tipoPago == 'V,E'){
				$('#diasPago').show();
				$('#lbldiasPago').show();
				$('#lblpagoIntCap').show();
			}else if(tipoPago == Programado){
				$('#diasPago').show();
				$('#lbldiasPago').show();
				$('#lblpagoIntCap').show();
			}else{
				$('#diasPago').hide();
				$('#lbldiasPago').hide();
				$('#lblpagoIntCap').hide();
				$('#diasPago').val('');
				$('#pagoIntCapitalizaIn').attr('checked',true);
			}
	}


});




//***********  Actividades del Banco de MEXICO ***********//

	$('#agregaActividad').click(function(){
		agregaActividadBMX();
	});

	//funcion para agregar renglones de actividades BMX
	function agregaActividadBMX(){
		$('#gridActividadesMBX').show(500);
		 numeroFila = consultaFilas();
		var nuevaFila = parseInt(numeroFila) + 1;

		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';

		if(numeroFila == 0){
				tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
				tds += '<input type="text" id="actividadBMXID'+nuevaFila+'" name="lactividadBMXID" size="20" tabindex="'+(tabButton = tabButton+1)+'" onKeyUp="listaActividades(\'actividadBMXID'+nuevaFila+'\');" onblur="consultaActividadBMX(this.id);" /></td>';
				tds += '<td><input  id="descripcionActBMX'+nuevaFila+'" name="descripcionActBMX"   size="80" value="" readOnly="true" type="text" /></td>';
				tds += '<td nowrap="nowrap"><input type="button" name="eliminar" id="'+nuevaFila +'" value="" tabindex="'+(tabButton = tabButton+1)+'" class="btnElimina" onclick="eliminaActividad(this.id)"/>';
				tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value=""   tabindex="'+(tabButton = tabButton+1)+'" class="btnAgrega"  onclick="agregaActividadBMX()""/></td>';
				tds += '</tr>';
		} else {
			var contador = 1;
			    $('input[name=consecutivoID]').each(function() {
				contador = contador + 1;
			  });
				tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
				tds += '<input type="text" id="actividadBMXID'+nuevaFila+'" name="lactividadBMXID" size="20"  tabindex="'+(tabButton = tabButton+1)+'" onblur="consultaActividadBMX(this.id);" onKeyUp="listaActividades(\'actividadBMXID'+nuevaFila+'\');"  /></td>';
				tds += '<td><input  id="descripcionActBMX'+nuevaFila+'" name="descripcionActBMX"  size="80" value="" readOnly="true" type="text" /></td>';
				tds += '<td nowrap="nowrap"><input type="button" name="eliminar" id="'+nuevaFila +'" value=""  tabindex="'+(tabButton = tabButton+1)+'" class="btnElimina" onclick="eliminaActividad(this.id)"/>';
				tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value=""  tabindex="'+(tabButton = tabButton+1)+'" class="btnAgrega"  onclick="agregaActividadBMX()""/></td>';
				tds += '</tr>';
				}

			$("#tablaActividades").append(tds);
			return false;
	 }

	function consultaFilas(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
			totales++;
		});
		return totales;
	}

	function eliminaActividad(control){

		var contador = 0 ;
		var numeroID = control;

		var jqRenglon = eval("'#renglon" + numeroID + "'");
		var jqNumero = eval("'#consecutivoID" + numeroID + "'");
		var jqActividadBMXID = eval("'#actividadBMXID" + numeroID + "'");
		var jqDescripcion=eval("'#descripcionActBMX" + numeroID + "'");
		var jqAgrega=eval("'#agrega" + numeroID + "'");
		var jqElimina = eval("'#" + numeroID + "'");

		// se elimina la fila seleccionada
		$(jqNumero).remove();
		$(jqActividadBMXID).remove();
		$(jqDescripcion).remove();
		$(jqAgrega).remove();
		$(jqRenglon).remove();
		$(jqElimina).remove();

		//Reordenamiento de Controles
		contador = 1;
		var numero= 0;
		$('tr[name=renglon]').each(function() {
			numero= this.id.substr(7,this.id.length);

			var jqRenglon = eval("'#renglon" + numero + "'");
			var jqNumero = eval("'#consecutivoID" + numero + "'");
			var jqActividadBMXID = eval("'#actividadBMXID" + numero + "'");
			var jqDescripcion=eval("'#descripcionActBMX" + numero + "'");
			var jqAgrega=eval("'#agrega" + numero + "'");
			var jqElimina = eval("'#" + numero + "'");


			$(jqNumero).attr('id','consecutivoID'+contador);
			$(jqActividadBMXID).attr('id','actividadBMXID'+contador);
			$(jqDescripcion).attr('id','descripcionActBMX'+contador);
			$(jqAgrega).attr('id','agrega'+ contador);
			$(jqRenglon).attr('id','renglon'+ contador);
			$(jqElimina).attr('id', contador);
			contador = parseInt(contador + 1);
		});
	}

	function listaActividades(idControl){
		var valorControl=document.getElementById(idControl).value;
		lista(idControl, '2', '1','descripcion', valorControl,'listaActividades.htm');
	}

	// funcion de consulta para las actividades BMX
	function consultaActividadBMX(idControl) {
		var jqActividadBMXID = eval("'#" + idControl + "'");
		var sbtrn = (idControl.length);
		var Control = idControl.substr(14, sbtrn);
		setTimeout("$('#cajaLista').hide();", 200);

		var numActividadBMXID = $(jqActividadBMXID).val();
		var descripcion = eval("'#descripcionActBMX" + Control + "'");
		var tipConCompleta = 3;

		esTab = true;
		if (numActividadBMXID != '' && !isNaN(numActividadBMXID)) {
			actividadesServicio.consultaActCompleta(tipConCompleta, numActividadBMXID, function(actividadComp) {
				if (actividadComp != null) {
					$(descripcion).val(actividadComp.descripcionBMX);
				} else {
					mensajeSis("No Existe la Actividad BMX");
					$(jqActividadBMXID).val("");
					$(descripcion).val("");
					$(jqActividadBMXID).focus();
				}
			});
		}
	}


	// Pone la descripcion despues de  que pinta el grid
	function consultaActividad(){
		 setTimeout("$('#cajaLista').hide();", 200);
			var tipConCompleta = 3;
			esTab = true;
		 $('tr[name=renglon]').each(function() {
				var numero= this.id.substr(7,this.id.length);

				var numActividad = $("#actividadBMXID" + numero).val();

					actividadesServicio.consultaActCompleta(tipConCompleta, numActividad, 	{ async: false, callback: function(actividadComp) {
						if (actividadComp != null) {
							$('#descripcionActBMX'+ numero).val(actividadComp.descripcionBMX);
						}
					}
					});
		 });
	}


	//**********   funcion para inicializar combos y multiselect ***** //
	function inicializaCampos(){
		$('#genero').val("0").selected = true;
		$('#estadoCivil').val("0").selected = true;
		$('#monedaSelect').val("").selected = true;
		$("#tipoPagoInt").each(function(){
	        $("#tipoPagoInt option").removeAttr("selected");
	    });
		$('#diasPeriodo').hide();
		$('#lbldiasPeriodo').hide();
		$('#lblpagoIntCal').hide();
		$('#pagoIntCalIgual').attr('checked',true);


	}

	function funcionExito(){
		inicializaForma('formaGenerica','tipoAportacionID');
		inicializaCampos();
		deshabilitaBoton('modifica', 'submit');
		deshabilitaBoton('agrega', 'submit');
		$('#tasaF').attr('checked',true);
		$('#pagoIntCalIgual').attr('checked',true);
		$('#fechaInscripcion').val("");
		mostrarElementoPorClase('tdIncluyeGpo',false);
		deshabilitaControl('tipoReinversion');
	}

	function funcionFallo(){

	}

	function ayuda(){
		var data;

		data = '<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
		'<div id="ContenedorAyuda">'+
		'<legend class="ui-widget ui-widget-header ui-corner-all">Tipo Pago Interés</legend>'+
		'<table id="tablaLista" width="100%" style="margin-top:10px">'+
			'<tr>'+
				'<td colspan="0" id="contenidoAyuda"><b>Parámetro que indica si el Interés que se pagará en cada cuota de la Aportaci&oacute;n será Igual o se pagará por el número de días transcurridos.</b></td>'+
			'</tr>'+
		'</table>'+
		'</div>'+
		'</fieldset>';

		$('#ContenedorAyuda').html(data);

		$.blockUI({
			message : $('#ContenedorAyuda'),
			css : {
				 left: '50%',
				 top: '50%',
				 margin: '-200px 0 0 -200px',
				 border: '0',
				 'background-color': 'transparent'
			}
		});
	   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
	}

// Función que muestra u oculta el campo: Permite Especificar Tasa.
	function validaEspTasa(){
		if($('#anclajeSi').is(':checked')){
			$("#especificaTasaNo").attr('checked', 'checked');
			mensajeSis("Para la Funcionalidad de Anclajes no está permitida la Especificación de Tasa");
			$("#especificaTasaNo").focus();
			$("#trMaxPuntos").hide();
			$("#maxPuntos").val('0');
			$("#trMinPuntos").hide();
			$("#minPuntos").val('0');
		}
		else if( $('#tasaV').is(':checked')){
			$("#especificaTasaNo").attr('checked', 'checked');
			mensajeSis("Para el Cálculo de Interés con Tasa Variable no está permitida la Especificación de Tasa");
			$("#especificaTasaNo").focus();
			$("#trMaxPuntos").hide();
			$("#maxPuntos").val('0');
			$("#trMinPuntos").hide();
			$("#minPuntos").val('0');
		}else {
			$('#trMaxPuntos').show();
			$('#maxPuntos').val('');
			$('#trMinPuntos').show();
			$('#minPuntos').val('');
		}
	}

// función que valida numero decimal y solo permita dos digitos
function validaDigitos(e, idControl){
	  // Backspace = 8, Enter = 13, ’0′ = 48, ’9′ = 57, ‘.’ = 46

        key = e.keyCode ? e.keyCode : e.which;

        if (key == 8) return true;

        if (key > 47 && key < 58) {
          if (document.getElementById(idControl).value === "") return true;
          var existePto = (/[.]/).test(document.getElementById(idControl).value);
          if (existePto === false){
              regexp = /.[0-9]{9}$/;
          }
          else {
            regexp = /.[0-9]{2}$/;
          }

          return !(regexp.test(document.getElementById(idControl).value));
        }

        if (key == 46) {
          if (document.getElementById(idControl).value === "") return false;
          regexp = /^[0-9]+$/;
          return regexp.test(document.getElementById(idControl).value);
        }

        return false;
}

	function muestraIncluyeGpo(idClass,muestra){
		mostrarElementoPorClase(idClass,muestra);
		if(muestra==='N'){
			$('#incluyeGpoFamNo').attr("checked",true);
		}
	}
	function habilitaTasaMGlobal(habilita){
		if(habilita){
			habilitaControl('tasaMontoGlobalSi');
			habilitaControl('tasaMontoGlobalNo');
		} else {
			deshabilitaControl('tasaMontoGlobalSi');
			deshabilitaControl('tasaMontoGlobalNo');
		}
		$('input[name="tasaMontoGlobal"]').change();
	}
