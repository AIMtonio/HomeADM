$(document).ready(function() {

	iniciaFormaProdAccesorio();
	cargaAccesorios();

	esTab = true;
	$("#producCreditoID").focus();

	$('#producCreditoID').bind('keyup',function(e){
		lista('producCreditoID', '2', '15', 'descripcion', $('#producCreditoID').val(), 'listaProductosCredito.htm');
	});

	$('#producCreditoID').blur(function(){
		funcionLimpiarEsquema();
		validaProductoCredito(this.id);
		agregaFormatoControles('formaGenerica');
	});

	$('#accesorioID').blur(function(){
		funcionLimpiarEsquemaAccesorio();
		if($('#productoCreditoNomina').val()=='S'){
			return;
		}
		validaEsqAccesoriosProd('producCreditoID','accesorioID','institNominaID');
		validaGridEsqAccesorios();
	});

	$('#institNominaID').bind('keyup',function(e){
		lista('institNominaID', '2', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});

	$('#institNominaID').blur(function(){
		funcionLimpiarEsquemaInstiNomina();
		validaEsqAccesoriosProd('producCreditoID','accesorioID','institNominaID');
		validaGridEsqAccesorios();
		validaInstitucionNomina();
		if($('#tipoTransaccion').val()=="1" && $('#tipoPago').val()=='M'){
			if($('#estatusProducCredito').val() == 'I'){
				deshabilitaBoton('grabar', 'submit');
				mensajeSis("El Producto "+$('#descripcion').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
				$('#producCreditoID').focus();
			}else{
				habilitaBoton('grabar', 'submit');
			}
			deshabilitaBoton('modificar','submit');
		}else if($('#tipoTransaccion').val()=="2" && $('#tipoPago').val()=='M'){
			deshabilitaBoton('grabar', 'submit');
			if(getRenglones('tbParametrizacion')=='0'){
				if($('#estatusProducCredito').val() == 'I'){
					deshabilitaBoton('modificar','submit');
					mensajeSis("El Producto "+$('#descripcion').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
					$('#producCreditoID').focus();
				}else{
					habilitaBoton('modificar','submit');
				}
			}else{
				deshabilitaBoton('modificar','submit');
			}
		}else{
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('modificar','submit');
		}
	});

	$('#tipoPago').blur(function(){
		validaBaseCalculo('tipoPago');

		if($('#tipoTransaccion').val()=="1" && $('#tipoPago').val()=='M'){
			if($('#estatusProducCredito').val() == 'I'){
				deshabilitaBoton('grabar', 'submit');
				mensajeSis("El Producto "+$('#descripcion').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
				$('#producCreditoID').focus();
			}else{
				habilitaBoton('grabar', 'submit');
			}
			deshabilitaBoton('modificar','submit');
		}else if($('#tipoTransaccion').val()=="2" && $('#tipoPago').val()=='M'){
			deshabilitaBoton('grabar', 'submit');
			if(getRenglones('tbParametrizacion')=='0'){
				if($('#estatusProducCredito').val() == 'I'){
					deshabilitaBoton('modificar','submit');
					mensajeSis("El Producto "+$('#descripcion').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
					$('#producCreditoID').focus();
				}else{
					habilitaBoton('modificar','submit');
				}
			}else{
				deshabilitaBoton('modificar','submit');
			}
		}else{
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('modificar','submit');
		}
	});

	$('#generaInteres').change(function() {
		if($('#generaInteres').val() == "S") {
			$('.cobraIVAInteresControl').show();
			$('#cobraIVAInteres').attr('disabled', false);
		} else {
			$('#cobraIVAInteres').val('N');
			$('.cobraIVAInteresControl').hide();
			$('#cobraIVAInteres').attr('disabled', true);
		}
	});


	$('#baseCalculo').blur(function(){
		if($('#baseCalculo').val()!=''){

			if($('#tipoTransaccion').val()=="1"){
				if($('#estatusProducCredito').val() == 'I'){
					deshabilitaBoton('grabar', 'submit');
					mensajeSis("El Producto "+$('#descripcion').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
					$('#producCreditoID').focus();
				}else{
					habilitaBoton('grabar', 'submit');
				}
				deshabilitaBoton('modificar','submit');
			}else if($('#tipoTransaccion').val()=="2"){
				deshabilitaBoton('grabar', 'submit');
				if(getRenglones('tbParametrizacion')=='0'){
					if($('#estatusProducCredito').val() == 'I'){
						deshabilitaBoton('modificar','submit');
						mensajeSis("El Producto "+$('#descripcion').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
						$('#producCreditoID').focus();
					}else{
						habilitaBoton('modificar','submit');
					}
				}else{
					deshabilitaBoton('modificar','submit');
				}
			}
		}
	});

	$.validator.setDefaults({submitHandler : function(event) {
		try {
			var campoFocus = '';
			if ($('#tipoTransaccion').val() == '3') {
				campoFocus = 'accesorioID';
			} else {
				campoFocus = 'producCreditoID';
			}
			bloquearPantalla();
			quitaFormatoMoneda('formaGenerica');
			if (validarTabla('tbParametrizacion') && validarParametrizacion('tbParametrizacion')) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', campoFocus, 'exitoGrabaTransaccion', 'errorGrabaTransaccion');
			} else {
				actualizaFormatoMoneda('formaGenerica');
				if (!$('#alertInfo').is(":visible")) {
					desbloquearPantalla();
				}
			}
		} catch (e) {
			mensajeSis("Ah ocurrido un problema al tratar de ejecutar el proceso, disculpe las molestias que esto le ocasiona. <br> " + e);
			actualizaFormatoMoneda('formaGenerica');
		}
	}});

	$('#formaGenerica').validate({
		rules: {
			producCreditoID: 'required',
			accesorioID: 'required',
			cobraIVA : 'required',
			generaInteres: 'required',
			cobraIVAInteres: "required",
			formaCobro : 'required',
			tipoPago : 'required',
			baseCalculo : {
				required: function(){
					if ($('#tipoPago').val()=="P") {
						return 0;
					}else{
						return 1;
					}
				}
			},
			institNominaID : {
				required: function(element){
					return $('#productoCreditoNomina').val()==='S';
				}
			}
		},
		messages: {
			producCreditoID: 'Especifique un Producto de Crédito',
			accesorioID: 'Especifique un Accesorio.',
			cobraIVA : 'Seleccionar si cobra IVA o no',
			generaInteres: 'Selecciona si genera interes o no',
			cobraIVAInteres: "Selecciona si cobre IVA interes",
			formaCobro : 'Seleccionar una forma de pago',
			tipoPago : 'Seleccionar un tipo de pago',
			baseCalculo : 'Seleccionar una base de calculo',
			institNominaID : 'Especifique una Empresa de Nómina'
		}
	});
});

function validaProductoCredito(control) {
	var numProdCredito = $('#producCreditoID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numProdCredito != '' && !isNaN(numProdCredito) && esTab){
		var prodCreditoBeanCon = {
				'producCreditoID':$('#producCreditoID').val()
		};
		productosCreditoServicio.consulta(1,prodCreditoBeanCon,function(prodCred) {
			if(prodCred!=null){
				$('#descripcion').val(prodCred.descripcion);
				$('#estatusProducCredito').val(prodCred.estatus);
				validarProductoCreditoNomina(prodCred);
				inicializaNuevoEsquema();
			}else{
				mensajeSis('El Producto de Crédito no Existe');
				iniciaFormaProdAccesorio();
			}
		});
	}
}

function iniciaFormaProdAccesorio(){
	$('#producCreditoID').focus();
	$('#producCreditoID').val('');
	$('#accesorioID').val('');
	$('#cobroIVA').val('');
	$('#formaCobro').val('');
	$('#tipoPago').val('');
	$('#baseCalculo').val('');
	$('#ldbBaseCalculo').hide();
	$('#baseCalculo').hide();
	$('.cobraIVAInteresControl').hide();
	deshabilitaControl('baseCalculo');
	$('#descripcion').val('');
	$('#rowInstitucionNomina').hide();
	$('#gridEsquemaOtrosAccesorios').html("");
	$('#gridEsquemaOtrosAccesorios').show("");
	$('#estatusProducCredito').val('');
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar','submit');
}

function validaEsqAccesoriosProd(controlProducCre,controlAccesorio, controlInstitNomina){
	var jqProducCre = eval("'#" + controlProducCre + "'");
	var productoCredito = $(jqProducCre).val();

	var jqAccesorio = eval("'#" + controlAccesorio + "'");
	var accesorio = $(jqAccesorio).val();

	var institNomina = 0;
	if($('#productoCreditoNomina').val()=='S'){
		var jqInstitNomina = eval("'#" + controlInstitNomina + "'");
		institNomina = $(jqInstitNomina).val();
	}

	var esqAccesoriosProd = {
		'producCreditoID' : productoCredito,
		'accesorioID' : accesorio,
		'institNominaID' : institNomina
	};

	esquemaOtrosAccesoriosServicio.consulta(1,esqAccesoriosProd,function(esquemaAccesorios){
		if(esquemaAccesorios!=null){
			$('#cobraIVA').val(esquemaAccesorios.cobraIVA);
			$('#formaCobro').val(esquemaAccesorios.formaCobro);
			$('#tipoPago').val(esquemaAccesorios.tipoPago);
			$('#baseCalculo').val(esquemaAccesorios.baseCalculo);
			$('#generaInteres').val(esquemaAccesorios.generaInteres);
			$('#cobraIVAInteres').val(esquemaAccesorios.cobraIVAInteres);

			if (esquemaAccesorios.generaInteres == 'S'){
				$('#cobraIVAInteres').attr('disabled', false);
				$('.cobraIVAInteresControl').show();
			} else {
				$('.cobraIVAInteresControl').hide();
				$('#cobraIVAInteres').attr('disabled', true);
			}

			$('#tipoTransaccion').val('2');
			$('#tipoPago').blur();
		}else{
			inicializaNuevoEsquema();
			$('#tipoTransaccion').val('1');
		}
	});
}

function validarProductoCreditoNomina(productoCredito){
	$('#montoMinimoCredito').val(productoCredito.montoMinimo);
	$('#montoMaximoCredito').val(productoCredito.montoMaximo);

	if(productoCredito.productoNomina == 'S'){
		$('#rowInstitucionNomina').show();
		$('#productoCreditoNomina').val('S');
	}else{
		$('#rowInstitucionNomina').hide();
		$('#productoCreditoNomina').val('N');
	}
}

function validaInstitucionNomina(){
	var institNominaID = $('#institNominaID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(institNominaID != '' && !isNaN(institNominaID) && esTab){
		var institucionNominaBean = {
				'institNominaID' : institNominaID
		};
		institucionNomServicio.consulta(1,institucionNominaBean,function(institucionNominaCreditoBean) {
			if(institucionNominaCreditoBean!=null){
				$('#descripcionInstitucionNomina').val(institucionNominaCreditoBean.nombreInstit);
			}else{
				mensajeSis('La Empresa de Nómina no Existe');
			}
		});
	}
}

function inicializaNuevoEsquema(){
	$('#cobraIVA').val('');
	$('#formaCobro').val('');
	$('#generaInteres').val('');
	$('#tipoPago').val('');
	$('#tipoPago').blur();
	$('#baseCalculo').val('');
	$('.cobraIVAInteresControl').hide();
	$('#gridEsquemaOtrosAccesorios').html("");
	$('#gridEsquemaOtrosAccesorios').hide();
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar','submit');
}

function validaBaseCalculo(controlTipoPago){
	var jqTipoPago = eval("'#" + controlTipoPago + "'");
	var tipoPago = $(jqTipoPago).val();
	if(tipoPago=='P'){
		$('#ldbBaseCalculo').show();
		$('#baseCalculo').show();
		habilitaControl('baseCalculo');
	}else{
		$('#baseCalculo').val('');
		$('#ldbBaseCalculo').hide();
		$('#baseCalculo').hide();
		deshabilitaControl('baseCalculo');
	}
}

function validaGridEsqAccesorios(){
	var institNominaID = 0;
	if($('#productoCreditoNomina').val()=='S'){
		institNominaID = $('#institNominaID').val();
	}

	var esquemaAccesoriosBean = {
			'producCreditoID' : $('#producCreditoID').val(),
			'accesorioID' : $('#accesorioID').val(),
			'institNominaID':institNominaID,
			'tipoLista' : 1
	};

	bloquearPantalla();
	$.post("esquemaOtrosAccesoriosGridVista.htm", esquemaAccesoriosBean, function(data) {
		if($('#tipoTransaccion').val()=="2"){
			$('#gridEsquemaOtrosAccesorios').html(data);
			$('#gridEsquemaOtrosAccesorios').show();

			if($('#productoCreditoNomina').val()==='N'){
				$('#colLblCon').hide("");
				$('#colLblSpa').hide("");

				var idTablaParametrizacion = $('#tbParametrizacion').closest('table').attr('id');
				$('#'+idTablaParametrizacion+' tr').each(function(index){
					var colConvenio = "#"+$(this).find("td[id^='colConvenio"+"']").attr("id");
					var colSpace = "#"+$(this).find("td[id^='colSpace"+"']").attr("id");

					if(colConvenio != null){
						$(colConvenio).hide("");
					}

					if(colSpace != null){
						$(colSpace).hide("");
					}
				});
			}

			if(getRenglones('tbParametrizacion')=='0'){
				deshabilitaBoton('grabarGrid','submit');
			}

			$('input[name=montoPorcentaje]').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});

			$('input[name=montoMin]').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});

			$('input[name=montoMax]').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});
		}
		desbloquearPantalla();
	});
}

