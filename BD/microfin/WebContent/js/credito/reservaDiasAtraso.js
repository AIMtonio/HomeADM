$(document).ready(function() {

	consultaTipoInstitucion();
	$("#tipoInstitucion").focus();
	esTab = true;

	// Definicion de Constantes y Enums
	var catTipoTransDiasAtraso = {
		'agrega' : 1,
		'modifica' : 2
	};
	var cont = 0;
	deshabilitaBoton('grabar', 'submit');

	$(':text').focus(function() {
	 	esTab = false;
	});
	consultaTipoInst();
	$.validator.setDefaults({
		submitHandler: function(event) {
			if (cont > 0 ){
				mensajeSis("Faltan Datos.");
			}else{
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','','Exito','Error');
         }
		}
    });

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#grabar').click(function() {
		cont = 0;
		$('#gridReservas input[type=text]').each(function() {
			if ($(this).val() == ''){
				cont++;
			}
		});
		$('#tipoTransaccion').val(catTipoTransDiasAtraso.agrega);
		creaReservaDiasAtraso();
	});

	$("input[name='clasificacion']").change(function(){
		consultaPlazos();
	});

	$('#formaGenerica').validate({
		rules: {
			tipoInstitucion: {
				required : true
			}
		},
		messages: {
		 	tipoInstitucion: {
				required: 'Seleccione el tipo Institución.'
			}
		}
	});

	// Consulta el tipo de institucion
	function consultaTipoInstitucion() {
		setTimeout("$('#cajaLista').hide();", 200);
		var parametrosSisCon ={
	 		 	'empresaID' : 1
		};
		parametrosSisServicio.consulta(15,parametrosSisCon, function(institucion) {
			if (institucion != null) {
				$('#tipoInst').val(institucion.tipoInstitID);
			}
		});
	}


	function consultaPlazos(){
		var tipoInstitucion = $('#tipoInstitucion').val();
		var clasificacion   = $("input[name='clasificacion']:checked").val();
		var institucion = $('#tipoInst').val();

		if (tipoInstitucion != '' && clasificacion != '' && clasificacion != undefined){
			var params = {};
			if(institucion == 3 && clasificacion == 'H') {
				params['tipoLista'] = 1;
				params['tipoInstitucion'] = tipoInstitucion;
				params['clasificacion'] = clasificacion;
			}

			if(institucion == 3 && clasificacion != 'H' || institucion != 3) {
				params['tipoLista'] = 2;
				params['tipoInstitucion'] = tipoInstitucion;
				params['clasificacion'] = clasificacion;
			}

			$.post("gridReservaPeriodo.htm", params, function(data){
				if(data.length >0) {
					$('#gridReservas').html(data);
					$('#gridReservas').show();
					habilitaBoton('grabar','submit');
					agregaFormatoMoneda('formaGenerica');
				}else{
					$('#gridReservas').html("");
					$('#gridReservas').show();
					habilitaBoton('grabar','submit');
				}
			});
		}
	}

	function creaReservaDiasAtraso(){
		var contador = 1;
		$('#limInferiores').val("");
		$('#limSuperiores').val("");
		$('#cartSReest').val("");
		$('#cartReest').val("");

		$('input[name=plazoInferior]').each(function() {
			if (contador != 1){
				$('#limInferiores').val($('#limInferiores').val() + ','  + this.value);
			}else{
				$('#limInferiores').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=plazoSuperior]').each(function() {
			if (contador != 1){
				$('#limSuperiores').val($('#limSuperiores').val() + ','  + this.value);
			}else{
				$('#limSuperiores').val(this.value);
			}
			contador = contador + 1;
		});
		$('input[name=porSReest]').each(function() {
			if (contador != 1){
				$('#cartSReest').val($('#cartSReest').val() + ','  + this.value);
			}else{
				$('#cartSReest').val(this.value);
			}
			contador = contador + 1;
		});
		$('input[name=porReest]').each(function() {
			if (contador != 1){
				$('#cartReest').val($('#cartReest').val() + ','  + this.value);
			}else{
				$('#cartReest').val(this.value);
			}
			contador = contador + 1;
		});
	}
	function consultaTipoInst() {
		dwr.util.removeAllOptions('tipoInstitucion');
		dwr.util.addOptions('tipoInstitucion');
		paramsCalificaServicio.listaCombo( 3, function(tipoInst){
			dwr.util.addOptions('tipoInstitucion', tipoInst, 'tipoInstitucion', 'tipoInstitucion');
		});
	}

});

	function Exito(){

	}
	function Error(){

	}



	function ayuda(tipoCartera){
		var data = '';
		var mensaje = '';
		var consumo = 'O';
		var comercial = 'C';
		var vivienda = 'H';
		var tipoInst = $('#tipoInst').val();
        var zonaMarginada = 'Zona Marginada';
		var clasifica   = $("input[name='clasificacion']:checked").val();

		if(tipoCartera == 1 ||  tipoCartera == 2 && tipoInst == 3 && clasifica == consumo){
			mensaje = 'Porcentaje de Estimaciones Preventivas.';
		}

		if(tipoCartera == 1 && tipoInst == 3 && clasifica == vivienda){
			mensaje = 'Porcentaje de Estimaciones Preventivas.';
		}


		if(tipoCartera == 1 && tipoInst == 3 && clasifica == comercial ) {
			mensaje = 'Cartera sana: Cr&eacute;ditos con alta probabilidad de que se podr&aacute;n' +
	 		' recuperar en su totalidad, as&iacute; como cr&eacute;ditos renovados. No incluye cr&eacute;ditos Reestructurados.';
		}

		if(tipoCartera == 2 && tipoInst == 3 && clasifica == comercial) {
			mensaje = 'Cartera emproblemada: Cr&eacute;ditos con alta probabilidad de que no se podr&aacute;n' +
				 		' recuperar en su totalidad, aplica para cr&eacute;ditos Reestructurados.';
		}

		if(tipoCartera == 1 && tipoInst == 3 && clasifica == 'M' || clasifica == 'O') {
			mensaje = 'Cartera sana: Cr&eacute;ditos con alta probabilidad de que se podr&aacute;n' +
	 		' recuperar en su totalidad, No incluye cr&eacute;ditos Renovados o Reestructurados.';
		}

		if(tipoCartera == 2 && tipoInst == 3 && clasifica == 'M' || clasifica == 'O') {
			mensaje = 'Cartera emproblemada: Cr&eacute;ditos con alta probabilidad de que no se podr&aacute;n' +
				 		' recuperar en su totalidad, incluye cr&eacute;ditos Renovados o Reestructurados.';
		}

		if(tipoCartera == 1 && tipoInst != 3){ // cartera sana
			mensaje = 'Cartera sana: Cr&eacute;ditos con alta probabilidad de que se podr&aacute;n' +
	 		' recuperar en su totalidad, No incluye cr&eacute;ditos Renovados o Reestructurados.';
		}

		if(tipoCartera == 2 && tipoInst != 3){ // cartera emproblemada
			mensaje = 'Cartera emproblemada: Cr&eacute;ditos con alta probabilidad de que no se podr&aacute;n' +
				 		' recuperar en su totalidad, incluye cr&eacute;ditos Renovados o Reestructurados.';
		}

		$('#ContenedorAyuda').html('');
		if(tipoInst == 3 && tipoCartera == 1 && clasifica == consumo) {
			data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
				'<legend class="ui-widget ui-widget-header ui-corner-all">Cartera Tipo ' + tipoCartera +'</legend>'+
				'<div id="ContenedorAyuda">'+
				'<table id="tablaLista">'+
					'<tr align="left">'+
						'<td id="contenidoAyuda" align="left">' +
					 '<b>' + mensaje + '</b></td>'+
					'</tr>'+
				'</table> </div>'+
				'</fieldset>';
		}

		if(tipoInst == 3 && tipoCartera == 2 && clasifica == consumo) {
			data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
				'<legend class="ui-widget ui-widget-header ui-corner-all">Cartera Tipo ' + tipoCartera + ' : ' + zonaMarginada +'</legend>'+
				'<div id="ContenedorAyuda">'+
				'<table id="tablaLista">'+
					'<tr align="left">'+
						'<td id="contenidoAyuda" align="left">' +
					 '<b>' + mensaje + '</b></td>'+
					'</tr>'+
				'</table> </div>'+
				'</fieldset>';
		}

		if(tipoInst == 3 && tipoCartera == 1 && clasifica == vivienda) {
			data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
				'<legend class="ui-widget ui-widget-header ui-corner-all">Cartera Vivienda </legend>'+
				'<div id="ContenedorAyuda">'+
				'<table id="tablaLista">'+
					'<tr align="left">'+
						'<td id="contenidoAyuda" align="left">' +
					 '<b>' + mensaje + '</b></td>'+
					'</tr>'+
				'</table> </div>'+
				'</fieldset>';
		}

		if(tipoInst != 3 || tipoInst == 3 && clasifica != vivienda && clasifica != consumo) {
		data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
				'<legend class="ui-widget ui-widget-header ui-corner-all">Cartera Tipo ' + tipoCartera + '</legend>'+
				'<div id="ContenedorAyuda">'+
				'<table id="tablaLista">'+
					'<tr align="left">'+
						'<td id="contenidoAyuda" align="left">' +
					 '<b>' + mensaje + '</b></td>'+
					'</tr>'+
				'</table> </div>'+
				'</fieldset>';

		}
		$('#ContenedorAyuda').html(data);
		$.blockUI({message: $('#ContenedorAyuda'),
					   css: {
	                top:  ($(window).height() - 400) /2 + 'px',
	                left: ($(window).width() - 400) /2 + 'px',
	                width: '400px'
	            } });
	   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
	}