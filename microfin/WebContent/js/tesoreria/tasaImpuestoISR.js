var parametroBean = consultaParametrosSession();
var catTipoTransaccionTasaISR = {
		'actualiza': '1',
		'actResidentesExt':'2'
};

$(document).ready(function() {
	esTab = true;

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});


	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('graba', 'submit');
	mostrarElementoPorClase('tdPaisExt',false)
	$('#tasaImpuestoID').focus();
	agregaFormatoControles('formaGenerica');

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'tasaImpuestoID', 'funcionExito', 'funcionError');
		}
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			tasaImpuestoID: {
				required: true,
			},
			descripcion:  {
				required: true,
				minlength: 5
			},
			nombre:  {
				required: true
			},
			fechaValor:{
				required: true,
			},
			tipoTasa:{
				required: true,
			},
			paisID:{
				required: function() { return $('#paisID').is(":visible");}
			}
		},
		messages: {
			tasaImpuestoID: 'Especifique Tasa ISR.',
			descripcion: {
				required: 'Especifique la Descripción.',
				minlength: 'Mínimo 5 Caracteres.'
			},
			nombre:{
				required: 'Especifique el Nombre.'
			},
			fechaValor:{
				required: 'Especifique la Fecha.'
			},
			tipoTasa:{
				required: 'Especifique el Tipo de Tasa.'
			},
			paisID:{
				required: 'Especifique el País para Residentes en el Extranjero.'
			}
		}
	});

	$('#tasaImpuestoID').blur(function() {
		limpiaCampos();
		consultaTasaISR(this.id);
	});

	$('#tasaImpuestoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombre";
			parametrosLista[0] = $('#tasaImpuestoID').val();
			lista('tasaImpuestoID', '2', '1', camposLista, parametrosLista, 'tasaImpuestoISRLista.htm');
		}
	});

  	$('#paisID').bind('keyup',function(e) {
		lista('paisID', '1', '5', 'nombre', $('#paisID').val(),'listaPaises.htm');
		limpiaValores();
	});

	$('#paisID').blur(function() {
		consultaPais(this.id);
	});

	$('input[name="tipoTasa"]').change(function (event){
		muestraPaisResExt('tdPaisExt',$('input[name=tipoTasa]:checked').val());
	});


	$('#valor').blur(function() {
		if(isNaN($('#valor').val()) && esTab){
			mensajeSis('Sólo números.');
			$('#valor').focus();
			$('#valor').select();
		}
		agregaFormatoControles('formaGenerica');
	});

	$('#valor').bind('keyup',function(e) {
		var valor = $('#valor').val();
		if(e.which == 110 && valor.length == 1){
			$('#valor').val('0.');

		}
	});

	$('#fechaValor').change(function() {
		if($('#fechaValor').val()<=parametroBean.fechaAplicacion){
			mensajeSis('La Fecha no puede ser Menor o Igual a la del Sistema.');
			$('#fechaValor').focus();
			calculaFechaSig();
		}
	});

});

function calculaFechaSig() {
	var varFechaSis = parametroBean.fechaAplicacion;
	var diaSis = varFechaSis.substr(8,2);
	var mesSis = varFechaSis.substr(5,2);
	var anioSis = varFechaSis.substr(0,4);
	var fechaResString = "";
	var mes = "";
	var dia = "";

	var fechaSiguiente = new Date(anioSis, mesSis-1, diaSis);
	fechaSiguiente.setTime( fechaSiguiente.getTime() + 1 * 86400000 );

	if((fechaSiguiente.getMonth()+1) < 10) {
		mes = "0" + (fechaSiguiente.getMonth()+1);
	}else {
		mes  = (fechaSiguiente.getMonth()+1);
	}

	if((fechaSiguiente.getDate()) < 10) {
		dia = "0" + (fechaSiguiente.getDate());
	}else {
		dia  = (fechaSiguiente.getDate());
	}

	fechaResString = (fechaSiguiente.getFullYear()) + "-" + mes +"-" + dia;

	$('#fechaValor').val(fechaResString);
}

function consultaTasaISR(idControl) {
	var jqTasa  = eval("'#" + idControl + "'");
	var tasaISR = $(jqTasa).val();
	var TasaISRBeanCon = {
			'tasaImpuestoID':tasaISR
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if(tasaISR != '' && !isNaN(tasaISR) && esTab){
		habilitaBoton('graba', 'submint');
		tasaImpuestoISRServicio.consulta(1,TasaISRBeanCon ,function(tasaISRBean) {
			if(tasaISRBean!=null){
				dwr.util.setValues(tasaISRBean);
				$('#valorAnt').val(tasaISRBean.valor);
				$('#fechaAnt').val(tasaISRBean.fechaValor);
				calculaFechaSig();

				if(tasaISRBean.fechaValor == '1900-01-01') {
					$('#fechaAnt').val('');
					$('#fechaValor').val('');
				} else {
					$('#fechaAnt').val(tasaISRBean.fechaValor);
				}
				$('input[name="tipoTasa"]').change();
				agregaFormatoControles('formaGenerica');
			}else{
				inicializaForma('formaGenerica','tasaImpuestoID');
				mensajeSis("No Existe la Tasa ISR.");
				deshabilitaBoton('graba', 'submit');
				$('#tasaImpuestoID').focus();
				$('#tasaImpuestoID').select();
			}
		});
	}
}

function funcionExito() {
	limpiaCampos();
	deshabilitaBoton('graba', 'submit');
}

function funcionError() {
}

function limpiaValores() {
	$('#valor').val('');
	$('#fechaValor').val('');
	$('#valorAnt').val('');
	$('#fechaAnt').val('');
}

function limpiaCampos() {
	$('#nombre').val('');
	$('#descripcion').val('');
	limpiaValores();
	$('#tasaNacional').attr("checked",true);
	$('input[name="tipoTasa"]').change();
}

function consultaPais(idControl) {
	try {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 5;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais)) {
			paisesServicio.consultaPaises(conPais, numPais,{callback :function(pais) {
				if (pais != null) {
					if (pais.paisID != pais.paisIDBase) {
						$('#nombrePais').val(pais.nombre);
						$('#valorAnt').val(pais.tasaISR);
						$('#fechaAnt').val(pais.fecha);
						calculaFechaSig();

						if(pais.fecha == '1900-01-01') {
							$('#fechaAnt').val('');
							$('#fechaValor').val('');
						} else {
							$('#fechaAnt').val(pais.fecha);
						}
						agregaFormatoControles('formaGenerica');
					}
				} else {
					mensajeSis("No Existe el País.");
					$(jqPais).focus();
					$(jqPais).val('');
					$('#nombrePais').val('');
					$('#valorAnt').val('0.00');
				}
			}, errorHandler : function(errorString,exception) {
				mensajeSis("No Existe el País.");
				$(jqPais).focus();
				$(jqPais).val('');
				$('#nombrePais').val('');
				$('#valorAnt').val('0.00');
			}});
		}
	} catch (err) {
		mensajeSis(err);
	}
}

function muestraPaisResExt(idClass,tipoTasa){
	var muestraTD = (tipoTasa == 'E' ? true : false);
	mostrarElementoPorClase(idClass,muestraTD);
	if(muestraTD){
		$('#paisID').val('');
		$('#nombrePais').val('');
	}
	$('#tipoTransaccion').val((tipoTasa == 'N' ? catTipoTransaccionTasaISR.actualiza : catTipoTransaccionTasaISR.actResidentesExt));
}