/**
 * Agrega un nuevo renglón (detalle) a la tabla del grid.
 * @param idControl : ID de algún campo para obtener el ID de la tabla a la que pertenece.
 */
function agregarAccesorio(idControl){
	//Con la siguiente variable obtiene el nombre de la tabla a Editar para el grid
	var idTablaParametrizacion = $('#'+idControl).closest('table').attr('id');
	var idTab = 'numTab';

	reasignaTabIndex(idTablaParametrizacion);
	//El siguiente if valida si los parametros que contiene la tabla estén completos para poder agregar un valor nuevo
	if(validarTabla(idTablaParametrizacion) && validarParametrizacion(idTablaParametrizacion)){
		var numTab=$("#"+idTab).asNumber(); //Obtiene el tabindex mayor
		var numeroFila=parseInt(getRenglones(idTablaParametrizacion)); //Obtiene el numero actual de renglones

		numTab++;
		numeroFila++;
		var nuevaFila=
		"<tr id=\"tr"+numeroFila+"\" name=\"tr"+"\">"+
			"<td id=\"colConvenio"+numeroFila+"\" nowrap=\"nowrap\">"+
				"<select MULTIPLE id=\"convenioID"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"convenioID"+"\" size=\"11\" onblur=\"asignaTotalConveniosSeleccionados("+numeroFila+",this.id)\" onchange=\"validaSeleccion(this.id)\" />"+
				"<input type=\"hidden\" id=\"numTotalConvenios"+numeroFila+"\" name=\"numTotalConvenios\"/>"+
				"<input type=\"hidden\" id=\"numConveniosSeleccionados"+numeroFila+"\" name=\"numConveniosSeleccionados\" value=\"0\"/>"+
			"</td>"+
			"<td id=\"colSpace"+numeroFila+"\"></td>"+
			"<td nowrap=\"nowrap\">"+
				"<select MULTIPLE id=\"plazoID"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"plazoID"+"\" size=\"11\" onblur=\"asignaTotalPlazosSeleccionados("+numeroFila+",this.id)\" onchange=\"validaSeleccion(this.id)\" />"+
				"<input type=\"hidden\" id=\"numTotalPlazos"+numeroFila+"\" name=\"numTotalPlazos\"/>"+
				"<input type=\"hidden\" id=\"numPlazosSeleccionados"+numeroFila+"\" name=\"numPlazosSeleccionados\" value=\"0\"/>"+
			"</td><td></td>"+
			"<td>"+
				"<input type=\"text\" id=\"cicloIni"+numeroFila+"\" name=\"cicloIni\" tabindex=\""+(numTab)+"\" maxlength=\"10\" onkeypress=\"return validaNumero(event)\" size=\"6\" />"+
			"</td><td></td>"+
			"<td>"+
				"<input type=\"text\" id=\"cicloFin"+numeroFila+"\" name=\"cicloFin\" tabindex=\""+(numTab)+"\" maxlength=\"10\" onkeypress=\"return validaNumero(event)\" size=\"6\" onblur=\"validaCiclo(this.id)\" />"+
			"</td><td></td>"+
			"<td>"+
			"<input type=\"text\" id=\"montoMin"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"montoMin"+"\" size=\"15\" maxlength=\"16\" onkeypress=\"return validaNumero(event)\" style=\"text-align: right;\" onblur=\"formatoTexto(this)\" esMoneda=\"true\" />"+
			"</td><td></td>"+
			"<td>"+
			"<input type=\"text\" id=\"montoMax"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"montoMax"+"\" size=\"15\" maxlength=\"16\" onkeypress=\"return validaNumero(event)\" style=\"text-align: right;\" onblur=\"formatoTexto(this)\" esMoneda=\"true\" />"+
			"</td><td></td>"+
			"<td>"+
				"<input type=\"text\" id=\"montoPorcentaje"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"montoPorcentaje"+"\" size=\"15\" maxlength=\"10\" onkeypress=\"return validaNumero(event)\" style=\"text-align: right;\" onblur=\"formatoTexto(this)\" esMoneda=\"true\" />"+
			"</td><td></td>"+
			"<td>"+
				"<select id=\"nivelID"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"nivelID"+"\"> </select>"+
			"</td><td></td>"+
			"<td nowrap=\"nowrap\">"+
				"<input type=\"button\" id=\"eliminar"+numeroFila+"\"name=\"eliminar"+"\" value=\"\" class=\"btnElimina\" onclick=\"eliminarParam('tr"+numeroFila+"')\" tabindex=\""+(numTab)+"\"/> "+
				"<input type=\"button\" id=\"agrega"+numeroFila+"\" name=\"agrega"+"\" value=\"\" class=\"btnAgrega\" onclick=\"agregarAccesorio(this.id)\" tabindex=\""+(numTab)+"\"/>"+
			"</td>"+
		"</tr>";

		$('#'+idTablaParametrizacion).append(nuevaFila);

		if($('#productoCreditoNomina').val()=='N'){
			$('#colLblCon').hide("");
			$('#colLblSpa').hide("");

			var idTablaParametrizacion = $('#tbParametrizacion').closest('table').attr('id');
			$('#'+idTablaParametrizacion+' tr').each(function(index){
				var colConvenio = "#"+$(this).find("td[id^='colConvenio"+"']").attr("id");
				var colSpace = "#"+$(this).find("td[id^='colSpace"+"']").attr("id");

				if(colConvenio != null){
					$(colConvenio).hide("");
				}

				if(colSpace != null){
					$(colSpace).hide("");
				}
			});
		}

		muestraConvenios(numeroFila,'',[]);
		muestraPlazos(numeroFila,'',[]);
		muestraNiveles(numeroFila,'');
		$("#"+idTab).val(numTab);
		$("#numeroFila").val(numeroFila);
		if($('#estatusProducCredito').val() == 'I'){
		deshabilitaBoton('grabarGrid','submit');
		}else{
			habilitaBoton('grabarGrid','submit');
		}
	}
}

