var parametroBean = consultaParametrosSession();

var tipoTransaccion = {
		'pagosNoReconocidos' : 1,
		'individual' : 2
};

var tipoConsulta = {
		'consultaPrincipal' : 1,
		'consultaCredito' : 51
};

var tipoLista = {
		'listaGrid' : 1,
		'listaCombo' : 2,
		'listaAyuda' : 61
};

var cobraIva = '';
var parametroBean = consultaParametrosSession();
var ivaMonto = 0;
var banderaIva = false;

$(document).ready(function() {

	agregaFormatoControles('formaGenerica');
	limpiaCampos();
	llenaComboTipos();
	$('#creditoID').focus();

	$(':text, :button, :submit, select').focus(function() {
		esTab = false;
	});

	$(':text, :button, :submit, select').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text, :button, :submit, textarea, select').blur(function() {
		if($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout( function() {
				$('#formaGenerica :input:enabled:visible:first').focus();
			}, 0);
		}
	});

	$.validator.prototype.checkForm = function() {
		// Reemplaza la funcion checkForm de jQuery para validar varios campos con el mismo valor en el atributo 'name'
		this.prepareForm();
		for (var i = 0, elements = (this.currentElements = this.elements()); elements[i]; i++) {
			if (this.findByName(elements[i].name).length !== undefined && this.findByName(elements[i].name).length > 1) {
				for (var cnt = 0; cnt < this.findByName(elements[i].name).length; cnt++) {
					this.check(this.findByName(elements[i].name)[cnt]);
				}
			} else {
				this.check(elements[i]);
			}
		}
		return this.valid();
	};

    $('#creditoID').bind('keyup',function(e){
		lista('creditoID', '2', tipoLista.listaAyuda, 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});

	$('#creditoID').blur(function() {
		consultaCredito(this.id);
	});

	$('#monto').blur(function() {
		calculaIvaMonto();
	});

	$('#amortizacionID').blur(function() {
		consultaAmortizacion();
	});

	$('#tipoNotaCargoID').change(function() {
		var tipoNotaCargoID = $('#tipoNotaCargoID').val();
		var creditoID = $('#creditoID').val();
		$('#tipoTransaccion').val('');

		if (tipoNotaCargoID == "1" && creditoID != "" && creditoID != "0" && !isNaN(creditoID)){
			listaGridAmor();
			$('#tipoTransaccion').val(tipoTransaccion.pagosNoReconocidos);
		} else {
			$('#formaTabla').hide();
			habilitaControl('monto');
			$('#amortizacionID').val('');
			$('#monto').val('');
			$('#iva').val('');
			$('#tipoTransaccion').val(tipoTransaccion.individual);
		}
		consultaCobroIvaTipoNota();
		asignaTabIndex();
	});

//------------ Validaciones de la Forma -------------------------------------
	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'controlEquis', 'funcionExito', 'funcionFallo');
		}
	});

	$('#formaGenerica').validate({
		rules: {
			creditoID : {
				required : true
			},
			tipoNotaCargoID : {
				required : true
			},
			monto : {
				required : true
			},
			amortizacionID : {
				required : true
			},
			motivo : {
				required : true
			}
		},
		messages: {
			creditoID : {
				required : 'Especifique el Crédito'
			},
			tipoNotaCargoID : {
				required : 'Especifique el Tipo de Nota de Cargo'
			},
			monto : {
				required : 'Especifique el Monto'
			},
			amortizacionID : {
				required : 'Especifique la Amortizacion'
			},
			motivo : {
				required : 'Especifique el Motivol'
			}
		}
	});

}); // document ready

function consultaCredito(idControl){
	limpiaCampos();
	var jqCredito = eval("'#" + idControl + "'");
	var numCredito = $(jqCredito).val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numCredito != '' && !isNaN(numCredito) && esTab){
		var creditoBeanCon = {
				'creditoID':numCredito
		};
		creditosServicio.consulta(tipoConsulta.consultaCredito, creditoBeanCon, function(credito){
			if(credito != null){
				esTab=true;

				if (credito.estatus != 'V' && credito.estatus != 'B'){
					mensajeSis("El crédito se encuentra en un estatus inválido.");
					return;
				}

				if (credito.esAgropecuario == 'S'){
					mensajeSis("El crédito es agropecuario.");
					return;
				}

				if (parseInt(credito.grupoID) > 0){
					mensajeSis("El crédito es grupal.");
					return;
				}

				if (parseInt(credito.lineaCreditoID) > 0){
					mensajeSis("El crédito pertenece a una línea de crédito.");
					return;
				}

				if (credito.domiciliacionPagos == 'N'){
					mensajeSis("El crédito de nómina no es domiciliado.");
					return;
				}

				$('#creditoID').val(credito.creditoID);
				$('#clienteID').val(credito.clienteID);
				$('#nombreCompleto').val(credito.nombreCompleto);
				habilitaBoton('aplicar', 'submit');
				asignaTabIndex();
			}else{
				mensajeSis("El crédito no existe.");
				$('#creditoID').focus();
			}
		});
	}
}

function llenaComboTipos(){

	tiposNotasCargoServicio.lista(tipoLista.listaCombo, function(resultado) {
		if (resultado != null && resultado.length > 0) {
			dwr.util.removeAllOptions('tipoNotaCargoID');
			dwr.util.addOptions('tipoNotaCargoID', {'':'SELECCIONAR'});
			dwr.util.addOptions('tipoNotaCargoID', resultado, 'tipoNotaCargoID', 'nombreCorto');
		}else{
			dwr.util.removeAllOptions('tipoNotaCargoID');
			dwr.util.addOptions('tipoNotaCargoID', {'':'NO SE ENCONTRARON RESULTADOS'});
		}
	});
}

