var tipoTransaccion = {
	'alta': 1,
	'modificacion': 2
};

var tipoConsulta = {
	'consultaPrincipal': 1
};

var tipoLista = {
	'listaAyuda': 1
};

var estatusConvenio = "";

$('input:radio[name="manejaVencimiento"]').click(function() {
	if($('input:radio[name="manejaVencimiento"]:checked').val() == "S") {
		habilitaControl('fechaVencimiento');
		agregaFormatoControles('formaGenerica2');
		$('.fechaVencimiento').show();
		$('#fechaVencimiento').val('');
	}else {
		deshabilitaControl('fechaVencimiento');
		$('.fechaVencimiento').hide();
		$('#fechaVencimiento').val('');
	}
});

$('input:radio[name="domiciliacionPagos"]').click(function() {
	if($('input:radio[name="domiciliacionPagos"]:checked').val() == "S") {
		agregaFormatoControles('formaGenerica2');
		habilitaControl('noCuotasCobrar');
		$('.noCuotasCobrar').show();
		$('.manejaQuinquenios').show();
	} else {
		deshabilitaControl('fechaVencimiento');
		$('.manejaQuinquenios').hide();
		$('#fechaVencimiento').val('');
		$('.noCuotasCobrar').hide();
		deshabilitaControl('noCuotasCobrar');
		$('#manejaQuinquenios1').attr('checked', true);
		$("#noCuotasCobrar").val("");
		
	}
});


$('input:radio[name="manejaCapPago"]').click(function() {
	if($('input:radio[name="manejaCapPago"]:checked').val() == "S") {
		agregaFormatoControles('formaGenerica2');
		$('#trformulaCapacidadPag').show();
		$('#formCapPagoRes').val('');
		$('#formCapPago').val('');
		$('#desFormCapPagoRes').val('');
		$('#desFormCapPago').val('');
	} else {
		$('#trformulaCapacidadPag').hide();
		$('#formCapPagoRes').val('');
		$('#formCapPago').val('');
		$('#desFormCapPagoRes').val('');
		$('#desFormCapPago').val('');
	}
});

$('input:radio[name="manejaCalendario"]').click(function() {
	if($('input:radio[name="manejaCalendario"]:checked').val() == "S") {
		agregaFormatoControles('formaGenerica2');
		$('.menejaFechaIniCal').show();
		$('.reportaIncidencia').show();
		$('#manejaCalendario').attr('checked', true);
		$('#manejaFechaIniCal').attr('disabled', false);
		$('#manejaFechaIniCal1').attr('disabled', false);
		$('#manejaFechaIniCal1').attr('checked', true);
		$('#reportaIncidencia').attr('disabled', false);
		$('#reportaIncidencia1').attr('disabled', false);
	} else {
		$('.menejaFechaIniCal').hide();
		$('.reportaIncidencia').hide();
		$('#manejaCalendario1').attr('checked', true);
		$('#manejaFechaIniCal').attr('disabled', true);
		$('#manejaFechaIniCal1').attr('disabled', true);
		$('#manejaFechaIniCal1').attr('checked', true);
		$('#reportaIncidencia').attr('disabled', true);
		$('#reportaIncidencia1').attr('disabled', true);
		$('#reportaIncidencia1').attr('checked', true);
	}
});

$("#fechaRegistro").change(function() {
	if (parametroBean.fechaSucursal != $('#fechaRegistro').val()) {
		mensajeSis('La Fecha de Registro no Puede ser menor o Mayor a la del Sistema');
		$('#fechaRegistro').val(parametroBean.fechaSucursal);
	}
});

$('#estatus').change(function(){

	if (estatusConvenio =="A") {
		if($('#estatus').val()=="V"){
			mensajeSis("El estatus no puede pasar a vencido");
			$('#estatus').focus();
			$('#estatus').val('A');
		}
	}
});