/**
 * Remueve de la tabla un tr.
 * @param id : ID del tr.
 */
function eliminarParam(id){
	$('#'+id).remove();
}

/**
 * Valida si existen parametrizaciones iguales en la tabla
 * @param idControl
 */
function validarParametrizacion(idControl){
	var valido = [];
	var parametrizacion = [];

	$('#'+idControl+' tr').each(function(index){
		if(index>1){
			 remueveFormaErrorRow($(this).attr('id'));
		}
	});

	$('#'+idControl+' tr').each(function(index){
		if(index>1){
			var id = $(this).attr('id');
			var convenioID = "#"+$(this).find("select[name^='convenioID"+"']").attr("id");
			var plazoID = "#"+$(this).find("select[name^='plazoID"+"']").attr("id");
			var cicloIni = "#"+$(this).find("input[name^='cicloIni"+"']").attr("id");
			var cicloFin = "#"+$(this).find("input[name^='cicloFin"+"']").attr("id");
			var montoMin = "#"+$(this).find("input[name^='montoMin"+"']").attr("id");
			var montoMax = "#"+$(this).find("input[name^='montoMax"+"']").attr("id");
			var montoPorcentaje = "#"+$(this).find("input[name^='montoPorcentaje"+"']").attr("id");
			var nivelID = "#"+$(this).find("select[name^='nivelID"+"']").attr("id");

			var conveniosStr = [];
			if($('#productoCreditoNomina').val()=='S' && convenioID != null){
				conveniosStr = $(convenioID).val();
			}

			var plazoStr = $(plazoID).val();
			var cicloIniStr = $(cicloIni).val().trim();
			var cicloFinStr = $(cicloFin).val().trim();
			var montoMinStr = $(montoMin).val().trim().replace(/[^\d.]/g,"");
			var montoMaxStr = $(montoMax).val().trim().replace(/[^\d.]/g,"");
			var montoPorcentajeStr = $(montoPorcentaje).val().trim().replace(/[^\d.]/g,"");
			var nivelStr = $(nivelID).val().trim();

			$('#'+idControl+' tr').each(function(index){
				if(index>1){
					var otherId = $(this).attr('id');
					if (otherId != id) {
						 var otherConvenioID = "#"+$(this).find("select[name^='convenioID"+"']").attr("id");
						 var otherPlazoID = "#"+$(this).find("select[name^='plazoID"+"']").attr("id");
						 var otherCicloIni = "#"+$(this).find("input[name^='cicloIni"+"']").attr("id");
						 var otherCicloFin = "#"+$(this).find("input[name^='cicloFin"+"']").attr("id");
						 var otherMontoMin = "#"+$(this).find("input[name^='montoMin"+"']").attr("id");
						 var otherMontoMax = "#"+$(this).find("input[name^='montoMax"+"']").attr("id");
						 var otherMontoPorcentaje = "#"+$(this).find("input[name^='montoPorcentaje"+"']").attr("id");
						 var otherNivelID = "#"+$(this).find("select[name^='nivelID"+"']").attr("id");

						 var otherConveniosStr = [];
						 if($('#productoCreditoNomina').val()=='S' && otherConvenioID != null){
							 otherConveniosStr = $(otherConvenioID).val();
						 }

						 var otherPlazoStr = $(otherPlazoID).val();
						 var otherCicloIniStr = $(otherCicloIni).val().trim();
						 var otherCicloFinStr = $(otherCicloFin).val().trim();
						 var otherMontoMinStr = $(otherMontoMin).val().trim().replace(/[^\d.]/g,"");
						 var otherMontoMaxStr = $(otherMontoMax).val().trim().replace(/[^\d.]/g,"");
						 var otherMontoPorcentajeStr = $(otherMontoPorcentaje).val().trim().replace(/[^\d.]/g,"");
						 var otherNivelStr = $(otherNivelID).val().trim();

						 parametrizacion.push(validaArrays(conveniosStr,otherConveniosStr));
						 parametrizacion.push(validaArrays(plazoStr,otherPlazoStr));

						 parametrizacion.push(cicloIniStr === otherCicloIniStr);

						 parametrizacion.push(cicloFinStr === otherCicloFinStr);

						 parametrizacion.push(montoMinStr === otherMontoMinStr);

						 parametrizacion.push(montoMaxStr === otherMontoMaxStr);

						 parametrizacion.push(montoPorcentajeStr === otherMontoPorcentajeStr);

						 parametrizacion.push(nivelStr === otherNivelStr);

						 if(validaConfiguracion(parametrizacion)){
							 valido.push(false);
							 parametrizacion = [];
							 agregaFormaErrorRow([id,otherId]);
							 mensajeSis('La parametrización es igual');
							 return;
						 }
						 parametrizacion = [];
					}
				}
			});
		};
	});
	return valido.length>0?false:true;
}