function listaGridAmor() {
	var params = {};
	params['tipoLista'] = tipoLista.listaGrid;
	params['creditoID'] = $('#creditoID').val();
	bloquearPantallaCarga();
	$.post("notasCargoGrid.htm", params, function(data) {
		if(data.length > 0) {
			$('#formaTabla').html(data);
			$('#formaTabla').show();
			soloLecturaControl('monto');
			$('#amortizacionID').val('');
			$('#monto').val(0);
			$('#iva').val(0);
		} else {
			mensajeSis("Error al generar la lista");
			$('#formaTabla').hide();
		}
		$('#contenedorForma').unblock();
		asignaTabIndex();
		// reasignarTabIndex();
	}).fail(function() {
		mensajeSis("Error al generar el grid");
		$('#formaTabla').hide();
	});
}

function consultaAmortizacion() {
	var amortizacionID = $('#amortizacionID').val();
	var creditoID = $('#creditoID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(isNaN(amortizacionID) || amortizacionID == '' || isNaN(creditoID) || creditoID == '') {
		$('#amortizacionID').val('');
	} else {
		var notaCargoBean = {
			'amortizacionID': amortizacionID,
			'creditoID': creditoID
		};

		notasCargoServicio.consulta(tipoConsulta.consultaPrincipal, notaCargoBean, function(objResultado) {
			if(objResultado != null){

				if (objResultado.estatus != 'V' && objResultado.estatus != 'B' && objResultado.estatus != 'A'){
					mensajeSis("La amortización no se encuentra en un estatus válido para aplicar una nota de cargo.");
					$('#amortizacionID').val('');
					$('#amortizacionID').focus();
					return;
				}

				$('#amortizacioID').val(objResultado.amortizacionID);

			}else{
				mensajeSis('La amortización indicada no existe.');
				$('#amortizacionID').focus();
			}
		});
	}
}

function consultaCobroIvaTipoNota() {
	var tipoNotaID = $('#tipoNotaCargoID option:selected').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(isNaN(tipoNotaID) || tipoNotaID == '') {
		$('#tipoNotaCargoID').val('');
	} else {
		var tipoNotaBean = {
			'tipoNotaCargoID': tipoNotaID
		};

		tiposNotasCargoServicio.consulta(tipoConsulta.consultaPrincipal, tipoNotaBean, function(objResultado) {
			if(objResultado != null){
				cobraIva = objResultado.cobraIVA;
			}else{
				mensajeSis('El Tipo de Notas de Cargo no existe.');
				$('#tipoNotaCargoID').focus();
			}
		});
	}
}

async function calculaIvaMonto() {
	banderaIva = false;
	quitaFormatoControles('formaGenerica');
	var montoNota = $('#monto').val();
	agregaFormatoControles('formaGenerica');
	ivaMonto = 0;
	if (cobraIva != '' && !isNaN(montoNota) && montoNota != ''){
		if (cobraIva == 'S') {
			calculosyOperacionesDosDecimalesMultiplicacion(montoNota, parametroBean.ivaSucursal);

			while (banderaIva == false){
				await sleep(500);
			}
		}
		$('#iva').val(ivaMonto);
		agregaFormatoControles('formaGenerica');
	}
}

function funcionNota(amortizacionID, totalPago, idFila){
	$('#monto').val(totalPago);
	calculaIvaMonto();
}

function colocaValorCheck(idFila){
	$('input[name=listaCheck]').each(function() {
		var campoCheck = eval("'#" + this.id + "'");
		$(campoCheck).val('N');
	});

	if($('#seleccion' + idFila).is(":checked")){
		$('#check' + idFila).val('S');
	} else{
		$('#check' + idFila).val('N');
	}
}

function calculosyOperacionesDosDecimalesMultiplicacion(valor1, valor2) {
	if (valor1 != '' && valor2 != '') {
		var calcOperBean = {
				'valorUnoA' : valor1,
				'valorDosA' : valor2,
				'valorUnoB' : 0,
				'valorDosB' : 0,
				'numeroDecimales' : 2
		};
		calculosyOperacionesServicio.calculosYOperaciones(tipoConsulta.consultaPrincipal, calcOperBean, function(objResultado) {
			banderaIva = true;
			if (objResultado != null) {
				ivaMonto = objResultado.resultadoDosDecimales;
			}
		});
	}
}

function bloquearPantallaCarga() {
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
		message : $('#mensaje').css({top: "84px", position:'absolute'}),
		css : {
			border : 'none',
			background : 'none'
		}
	});
}

function asignaTabIndex() {
	$(":input:enabled:not(:hidden)").each(function(i) {
		$(this).attr('tabindex', i + 1);
	});
}

function limpiaCampos(){
	$('#clienteID').val('');
	$('#nombreCompleto').val('');
	$('#tipoNotaCargoID').val('');
	$('#monto').val('');
	$('#amortizacionID').val('');
	$('#iva').val('');
	$('#motivo').val('');
	$('#tipoTransaccion').val('');
	$('#formaTabla').hide();
	cobraIva = '';
	deshabilitaBoton('aplicar', 'submit');
	asignaTabIndex();
}

function sleep(ms) {
	return new Promise(resolve => setTimeout(resolve, ms));
}

function funcionExito() {
	limpiaCampos();
	$('#creditoID').focus();
}

function funcionFallo() {}