$(document).ready(function() {
	esTab = false;

	deshabilitaControl('fechaRegistro');
	deshabilitaControl('numActualizaciones');

	$('.fechaVencimiento').hide();
	$('#fechaVencimiento').val('');
	$('.manejaQuinquenios').hide();
	$('#trformulaCapacidadPag').hide();
	$('.menejaFechaIniCal').hide();
	$('.reportaIncidencia').hide();
	$('#formCapPagoRes').val('');
	$('#formCapPago').val('');
	$('#desFormCapPagoRes').val('');
	$('#desFormCapPago').val('');
	$('#manejaQuinquenios1').attr('checked', true);
	$('#requiereFolio1').attr('checked', true);
	$('#manejaFechaIniCal1').attr('checked', true);
	$('#reportaIncidencia1').attr('checked', true);
	$('#manejaCalendario1').attr('checked', true);
	$('#cobraComisionApertNo').attr('checked', true);
	$('#cobraMoraNo').attr('checked', true);
	$('#domiciliacionPagos1').attr('checked', true);
	$('#manejaVencimiento1').attr('checked', true);
	$('#manejaCapPagoNo').attr('checked', true);
	$('#institNominaID').focus();

	agregaFormatoControles('formaGenerica2');
	$('#limitaPlazo').hide();
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	$('#fechaProgramada').val(parametroBean.fechaSucursal);
	deshabilitaBoton('grabarConv', 'submit');
	deshabilitaBoton('modificarConv', 'submit');

	$(':text, :button, :submit').focus(function() {
		esTab = false;
	});

	$(':text, :button, :submit').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#grabarConv').click(function() {
		$('#tipoTransaccionConv').val(tipoTransaccion.alta);
	});

	$('#modificarConv').click(function() {
		$('#tipoTransaccionConv').val(tipoTransaccion.modificacion);
	});

	$('#convenioNominaID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if((isNaN($('#convenioNominaID').val()) || $('#convenioNominaID').val() == '')) {
			$('#convenioNominaID').val('');
			$('#formaGenerica2')[0].reset();
			$('#fechaRegistro').val(parametroBean.fechaSucursal);
			$('#fechaProgramada').val(parametroBean.fechaSucursal);
			deshabilitaBoton('grabarConv', 'submit');
			deshabilitaBoton('modificarConv', 'submit');
			habilitaControl('fechaVencimiento');
			habilitaControl('manejaVencimiento');
			habilitaControl('manejaVencimiento1');
			habilitaControl('estatus');
			$("#estatus option[value='A']").removeAttr('disabled');
			$("#estatus option[value='S']").removeAttr('disabled');
			$("#estatus option[value='V']").removeAttr('disabled');
			$("#estatus option[value='I']").removeAttr('disabled');
			$('#limitaPlazo').hide();
			$('#motivoCambioEstatus').hide();
			if (esTab) {
				setTimeout( function() {
					$('#convenioNominaID').focus();
				}, 0);
			}
			$('#manejaQuinquenios1').attr('checked', true);
			$('#trformulaCapacidadPag').show();
			$('#manejaCapPagoNo').attr('checked', true);
			$('#requiereFolio1').attr('checked', true);
			$('#manejaFechaIniCal1').attr('checked', true);
			$('#manejaCalendario1').attr('checked', true);
			$('#domiciliacionPagos1').attr('checked', true);
			$('#manejaVencimiento1').attr('checked', true);
			$('#cobraComisionApertNo').attr('checked', true);
			$('#cobraMoraNo').attr('checked', true);
			$('#formCapPagoRes').val('');
			$('#formCapPago').val('');
			$('#desFormCapPagoRes').val('');
			$('#desFormCapPago').val('');
		} else {
			if ($('#convenioNominaID').val() == 0 && $('#institNominaID').val() != 0 && !isNaN($('#institNominaID').val())) {
				habilitaBoton('grabarConv', 'submit');
				deshabilitaBoton('modificarConv', 'submit');
				agregaFormatoControles('formaGenerica2');
				var convenioNomina = $('#convenioNominaID').val();
				$('#formaGenerica2')[0].reset();
				$('#convenioNominaID').val(convenioNomina);
				$('#fechaRegistro').val(parametroBean.fechaSucursal);
				$('#fechaProgramada').val(parametroBean.fechaSucursal);
				$('#estatus').val('A');
				habilitaControl('descripcion');
				deshabilitaControl('estatus');
				habilitaControl('fechaVencimiento');
				habilitaControl('manejaVencimiento');
				habilitaControl('manejaVencimiento1');
				$('#limitaPlazo').hide();
				$('#motivoCambioEstatus').hide();
				$('#manejaQuinquenios1').attr('checked', true);
				$('#requiereFolio1').attr('checked', true);
				$('#manejaFechaIniCal1').attr('checked', true);
				$('#manejaCalendario1').attr('checked', true);
				$('#reportaIncidencia1').attr('checked', true);
				$('#cobraComisionApertNo').attr('checked', true);
				$('#cobraMoraNo').attr('checked', true);
				$('#domiciliacionPagos1').attr('checked', true);
				$('#manejaVencimiento1').attr('checked', true);
				$('#manejaCapPagoNo').attr('checked', true);
				$('#trformulaCapacidadPag').hide();
				$('#formCapPagoRes').val('');
				$('#formCapPago').val('');
				$('#desFormCapPagoRes').val('');
				$('#desFormCapPago').val('');
			} else {
				funcionConsultaConvenio(this.id);
			}
		}
	});

	$('#convenioNominaID').bind('keyup', function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = 'institNominaID';
		camposLista[1] = 'descripcion';
		parametrosLista[0] = $('#institNominaID').val();
		parametrosLista[1] = $('#convenioNominaID').val();
		lista('convenioNominaID', '2', tipoLista.listaAyuda, camposLista, parametrosLista, 'listaConveniosNomina.htm');
	});

	$('#usuarioID').bind('keyup',function(e){
		lista('usuarioID', '1', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});

	$('#usuarioID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if((isNaN($('#usuarioID').val()) || $('#usuarioID').val() == '')) {
			$('#usuarioID').val('');
			if (esTab) {
				setTimeout( function() {
					$('#usuarioID').focus();
				}, 0);
			}
		} else {
			consultaUsuario(this.id);
		}
	});

	$('#fechaVencimiento').change(function() {
		var Xfecha = $('#fechaVencimiento').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha == '')$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			var Yfecha = parametroBean.fechaSucursal;
			if (!mayor(Xfecha, Yfecha) && Xfecha != Yfecha){
				mensajeSis("La fecha de vencimiento es menor que la fecha de sistema");
				$('#fechaVencimiento').val(parametroBean.fechaSucursal);
				$('#fechaVencimiento').focus();
			}
		}else{
			$('#fechaVencimiento').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaProgramada').change(function() {
		var Xfecha = $('#fechaProgramada').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha == '')$('#fechaProgramada').val(parametroBean.fechaSucursal);
			var Yfecha = parametroBean.fechaSucursal;
			if (!mayor(Xfecha, Yfecha) && Xfecha != Yfecha){
				mensajeSis("La fecha programada es menor que la fecha de sistema");
				$('#fechaProgramada').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaProgramada').val(parametroBean.fechaSucursal);
		}
	});

	$('#formaGenerica2 textarea').keypress(function(event) {
		if (event.which == 13) {
			event.preventDefault();
			var posicion = this.selectionStart;
			var tamanioCadena = this.length;
			var inicioCadena = this.value.substring(0, posicion);
			var finCadena = this.value.substring(posicion, tamanioCadena);
			this.value = inicioCadena + "\n" + finCadena;
			$(this).asignaPosicion(posicion + 1);
		}
	});

	$(':text, :button, :submit, textarea').blur(function() {
		if($(this).attr('id') == $('#formaGenerica2 :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout( function() {
				$('#convenioNominaID').focus();
			}, 0);
		}
	});


	$('#estatus').change(function() {
		if($('#estatus option:selected').val() == $('#estatusActual').val() && $('#estatusActual').val() != '') {
			$('#motivoCambioEstatus').hide();
		} else {
			$('#motivoCambioEstatus').show();
		}
	});

	$('#agregarFormCap').click(function() {
		$('#formCapPago').val('');
		$('#desFormCapPago').val('');
		crearFormula('agregarFormCap');
	});

	$('#agregarFormCapRes').click(function() {
		$('#formCapPagoRes').val('');
		$('#desFormCapPagoRes').val('');
		crearFormula('agregarFormCapRes');
	});

	$('#correo').blur(function(){
		if($('#correo').val()!= ''){
			var valor = $('#correo').val(); 
			if(!validarEmail(valor)){
				mensajeSis('Correo no valido');
				$('#correo').focus();
			}
		}
	});	
	
	$('#correoEjecutivo').blur(function(){
		if($('#correoEjecutivo').val()!= ''){
			var valor = $('#correoEjecutivo').val(); 
			if(!validarEmail(valor)){
				mensajeSis('Correo Ejecutivo no valido');
				$('#correoEjecutivo').focus();
			}
		}
		
	});	
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			habilitaControl('manejaFechaIniCal1');
			habilitaControl('manejaFechaIniCal');
			habilitaControl('manejaCapPago1');
			habilitaControl('manejaCapPago');
			$('#empresaNomina').val($('#institNominaID').val());
			deshabilitaBoton('grabarConv', 'submit');
			deshabilitaBoton('modificarConv', 'submit');
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje', 'true', 'convenioNominaID', 'funcionExito', 'funcionError');
		}
	});

	$('#formaGenerica2').validate({
		rules: {
			convenioNominaID: {
				required: true
			},
			descripcion: {
				required: true
			},
			fechaRegistro: {
				required: true
			},
			manejaVencimiento: {
				required: true
			},
			fechaVencimiento: {
				required: function () {
					return($('#manejaVencimiento').is(':checked'));
				}
			},
			domiciliacionPagos: {
				required: true
			},
			estatus: {
				required: true
			},
			usuarioID: {
				required: true
			},
			correoEjecutivo: {
				required: function () {
					return($('#manejaVencimiento').is(':checked'));
				}
			},
			resguardo :{
				number : true
			},
			noCuotasCobrar: {
				required: $('input:radio[name="domiciliacionPagos"]:checked').val() == 'S',
				digits: true,
				min: 0
			},
			cobraComisionApert: {
				required : true
			},
			cobraMora: {
				required : true
			}
			
		}, messages: {
			convenioNominaID: {
				required:'Especifique número de convenio'
			},
			descripcion: {
				required:'Especifique descripción'
			},
			fechaRegistro: {
				required:'Especifique la fecha de registro'
			},
			manejaVencimiento: {
				required:'Especifique si se maneja vencimiento'
			},
			fechaVencimiento: {
				required:'Especifique fecha de vencimiento'
			},
			domiciliacionPagos: {
				required:'Especifique si se domicilian pagos'
			},
			estatus: {
				required:'Especifique estatus'
			},
			usuarioID: {
				required:'Especifique ejecutivo'
			},
			motivoAdicional: {
				required:'Especifique motivo de cambio de estatus'
			},
			correoEjecutivo :{
				required:'Especifique el correo'
			},
			resguardo:{
				number : 'Solo números'
			},
			noCuotasCobrar: {
				required:'Especifique número de cuotas',
				digits: 'Sólo números enteros',
				min: 'Especifique valor mayor o igual que cero'
			},
			cobraComisionApert: {
				required:'Especifique si se cobra comisión por apertura'
			},
			cobraMora: {
				required:'Especifique si se cobra interés moratorio'
			}
		}
	});
});