function validaArrays(arr1, arr2) {
	 var bExists = false;
	 if(arr1.length === 0 && arr2.length === 0) return true;
	 $.each(arr2, function(index, value){
		if($.inArray(value,arr1)!=-1)bExists = true;
		if(bExists) return false;
	});
	return bExists;
}

function validaConfiguracion(arr) {
    if(!arr.length) return true;
    return !!arr.reduce(function(a, b){return (a === b)?a:NaN;});
}

function agregaFormaErrorRow(rowsId){
	if(rowsId != null && rowsId.length > 0){
		$.each(rowsId, function(index, rowId){
			var convenioID = "#"+$("#"+rowId).find("select[name^='convenioID"+"']").attr("id");
			var plazoID = "#"+$("#"+rowId).find("select[name^='plazoID"+"']").attr("id");
			var cicloIni = "#"+$("#"+rowId).find("input[name^='cicloIni"+"']").attr("id");
			var cicloFin = "#"+$("#"+rowId).find("input[name^='cicloFin"+"']").attr("id");
			var montoMin = "#"+$("#"+rowId).find("input[name^='montoMin"+"']").attr("id");
			var montoMax = "#"+$("#"+rowId).find("input[name^='montoMax"+"']").attr("id");
			var montoPorcentaje = "#"+$("#"+rowId).find("input[name^='montoPorcentaje"+"']").attr("id");
			var nivelID = "#"+$("#"+rowId).find("select[name^='nivelID"+"']").attr("id");

			if($('#productoCreditoNomina').val() == 'S' && convenioID != null & $(convenioID).val().length > 0){
				agregarFormaError(convenioID);
			}

			agregarFormaError(plazoID);
			agregarFormaError(cicloIni);
			agregarFormaError(cicloFin);
			agregarFormaError(montoMin);
			agregarFormaError(montoMax);
			agregarFormaError(montoPorcentaje);
			agregarFormaError(nivelID);
		});
	}
}

function remueveFormaErrorRow(rowId){
	var convenioID = "#"+$("#"+rowId).find("select[name^='convenioID"+"']").attr("id");
	var plazoID = "#"+$("#"+rowId).find("select[name^='plazoID"+"']").attr("id");
	var cicloIni = "#"+$("#"+rowId).find("input[name^='cicloIni"+"']").attr("id");
	var cicloFin = "#"+$("#"+rowId).find("input[name^='cicloFin"+"']").attr("id");
	var montoMin = "#"+$("#"+rowId).find("input[name^='montoMin"+"']").attr("id");
	var montoMax = "#"+$("#"+rowId).find("input[name^='montoMax"+"']").attr("id");
	var montoPorcentaje = "#"+$("#"+rowId).find("input[name^='montoPorcentaje"+"']").attr("id");
	var nivelID = "#"+$("#"+rowId).find("select[name^='nivelID"+"']").attr("id");

	if(convenioID != null){
		removerFormaError(convenioID);
	}

	removerFormaError(plazoID);
	removerFormaError(cicloIni);
	removerFormaError(cicloFin);
	removerFormaError(montoMin);
	removerFormaError(montoMax);
	removerFormaError(montoPorcentaje);
	removerFormaError(nivelID);
}

function removerFormaError(id){
	$(id).removeClass("error");
}