function funcionConsultaConvenio(idControl) {
	var jqConvenio = eval("'#" + idControl + "'");
	var convenioBean = {
		'convenioNominaID': $(jqConvenio).val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if($(jqConvenio).val() != '' && !isNaN($(jqConvenio).val()) && $(jqConvenio).val() != 0){
		conveniosNominaServicio.consulta(tipoConsulta.consultaPrincipal, convenioBean, function(convenio) {
			if(convenio != null && convenio.institNominaID == $('#institNominaID').val()) {
				$('#claveConvenio').val(convenio.claveConvenio);
				$('#comentario').val(convenio.comentario);
				$('#convenioNominaID').val(convenio.convenioNominaID);
				$('#correoEjecutivo').val(convenio.correoEjecutivo);
				$('#descripcion').val(convenio.descripcion);
				$('#estatus').val(convenio.estatus);
				$('#fechaRegistro').val(convenio.fechaRegistro);
				$('#nombreCompleto').val(convenio.nombreCompleto);
				$('#numActualizaciones').val(convenio.numActualizaciones);
				$('#resguardo').val(convenio.resguardo);
				$('#usuarioID').val(convenio.usuarioID	);
				estatusConvenio= convenio.estatus;
				$('#noCuotasCobrar').val(convenio.noCuotasCobrar);

				if(convenio.manejaCalendario=="S") {
					$('.menejaFechaIniCal').show();
					$('.reportaIncidencia').show();
					$('#manejaCalendario').attr('checked', true);
					$('#manejaFechaIniCal').attr('disabled', false);
					$('#manejaFechaIniCal1').attr('disabled', false);
					$('#reportaIncidencia').attr('disabled', false);
					$('#reportaIncidencia1').attr('disabled', false);
				}else{
					$('.menejaFechaIniCal').hide();
					$('.reportaIncidencia').hide();
					$('#manejaCalendario1').attr('checked', true);
					$('#manejaFechaIniCal').attr('disabled', true);
					$('#manejaFechaIniCal1').attr('disabled', true);
					$('#reportaIncidencia').attr('disabled', true);
					$('#reportaIncidencia1').attr('disabled', true);
				}
				if(convenio.manejaCapPago=="S") {
					$('#manejaCapPagoSi').attr('checked', true);
					$('#trformulaCapacidadPag').show();
					$('#formCapPagoRes').val(convenio.formCapPagoRes);
					$('#desFormCapPagoRes').val(convenio.desFormCapPagoRes);
					$('#formCapPago').val(convenio.formCapPago);
					$('#desFormCapPago').val(convenio.desFormCapPago);
				}else{
					$('#manejaCapPagoNo').attr('checked', true);
					$('#trformulaCapacidadPag').hide();
					$('#formCapPagoRes').val('');
					$('#formCapPago').val('');
					$('#desFormCapPagoRes').val('');
					$('#desFormCapPago').val('');
				}
				if(convenio.manejaFechaIniCal=="S") {
					$('#manejaFechaIniCal').attr('checked', true);
				}else{
					$('#manejaFechaIniCal1').attr('checked', true);
				}
				if(convenio.reportaIncidencia=='S'){
					$('#reportaIncidencia').attr('checked', true);
				}else{
					$('#reportaIncidencia1').attr('checked', true);
				}

				if(convenio.cobraComisionApert=="S") {
					$('#cobraComisionApertSi').attr('checked', true);
				}else{
					$('#cobraComisionApertNo').attr('checked', true);
				}
				if(convenio.cobraMora=="S") {
					$('#cobraMoraSi').attr('checked', true);
				}else{
					$('#cobraMoraNo').attr('checked', true);
				}
				if(convenio.manejaVencimiento=="S") {
					$('#manejaVencimiento').attr('checked', true);
					$('.fechaVencimiento').show();
					$('#fechaVencimiento').val(convenio.fechaVencimiento );
				}else{
					$('#manejaVencimiento1').attr('checked', true);
					$('.fechaVencimiento').hide();
					$('#fechaVencimiento').val('');
				}

				if(convenio.domiciliacionPagos=="S") {
					$('#domiciliacionPagos').attr('checked', true);
					$('#domiciliacionPagos').val(convenio.domiciliacionPagos);
					$('.manejaQuinquenios').show();
					$('.noCuotasCobrar').show();					
				}else{
					$('#domiciliacionPagos1').attr('checked', true);
					$('.manejaQuinquenios').hide();
					$('.noCuotasCobrar').hide();

				}
				if(convenio.manejaQuinquenios=="S"){
					$('#manejaQuinquenios').attr('checked', true);
				}else{
					$('#manejaQuinquenios1').attr('checked', true);
				}


				if(convenio.requiereFolio=="S") {
				    $('#requiereFolio').attr('checked', true);
				}else{
				    $('#requiereFolio1').attr('checked', true);
				}

				habilitaBoton('modificarConv', 'submit');
				deshabilitaBoton('grabarConv', 'submit');
				}
			else {
				mensajeSis('El convenio no existe o no esta relacionado con la empresa especificada');
				var convenioNomina = $('#convenioNominaID').val();
				$('#formaGenerica2')[0].reset();
				$('#convenioNominaID').val(convenioNomina);
				$('#fechaRegistro').val(parametroBean.fechaSucursal);
				$('#fechaProgramada').val(parametroBean.fechaSucursal);
				deshabilitaBoton('grabarConv', 'submit');
				deshabilitaBoton('modificarConv', 'submit');
				agregaFormatoControles('formaGenerica2');
				habilitaControl('estatus');
				$("#estatus option[value='A']").removeAttr('disabled');
				$("#estatus option[value='S']").removeAttr('disabled');
				$("#estatus option[value='V']").removeAttr('disabled');
				$("#estatus option[value='I']").removeAttr('disabled');
				$('#convenioNominaID').focus();
				$('#descripcion').val('');

			}
		});
	}
}

function consultaUsuario(idControl) {
	var jqUsuario = eval("'#" + idControl + "'");
	var numUsuario = $(jqUsuario).val();
	var conUsuario = 2;
	var usuarioBeanCon = {
		'usuarioID': numUsuario
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numUsuario != '' && !isNaN(numUsuario)){
		usuarioServicio.consulta(conUsuario, usuarioBeanCon, function(usuario) {
			if(usuario != null) {
				$('#nombreCompleto').val(usuario.nombreCompleto);
			} else {
				mensajeSis("El usuario no existe");
				$('#nombreCompleto').val('');
				setTimeout(function() {
					$('#usuarioID').focus();
				}, 0);
			}
		});
	}
}

function esFechaValida(str) {
	var regEx = /^\d{4}-\d{2}-\d{2}$/;
	if(!str.match(regEx)) return false;  // Formato Invalido
	var d = new Date(str);
	if(!d.getTime() && d.getTime() !== 0) return false; // Fecha Invalida
	return d.toISOString().slice(0,10) === str;
}

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

$.fn.asignaPosicion = function(pos) {
	this.each(function(index, elem) {
	if (elem.setSelectionRange) {
			elem.setSelectionRange(pos, pos);
		} else if (elem.createTextRange) {
			var range = elem.createTextRange();
			range.collapse(true);
			range.moveEnd('character', pos);
			range.moveStart('character', pos);
			range.select();
		}
	});
	return this;
};

function funcionExito() {
	deshabilitaControl('manejaFechaIniCal1');
	deshabilitaControl('manejaFechaIniCal');
	$('#formaGenerica2')[0].reset();
	$('#convenioNominaID').val($('#consecutivo').val());
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	$('#fechaProgramada').val(parametroBean.fechaSucursal);
	agregaFormatoControles('formaGenerica2');
	habilitaControl('estatus');
	habilitaControl('fechaVencimiento');
	$("#estatus option[value='A']").removeAttr('disabled');
	$("#estatus option[value='S']").removeAttr('disabled');
	$("#estatus option[value='V']").removeAttr('disabled');
	$("#estatus option[value='I']").removeAttr('disabled');
	$('#limitaPlazo').hide();
	$('#motivoCambioEstatus').hide();
	$('#trformulaCapacidadPag').hide();
	$('#formCapPagoRes').val('');
	$('#formCapPago').val('');
	$('#desFormCapPagoRes').val('');
	$('#desFormCapPago').val('');
	$('#manejaCapPagoNo').attr('checked', true);
}

function funcionError() {
	deshabilitaControl('manejaFechaIniCal1');
	deshabilitaControl('manejaFechaIniCal');
	if($('#tipoTransaccionConv').val() == tipoTransaccion.alta) {
		habilitaBoton('grabarConv', 'submit');
	}
	if($('#tipoTransaccionConv').val() == tipoTransaccion.modificacion) {
		habilitaBoton('modificarConv', 'submit');
	}
}

	// FUNCION PARA CREAR FORMULA DE CAPACIDAD DE PAGO
	function crearFormula(control) {
		var url ="crearFormulaClavePresupVista.htm?control=" + control;
		var	posicionIzquierda = (screen.width) ? (screen.width-850)/2 : 0;
		var	posicionArriba = (screen.height) ? (screen.height-500)/2 : 0;
		ventanaArchivo = window.open(url,"PopUpSubirArchivo","width=1200,height=850,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
										"left="+posicionIzquierda+
										",top="+posicionArriba+
										",screenX="+posicionIzquierda+
										",screenY="+posicionArriba);
	}
	
	// FUNCION PARA OBTENER LOS DATOS DE LA FORMULA EN EL MENSAGE DE EXITO
	function resultadoFormula(resultadoFormulaBean) {
		if(resultadoFormulaBean != null) {
			if(resultadoFormulaBean.numeroMensaje == 0 && resultadoFormulaBean.nombreControl == 'agregarFormCap') {
				$('#formCapPago').val(resultadoFormulaBean.formula);
				$('#desFormCapPago').val(resultadoFormulaBean.desFormula);
			}
			
			if(resultadoFormulaBean.numeroMensaje == 0 && resultadoFormulaBean.nombreControl == 'agregarFormCapRes') {
				$('#formCapPagoRes').val(resultadoFormulaBean.formula);
				$('#desFormCapPagoRes').val(resultadoFormulaBean.desFormula);
			}
		}
}

function validarEmail(valor) {
	  var expresion =  /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
	  if (expresion.test(valor)){
		return  true;
	  } else {
	   return  false;
	  }
}

function funcionLimpiaConvenio() {
	deshabilitaControl('manejaFechaIniCal1');
	deshabilitaControl('manejaFechaIniCal');
	$('#formaGenerica2')[0].reset();
	$('#convenioNominaID').val('');
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	$('#fechaProgramada').val(parametroBean.fechaSucursal);
	agregaFormatoControles('formaGenerica2');
	habilitaControl('estatus');
	habilitaControl('fechaVencimiento');
	$("#estatus option[value='A']").removeAttr('disabled');
	$("#estatus option[value='S']").removeAttr('disabled');
	$("#estatus option[value='V']").removeAttr('disabled');
	$("#estatus option[value='I']").removeAttr('disabled');
	$('#limitaPlazo').hide();
	$('#motivoCambioEstatus').hide();
	$('#trformulaCapacidadPag').hide();
	$('#formCapPagoRes').val('');
	$('#formCapPago').val('');
	$('#desFormCapPagoRes').val('');
	$('#desFormCapPago').val('');
	$('#manejaCapPagoNo').attr('checked', true);
	deshabilitaBoton('grabarConv', 'submit');
	deshabilitaBoton('modificarConv', 'submit');
}