/**
 * Válida que todos los campos de la tabla sea requeridos correctamente.
 * @param idControl : ID de la tabla a validar.
 * @returns {Boolean}
 */
function validarTabla(idControl){
	var validar = true;

	$('#'+idControl+' tr').each(function(index){
		if(index>1){
			if($('#productoCreditoNomina').val()=='S'){
				var convenioID = "#"+$(this).find("select[name^='convenioID"+"']").attr("id");
				var conveniosStr = $(convenioID).val();

				if(conveniosStr == null || conveniosStr.length===0) {
					agregarFormaError(convenioID);
					validar=false;
				} else {
					var selecteds = [];
			        $.each($(convenioID + " option:selected"), function(){
			        	selecteds.push($(this).val());
			        });

					if((selecteds.length - 1)===0 && selecteds[0]==='0'){
						agregarFormaError(convenioID);
						validar=false;
					}
				}
			}

			var plazoID = "#"+$(this).find("select[name^='plazoID"+"']").attr("id");
			var cicloIni = "#"+$(this).find("input[name^='cicloIni"+"']").attr("id");
			var cicloFin = "#"+$(this).find("input[name^='cicloFin"+"']").attr("id");
			var montoMin = "#"+$(this).find("input[name^='montoMin"+"']").attr("id");
			var montoMax = "#"+$(this).find("input[name^='montoMax"+"']").attr("id");
			var montoPorcentaje = "#"+$(this).find("input[name^='montoPorcentaje"+"']").attr("id");
			var nivelID = "#"+$(this).find("select[name^='nivelID"+"']").attr("id");

			var plazosStr = $(plazoID).val();
			var valorCicloIni = $(cicloIni).val().trim();
			var valorCicloFin = $(cicloFin).val().trim();
			var valorMontoMin = $(montoMin).val().trim().replace(/[^\d.]/g,"");
			var valorMontoMax = $(montoMax).val().trim().replace(/[^\d.]/g,"");
			var montoPorcentajeStr = $(montoPorcentaje).val().trim();
			var nivelStr = $(nivelID).val().trim();

			var valorMontoMinDec = parseFloat(valorMontoMin);
			var valorMontoMaxDec = parseFloat(valorMontoMax);
			var montoMinimoCredito = parseFloat($('#montoMinimoCredito').val());
			var montoMaximoCredito = parseFloat($('#montoMaximoCredito').val());

			if(plazosStr == null || plazosStr.length===0) {
				agregarFormaError(plazoID);
				validar=false;
			} else {
				var selecteds = [];
		        $.each($(plazoID + " option:selected"), function(){
		        	selecteds.push($(this).val());
		        });

				if((selecteds.length - 1)===0 && selecteds[0]==='0'){
					agregarFormaError(plazoID);
					validar=false;
				}
			}

			if(valorCicloIni==='0' || valorCicloIni==='') {
				agregarFormaError(cicloIni);
				validar=false;
			}

			if(valorCicloFin==='0' || valorCicloFin=='') {
				agregarFormaError(cicloFin);
				validar=false;
			}

			if(valorMontoMin==='0.00' || +valorMontoMin <= 0) {
				agregarFormaError(montoMin);
				validar=false;
			} else if(valorMontoMinDec<montoMinimoCredito){
				agregarFormaError(montoMin);
				mensajeSis('El monto mínimo no pueder ser menor a ' + formatoMoneda(montoMinimoCredito.toString()));
				validar=false;
			}

			if(valorMontoMax==='0.00' || +valorMontoMax <= 0) {
				agregarFormaError(montoMax);
				validar=false;
			} else if(valorMontoMaxDec>montoMaximoCredito){
				agregarFormaError(montoMax);
				mensajeSis('El monto máximo no pueder ser mayor a ' + formatoMoneda(montoMaximoCredito.toString()));
				validar=false;
			} else if(valorMontoMaxDec < valorMontoMinDec){
				agregarFormaError(montoMax);
				mensajeSis('El monto máximo no pueder ser menor al monto minimo');
				validar=false;
			}

			if(montoPorcentajeStr==='') {
				agregarFormaError(montoPorcentaje);
				validar=false;
			}

			if(nivelStr == null || nivelStr.length===0) {
				agregarFormaError(nivelID);
				validar=false;
			}
		}
	});
	return validar;
}

/**
 * Cancela las teclas [ ] en el formulario
 * @param e
 * @returns {Boolean}
 */
document.onkeypress = pulsarCorchete;
function pulsarCorchete(e) {
	tecla = (document.all) ? e.keyCode : e.which;
	if (tecla == 91 || tecla == 93) {
		return false;
	}
	return true;
}

/**
 * Regresa el número de renglones de un grid.
 * @param idTablaParametrizacion : ID de la tabla a la que se va a contar el número de renglones.
 * @returns Número de renglones de la tabla.
 */
function getRenglones(idTablaParametrizacion){
	var numRenglones = $('#'+idTablaParametrizacion+' >tbody >tr[name^="tr'+'"]').length;
	return numRenglones;
}

/**
 * Reasigna/actualiza el número de tabindex de los inputs que se encuentran dentro de la tabla.
 * @param idTablaParametrizacion : ID de la tabla a actualizar.
 */
function reasignaTabIndex(idTablaParametrizacion){
	var numInicioTabs = 100;
	var idTab = '';
		idTab = 'numTab';

	$('#'+idTablaParametrizacion+' tr').each(function(index){
		if(index>1){

			var convenioID = "#"+$(this).find("select[name^='convenioID"+"']").attr("id");
			var plazoID = "#"+$(this).find("select[name^='plazoID"+"']").attr("id");
			var cicloIni = "#"+$(this).find("input[name^='cicloIni"+"']").attr("id");
			var cicloFin = "#"+$(this).find("input[name^='cicloFin"+"']").attr("id");
			var montoMin = "#"+$(this).find("input[name^='montoMin"+"']").attr("id");
			var montoMax = "#"+$(this).find("input[name^='montoMax"+"']").attr("id");
			var montoPorcentaje = "#"+$(this).find("input[name^='montoPorcentaje"+"']").attr("id");
			var nivelID = "#"+$(this).find("select[name^='nivelID"+"']").attr("id");
			var agrega = "#"+$(this).find("input[name^='agrega"+"']").attr("id");
			var elimina = "#"+$(this).find("input[name^='eliminar"+"']").attr("id");

			numInicioTabs++;

			if($('#productoCreditoNomina').val()=='S' && convenioID != null){
				$(convenioID).attr('tabindex' , numInicioTabs);
			}

			$(plazoID).attr('tabindex' , numInicioTabs);
			$(cicloIni).attr('tabindex', numInicioTabs);
			$(cicloFin).attr('tabindex',numInicioTabs);
			$(montoMin).attr('tabindex',numInicioTabs);
			$(montoMax).attr('tabindex',numInicioTabs);
			$(montoPorcentaje).attr('tabindex' , numInicioTabs);
			$(nivelID).attr('tabindex' , numInicioTabs);
			$(elimina).attr('tabindex' , numInicioTabs);
			$(agrega).attr('tabindex' , numInicioTabs);
		}
	});
	$('#'+idTab).val(numInicioTabs);
}

function cargaAccesorios(){
	otrosAccesoriosServicio.listaCombo(2, function(ingresos){
		dwr.util.removeAllOptions('accesorioID');
		dwr.util.addOptions('accesorioID', {'':'SELECCIONAR'});
		dwr.util.addOptions('accesorioID', ingresos, 'accesorioID', 'descripcion');
	});
}

function exitoGrabaTransaccion() {
	var jQmensaje = eval("'#ligaCerrar'");
	if ($(jQmensaje).length > 0) {
		mensajeAlert = setInterval(function () {
			if ($(jQmensaje).is(':hidden')) {
				clearInterval(mensajeAlert);
				inicializaNuevoEsquema();
				validaEsqAccesoriosProd('producCreditoID', 'accesorioID', 'institNominaID');
				$('#cobraIVA').focus();
				validaGridEsqAccesorios();
			}
		}, 50);
	}
}

function errorGrabaTransaccion(){
	actualizaFormatoMoneda('formaGenerica');
	desbloquearPantalla();
}

function muestraConvenios(numConvenio,valueConvenio,selecteds){
	if($('#productoCreditoNomina').val()=='S'){
		var convenio = eval("convenioID"+numConvenio);
		var convenioBean = {
			'institNominaID' : $('#institNominaID').val(),
			'descripcion': ''
		};

		dwr.util.removeAllOptions(convenio);
		dwr.util.addOptions(convenio, {'0' : 'TODOS'});
		conveniosNominaServicio.lista(1,convenioBean,{
			async: false,
			callback: function(convenioCreditoBean) {
				dwr.util.addOptions(convenio, convenioCreditoBean, 'convenioNominaID', 'descripcion');
			}
		});

		var jqControl = eval("'#convenioID"+numConvenio+" > option'");
		var totalOpciones = $(jqControl).length - 1;
		$('#numTotalConvenios'+numConvenio).val(totalOpciones);

		var tamanio = selecteds.length;
		for (var i=0;i<tamanio;i++) {
			var con = selecteds[i];

			var jqConvenio = eval("'#convenioID"+numConvenio+" option[value="+con+"]'");
			$(jqConvenio).attr("selected","selected");
		}

		if(totalOpciones > 0 && totalOpciones === tamanio){
			var jqConvenio = eval("'#convenioID"+numConvenio+" option[value=0]'");
			$(jqConvenio).attr("selected","selected");
		}
	}
}

function asignaTotalConveniosSeleccionados(numConvenio,jqIdMulConvenio){
	if($('#productoCreditoNomina').val()=='S'){
		var jqMulConvenio = eval("'#"+jqIdMulConvenio+"'");
		var count = $(jqMulConvenio + " :selected").length;
		$('#numConveniosSeleccionados'+numConvenio).val(count);
	}
}

function muestraPlazos(numPlazo,valuePlazo,selecteds){
	var plazo = eval("plazoID"+numPlazo);
	var plazoBean = {
		'producCreditoID' : $('#producCreditoID').val()
	};

	dwr.util.removeAllOptions(plazo);
	dwr.util.addOptions(plazo, {'0' : 'TODOS'});
	plazosCredServicio.listaComboProducto(5,plazoBean,{
		async: false,
		callback: function(plazoCreditoBean) {
			dwr.util.addOptions(plazo, plazoCreditoBean, 'plazoID', 'descripcion');
		}
	});

	var jqControl = eval("'#plazoID"+numPlazo+" > option'");
	var totalOpciones = $(jqControl).length - 1;
	$('#numTotalPlazos'+numPlazo).val(totalOpciones);

	var tamanio = selecteds.length;
	for (var i=0;i<tamanio;i++) {
		var pla = selecteds[i];

		var jqPlazo = eval("'#plazoID"+numPlazo+" option[value="+pla+"]'");
		$(jqPlazo).attr("selected","selected");
	}

	if(totalOpciones > 0 && totalOpciones === tamanio){
		var jqPlazo = eval("'#plazoID"+numPlazo+" option[value=0]'");
		$(jqPlazo).attr("selected","selected");
	}
}

function asignaTotalPlazosSeleccionados(numPlazo,jqIdMulPlazo){
	var jqMulPlazo = eval("'#"+jqIdMulPlazo+"'");
	var count = $(jqMulPlazo + " :selected").length;
	$('#numPlazosSeleccionados'+numPlazo).val(count);
}

function muestraNiveles(numNivel,valueNivel){
	var nivel = eval("nivelID"+numNivel);
	var beanCon = {
			'nivelID' : 0
		};
	var tipoCon = 2;

	dwr.util.removeAllOptions(nivel);
	dwr.util.addOptions(nivel, {'0' : 'SELECCIONAR'});
	nivelCreditoServicio.listaCombo(tipoCon,beanCon, {
		async: false,
		callback: function(bean) {
			dwr.util.addOptions(nivel, bean, 'nivelID', 'descripcion');
		}
	});

	$('#'+"nivelID"+numNivel).val(valueNivel);
}

function validaTransaccion(e){
	$('#empresaNominaID').val($('#institNominaID').val());
	$('#tipoTransaccion').val('3');
}

function validaNumero(e){
	var tecla = (document.all) ? e.keyCode : e.which;

	if(tecla==8){
		return true;
	}
	var teclasPermitidas = /[,.0-9]/;
	var teclaFinal = String.fromCharCode(tecla);
	return teclasPermitidas.test(teclaFinal);
}


function validaCiclo(jqIdCiclo){
	var jqCiclo = eval("'#"+jqIdCiclo+"'");
	var cicloValida = $(jqCiclo).val();
	var id = jqIdCiclo.substring(8);

		var jqCicloIni = eval("'#cicloIni"+id+"'");
		var cicloInicial = $(jqCicloIni).asNumber();
		if (cicloValida<cicloInicial) {
			mensajeSis("El Ciclo Final no puede ser menor al Ciclo Inicial.");
			setTimeout("$('#"+jqIdCiclo+"').focus();",0);
			return;
		}
}

function validaSeleccion(idControl){
	var jqControl = eval("'#"+idControl+"'");
	var optionSelected = $(jqControl).children(" option:selected").val();
	if(optionSelected === '0'){
		$(jqControl + ' option').attr('selected', 'selected');
	}
}

function formatoTexto(jqMonto){
	$(jqMonto).formatCurrency({
		positiveFormat : '%n',
		roundToDecimalPlace : 2
	});
}

function formatoMoneda(cantidad){
	var n = parseFloat(cantidad).toFixed(2);
	return Number(n).toLocaleString('en');
}

function funcionLimpiarEsquema()
{
	$('#accesorioID').val('');
	funcionLimpiarEsquemaAccesorio();
}

function funcionLimpiarEsquemaAccesorio()
{
	$('#institNominaID').val('');
	funcionLimpiarEsquemaInstiNomina();
}

function funcionLimpiarEsquemaInstiNomina()
{
	$('#descripcionInstitucionNomina').val('');
	$('#cobraIVA').val('');
	$('#formaCobro').val('');
	$('#tipoPago').val('');
	$('#baseCalculo').hide();
	deshabilitaBoton('grabar', 'submit');
}