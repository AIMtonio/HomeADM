//Definicion de Constantes y Enums
var catTipoConsultaEsquemaTasa = {
	'principal' : 1,
	'foranea' : 2
};

var catTipoTranEsquemaTasa = {
	'agrega' : 1,
	'modifica' : 2,
	'elimina' : 3
};
var catTipoConsultaInstitucion = {
		'principal':1
};
var TasaFijaID = 1;
var montoMin = 0.0;
var montoMax = 0.0;
var plazoSaved=0;
var esTab = false;
var contadorRegistro = 0;
var estatusProducto = "";

$(document).ready(function() {
	$('#sucursalID').focus();

	consultaSucursal();
	consultaComboCalInteres();
	cargaComboNiveles();
	$('#tasaBase').val('');
	$('#desTasaBase').val('');
	$('#valorTasaBase').val('');
	$('td[name=tasaBase1]').hide();
	$('td[name=tasaBase2]').hide();
	$('td[name=tasaBase3]').hide();
	$('td[name=tasaBase4]').hide();
	// ------------ Metodos y Manejo de Eventos ----------------

	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('eliminar', 'submit');

	agregaFormatoControles('formaGenerica');
	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
			var tipoTransaccion = $('#tipoTransaccion').val();
			if ($('#calcInteres').val() > 1) {
				$('#tasaFija').val($('#tasaBase').val());
			}
			if(tipoTransaccion == catTipoTranEsquemaTasa.agrega) {
				contadorRegistro = 0;
				var validacion = validaEsquemas();
				if(validacion == ""){
					grabaFormaTransaccionRetrollamada(event,
							'formaGenerica', 'contenedorForma',
							'mensaje', 'true', 'sucursalID',
							'funcionExito', 'funcionError');
					}else{
						mensajeSis(validacion);
						return false;
					}
			}

			if(tipoTransaccion == catTipoTranEsquemaTasa.modifica || tipoTransaccion == catTipoTranEsquemaTasa.elimina ){
				grabaFormaTransaccionRetrollamada(event,
						'formaGenerica', 'contenedorForma',
						'mensaje', 'true', 'sucursalID',
						'funcionExito', 'funcionError');
			}
		}
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#grabar').click(function() {
		plazoSaved=$('#plazoID').val();
		var numero = validaDatos();

		if (numero > 0) {
			event.preventDefault();
		}

	});

	$('#eliminar').click(
			function() {
				$('#tipoTransaccion').val(
						catTipoTranEsquemaTasa.elimina);
			});

	$('#productoCreditoID').bind('keyup',function(e) {
		lista('productoCreditoID', '2', '15',
				'descripcion', $('#productoCreditoID')
						.val(),
				'listaProductosCredito.htm');

	});

	$('#sucursalID').click(function() {
		var productoCredito =  $('#productoCreditoID').val();
		if(productoCredito != ''){
				consultaTasasProductosCredito('productoCreditoID');
		}


	});

	$('#sucursalID').click('keyup',function(e) {
		var productoCredito =  $('#productoCreditoID').val();
		if(productoCredito != ''){
				consultaTasasProductosCredito('productoCreditoID');
		}


	});

	$('#sucursalID').bind('keyup',function(e) {
		var productoCredito =  $('#productoCreditoID').val();
		if(productoCredito != ''){
				consultaTasasProductosCredito('productoCreditoID');
		}


	});
	$('#sucursalID').blur(function() {
		var sucursal = $('#sucursalID').asNumber();
		var productoCredito =  $('#productoCreditoID').val();
		if (sucursal > 0) {
			if(productoCredito != ''){
				consultaTasasProductosCredito('productoCreditoID');
			}
			validaEsquemaTasa();
		}
	});

	$('#productoCreditoID').blur(function() {
		var sucursal = $('#sucursalID').val();
		var producto = $('#productoCreditoID').val();

		if(producto.trim()!='' && esTab){
			if (Number(sucursal) > 0 && esTab) {
				consultaProductosCredito(this.id);
				validaEsquemaTasa();
				$('#tasaFija').val('0.0');
				$('#sobreTasa').val('0.0');
			} else if (Number(sucursal) == 0 && sucursal.trim() != '' && esTab) {
				mensajeSis('Seleccione Una Sucursal.');
				$('#sucursalID').focus();
				$('#productoCreditoID').val('');
			}
		}
		setTimeout("$('#cajaLista').hide();", 200);
	});

	$('#minCredito').blur(function() {
		validaEsquemaTasa();
		$('#tasaFija').val('0.0');
		$('#sobreTasa').val('0.0');
	});

	$('#maxCredito').blur(function() {
		validaEsquemaTasa();
		$('#tasaFija').val('0.0');
		$('#sobreTasa').val('0.0');
	});

	$('#calificacion').blur(function() {
		validaEsquemaTasa();
		$('#tasaFija').val('0.0');
		$('#sobreTasa').val('0.0');
	});

	$('#montoInferior').blur(
					function() {
						var montoInf = $('#montoInferior').asNumber();
						var monInfer = parseFloat(montoInf);
						if (monInfer < montoMin && esTab) {
							mensajeSis('El Monto Inferior no debe ser menor a '
									+ montoMin);
							$('#montoInferior').val('');
							$('#montoInferior').focus();

						}
						validaEsquemaTasa();
						$('#tasaFija').val('0.0');
						$('#sobreTasa').val('0.0');

					});

	$('#montoSuperior').blur(function() {
		var montoSup = $('#montoSuperior').asNumber();
		var monSuper = parseFloat(montoSup);
		// Monto Inferior de la Tasa
		var montoInferior = $('#montoInferior').asNumber();
		if (monSuper > montoMax && esTab) {
			mensajeSis('El Monto Superior no debe ser mayor a '	+ montoMax);
			$('#montoSuperior').val('');
		}
		// se valida el monto minimo el producto
		// de credito y el monto superior de la
		// tasa
		if (montoMin > monSuper && esTab) {
			mensajeSis('El Monto Inferior no debe ser Mayor al Monto Máximo.');
			$('#montoSuperior').val('');
			$('#montoSuperior').focus();
		} else if (montoInferior > monSuper && esTab) { // se
			// valida el monto inferior de la tasa y el monto superior de la tasa
			mensajeSis('El Monto superior no debe ser Menor al Monto Inferior.');
			$('#montoSuperior').val('');
			$('#montoSuperior').focus();
		}

	});

	$('#plazoID').blur(function() {
		validaEsquemaTasa();
		$('#tasaFija').val('0.0');
		$('#sobreTasa').val('0.0');
	});

	$('#institNominaID').bind('keyup',function(e) {
		var NumNom=$('#institNominaID').val();
		lista('institNominaID', '3', '1', 'institNominaID',NumNom,'institucionesNomina.htm');
	});

	$('#institNominaID').blur(function() {
		if(esTab){
			consultaCteNomina('institNominaID');
			validaEsquemaTasa();
		}
	});


	$('#nivelID').change(function() {
		validaEsquemaTasa();
		$('#tasaFija').val('0.0');
		$('#sobreTasa').val('0.0');
		if($('#nivelID').asNumber() != 0){
			$('#tasaFija').focus();
		}
	});

	$('#tasaBase').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombre";
		parametrosLista[0] = $('#tasaBase').val();
		lista('tasaBase','2','1',camposLista,parametrosLista,'tasaBaseLista.htm');
	});

	$('#tasaBase').blur(function(){
		esTab = false;
		consultaTasaBase($('#calcInteres').val());
	});

	$('#sobreTasa').blur(function(){
		$('#sobreTasa').formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
		});
	});

		// ------------ Validaciones de la Forma
		// -------------------------------------
		$('#formaGenerica').validate({
			rules : {
				productoCreditoID : 'required',
				minCredito : 'required',
				maxCredito : 'required',
				calificacion : 'required',
				montoInferior : 'required',
				montoSuperior : 'required',
				tasaFija : 'required',
				sobreTasa : 'required'

			},

			messages : {
				productoCreditoID : 'Especifique Producto',
				minCredito : 'Especifique Mínimo de Créditos',
				maxCredito : 'Especifique Máximo de Créditos',
				calificacion : 'Especifique Calificación',
				montoInferior : 'Especifique Monto',
				montoSuperior : 'Especifique Monto ',
				tasaFija : 'Especifique Tasa Fija',
				sobreTasa : 'Especifique Sobre Tasa '
			}
		});
});


function funcionExito() {
	consultaProductosCredito('productoCreditoID');
	validaEsquemaTasa();

}

function funcionError() {

}

function consultaProductosCredito(idControl) {

	var jqProducto = eval("'#" + idControl + "'");
	var numProducto = $(jqProducto).val();
	var conForanea = 1;
	var ProductoCreditoCon = {
		'producCreditoID' : numProducto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	estatusProducto = "";
	if (numProducto != '' && !isNaN(numProducto)) {
		productosCreditoServicio.consulta(conForanea, ProductoCreditoCon, function(productos) {
			if (productos != null) {
				esNomina = productos.productoNomina;
				validaProductoNomina(productos.productoNomina);
				montoMin = productos.montoMinimo;
				montoMax = productos.montoMaximo;
				$('#descripProducto').val(productos.descripcion);

				consultaTasasProductosCredito(idControl);
				$('#calcInteres').val(productos.calcInteres);
				deshabilitaCamposTasa(productos.calcInteres);
				var calendarioBeanCon = {
					'productoCreditoID' : numProducto
				};
				calendarioProdServicio.consulta(conForanea,	calendarioBeanCon, function(calendario) {
					if (calendario != null) {
						ComboPlazosProdCred(calendario.plazoID);
					}
				});
				
				if (productos.estatus == 'I'){
					estatusProducto = productos.estatus;
					mensajeSis("El Producto "+ productos.descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
					$('#productoCreditoID').focus();
					deshabilitaBoton('grabar', 'submit');
					deshabilitaBoton('eliminar', 'submit');
				}else{
					habilitaBoton('grabar', 'submit');
				}

			} else {
				mensajeSis("No Existe el producto de crédito");
				$('#productoCreditoID').focus();
			}
		});
	}
}

// ------------ Validaciones de Controles -------------------------------------

function validaEsquemaTasa() {
	var sucu = $('#sucursalID').val();
	var tipConsulta = 1;
	quitaFormatoControles('formaGenerica');
	var esquemaTasBeanCon = {
	'sucursalID' : $('#sucursalID').val(),
	'productoCreditoID' : $('#productoCreditoID').val(),
	'minCredito' : $('#minCredito').val(),
	'maxCredito' : $('#maxCredito').val(),
	'calificacion' : $('#calificacion').val(),
	'montoInferior' : $('#montoInferior').val(),
	'montoSuperior' : $('#montoSuperior').val(),
	'plazoID' : $('#plazoID').val(),
	'tasaFija' : $('#tasaFija').val(),
	'sobreTasa' : $('#sobreTasa').val(),
	'institNominaID': $('#institNominaID').val(),
	'nivelID': $('#nivelID').val(),
	};
	agregaFormatoControles('formaGenerica');

	setTimeout("$('#cajaLista').hide();", 200);

	if ($('#calcInteres').val()==1) {
		tipConsulta = 1;
	}else{
		tipConsulta = 2;
		esquemaTasBeanCon['tasaFija'] = $('#tasaBase').val();
	}

	if($('#sobreTasa').val() != '' && !isNaN($('#sobreTasa').val())){
		esquemaTasasServicio.consulta(tipConsulta, esquemaTasBeanCon, function(esquema) {
			if (esquema != null) {
				dwr.util.setValues(esquema);
				consultaCteNomina('institNominaID');
				$('#montoInferior').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				$('#montoSuperior').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				if (tipConsulta==2) {
					$('#tasaBase').val($('#tasaFija').val());
					$('#tasaFija').val('0.0');
				}
				$('#tipoTransaccion').val(catTipoTranEsquemaTasa.modifica);

				if(estatusProducto == "I"){
					deshabilitaBoton('eliminar', 'submit');
				}
				else{
					habilitaBoton('eliminar', 'submit');
				}

			} else {
				deshabilitaBoton('eliminar', 'submit');
				$('#tipoTransaccion').val(catTipoTranEsquemaTasa.agrega);
			}
		});
	}
}

function validaTransaccion() {
	var tipConPrincipal = 1;
	var esquemaTasBeanCon = {
		'sucursalID' : $('#sucursalID').val(),
		'productoCreditoID' : $('#productoCreditoID').val(),
		'minCredito' : $('#minCredito').val(),
		'maxCredito' : $('#maxCredito').val(),
		'calificacion' : $('#calificacion').val(),
		'montoInferior' : $('#montoInferior').val(),
		'montoSuperior' : $('#montoSuperior').val(),
		'plazoID' : $('#plazoID').val(),
		'tasaFija' : $('#tasaFija').val(),
		'sobreTasa' : $('#sobreTasa').val(),
		'institNominaID' : $('#institNominaID').val()
	};

	setTimeout("$('#cajaLista').hide();", 200);

	esquemaTasasServicio.consulta(tipConPrincipal, esquemaTasBeanCon, function(
			esquema) {
		if (esquema != null) {
			mensajeSis("graba");
			$('#tipoTransaccion').val(catTipoTranEsquemaTasa.agrega);
		} else {
			mensajeSis("modificacion");
			$('#tipoTransaccion').val(catTipoTranEsquemaTasa.modifica);
		}
	});

}

function consultaSucursal() {
	var tipoCon = 2;
	dwr.util.removeAllOptions('sucursalID');
	dwr.util.addOptions('sucursalID', {
		'0' : 'SELECCIONA'
	});
	sucursalesServicio.listaCombo(tipoCon, function(sucursales) {
		dwr.util.addOptions('sucursalID', sucursales, 'sucursalID',
				'nombreSucurs');
	});
}

function consultaGridEsquemaTasas(idControl) {

	var jqProducto = eval("'#" + idControl + "'");
	var numProducto = $(jqProducto).val();

	var params = {};
	var tipoListaPrincipal = 1;
	params['sucursalID'] = $('#sucursalID').val();
	params['productoCreditoID'] = numProducto;
	params['tipoLista'] = tipoListaPrincipal;
	params['productoNomina'] = esNomina;

	$.post("esquemaTasasGrid.htm", params, function(data) {
		$('#esquemaGristasas').replaceWith(data);
		agregaFormatoControles('formaGenerica');
	});

}// fin funcion pega Html

function consultaTasasProductosCredito(idControl) {
	consultaGridEsquemaTasas(idControl);
}

function agregaNuevoDetalle() {
	var numeroFila = document.getElementById("numeroDetalle").value;

	var nuevaFila = parseInt(numeroFila) + 1;

	var td = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	td += ' <td><input  id="minCredito'
			+ nuevaFila
			+ '" name="minCredito" path="minCredito" size="8"  disabled="true" />  </td>';
	td += ' <td><input  id="maxCredito'
			+ nuevaFila
			+ '" name="maxCredito" path="maxCredito" size="8"  disabled="true" />  </td>';
	td += ' <td><input  id="calificacion'
			+ nuevaFila
			+ '" name="calificacion" path="calificacion" size="8"  disabled="true" />  </td>';
	td += ' <td><input  id="montoInferior'
			+ nuevaFila
			+ '" name="montoInferior" path="montoInferior" size="8"  disabled="true" />  </td>';
	td += ' <td><input  id="montoSuperior'
			+ nuevaFila
			+ '" name="montoSuperior" path="montoSuperior" size="8"  disabled="true" />  </td>';
	td += ' <td><input  id="tasaFija'
			+ nuevaFila
			+ '" name="tasaFija" path="tasaFija" size="8"  disabled="true" />  </td>';
	td += ' <td><input  id="sobreTasa'
			+ nuevaFila
			+ '" name="sobreTasa" path="sobreTasa" size="8"  disabled="true" />  </td>';
	td += '</tr> '

	document.getElementById("numeroDetalle").value = nuevaFila;
	$("#tablaDeTasas").append(td);

	agregaFormato("'montoInferior" + nuevaFila + "'");
	agregaFormato("'montoSuperior" + nuevaFila + "'");
}

function agregaFormato(idControl) {
	var jControl = eval("'#" + idControl + "'");

	$(jControl).bind('keyup', function() {
		$(jControl).formatCurrency({
			colorize : true,
			positiveFormat : '%n',
			roundToDecimalPlace : -1
		});
	});
	$(jControl).blur(function() {
		$(jControl).formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
		});
	});
	$(jControl).formatCurrency({
		positiveFormat : '%n',
		roundToDecimalPlace : 2
	});
}

function validaDatos() {
	var contador = 0;
	var montoInferiorTasa = $('#montoInferior').asNumber();
	var montoSuperiorTasa = $('#montoSuperior').asNumber();

	if (montoInferiorTasa <= 0.0) {
		mensajeSis("Ingrese el monto inferior de la tasa");
		contador++;
	} else if (montoInferiorTasa > 0.0 && montoInferiorTasa < montoMin) {
		mensajeSis("El monto Inferior no puede ser menor a " + montoMin);
		contador++;
	} else if (montoSuperiorTasa <= 0.0) {
		mensajeSis("Ingrese el monto superior de la tasa");
		contador++;
	} else if (montoSuperiorTasa > 0.0 && montoSuperiorTasa > montoMax) {
		mensajeSis("El monto Superior no puede ser mayor a " + montoMax);
		contador++;
	}

	return contador;

}

// llena el combo de plazos
function ComboPlazosProdCred(varPlazos) {

	// se eliminan los tipos de pago que se tenian
	$('#plazoID').each(function() {
		$('#plazoID option').remove();
	});
	// se agrega la opcion por default
	$('#plazoID').append(new Option('TODOS', 'T', true, true));

	if (varPlazos != null) {
		var plazo = varPlazos.split(',');
		var tamanio = plazo.length;
		plazosCredServicio.listaCombo(3, function(plazoCreditoBean) {
			for ( var i = 0; i < tamanio; i++) {
				for ( var j = 0; j < plazoCreditoBean.length; j++) {
					if (plazo[i] == plazoCreditoBean[j].plazoID) {
						$('#plazoID').append(new Option(plazoCreditoBean[j].descripcion,plazo[i], true, true));
						$('#plazoID').val('').selected = true;
						if(plazoSaved!=null || plazoSaved!=''){
						$('#plazoID').val(plazoSaved).selected = true;
					}
						break;
					}
				}
			}
		});
	}
}

// funcion para llenar combo Calculo de Interes
function consultaComboCalInteres(){
	dwr.util.removeAllOptions('calcInteres');
	formTipoCalIntServicio.listaCombo(1,function(formTipoCalIntBean){
		dwr.util.addOptions('calcInteres', {'':'SELECCIONAR'});
		dwr.util.addOptions('calcInteres', formTipoCalIntBean, 'formInteresID', 'formula');
	});
}

function deshabilitaCamposTasa(productoCalcInteres){
	// Si el producto es de tasa fija deshabilita la sobre tasa
	if(TasaFijaID==productoCalcInteres){
		habilitaControl('tasaFija');
		deshabilitaControl('sobreTasa');
		$('#tasaBase').val('');
		$('#desTasaBase').val('');
		$('#valorTasaBase').val('');
		$('td[name=tasaBase1]').hide();
		$('td[name=tasaBase2]').hide();
		$('td[name=tasaBase3]').hide();
		$('td[name=tasaBase4]').hide();
	} else if(TasaFijaID!=productoCalcInteres){ // Si es variable, deshabilita la tasa fija
		consultaTasaBase(productoCalcInteres);
		deshabilitaControl('tasaFija');
		habilitaControl('sobreTasa');
		$('td[name=tasaBase1]').show();
		$('td[name=tasaBase2]').show();
		$('td[name=tasaBase3]').show();
		$('td[name=tasaBase4]').show();
	}
}
// consulta la tasa base del mes anterior
function consultaTasaBase(calcInt) {
	var calcInteres = Number(calcInt);
	var tasaMesAnterior = 4;
	var tipoConsulta = 1;
	var TasaBaseBeanCon = {
			'tasaBaseID' : $('#tasaBase').val()
	};

	if (calcInteres==tasaMesAnterior) {
		tipoConsulta = 2;
	}

	tasasBaseServicio.consulta(tipoConsulta, TasaBaseBeanCon,function(tasasBaseBean) {
		if (tasasBaseBean != null) {
			$('#tasaBase').val(tasasBaseBean.tasaBaseID);
			$('#desTasaBase').val(tasasBaseBean.nombre);
			$('#valorTasaBase').val(tasasBaseBean.valor);
			if (calcInteres==tasaMesAnterior){
				deshabilitaControl('tasaBase');
			}else{
				habilitaControl('tasaBase');
			}
		}else if (calcInteres==tasaMesAnterior) {
			mensajeSis("No Existe una Tasa Base Registrada para el Mes Anterior.");
			$('#tasaBase').val('');
			$('#desTasaBase').val('');
			$('#valorTasaBase').val('');
			deshabilitaControl('tasaBase');
		}else{
			habilitaControl('tasaBase');
		}
	});
}

function consultaCteNomina(idControl){
	var jqNumNom = eval("'#" + idControl + "'");
	var NumNomina = $(jqNumNom).val();
	var Baja='B';
	var bean = {
			'institNominaID':NumNomina
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (NumNomina != '' && !isNaN(NumNomina) && $(jqNumNom).asNumber()>0) {
		institucionNomServicio.consulta(catTipoConsultaInstitucion.principal, bean, function(Respuesta){
		if(Respuesta != null){
			$('#nombreInstit').val(Respuesta.nombreInstit);
			if(Respuesta.estatus==Baja){
				mensajeSis('La Institución de Nómina se encuentra Cancelada');
				$('#institNominaID').focus();
				$('#institNominaID').val('');
				$('#nombreInstit').val('');

			}
		}else{
			mensajeSis('No Existe la Institución.');
			$('#institNominaID').focus();
			$('#institNominaID').val('');
			$('#nombreInstit').val('');
		}
		});
	} else {
		$('#institNominaID').val('0');
		$('#nombreInstit').val('TODAS');
	}
}

/**
 * Valida si el producto es de Nomina si no lo es oculta los campos.
 * @param esNomina N:No S:Si
 */
function validaProductoNomina(esNomina){
	if(esNomina=='N'){
		$('#institNominaID').val('');
		$('#nombreInstit').val('');
		mostrarElementoPorClase("classInstitucionNomina","N");
	} else {
		mostrarElementoPorClase("classInstitucionNomina","S");
	}
}

// Consulta total de filas integrantes
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;
	});
	return totales;
}

// Funcion para validar Esquemas de Tasas del Producto
function validaEsquemas(){
	// Calificacion
	var calificacion = $('#calificacion').val();

	//Monto Inferior
	var montoInferior = $('#montoInferior').asNumber();
	var valMontoInferior = $('#montoInferior').val();

	//Monto Superior
	var montoSuperior = $('#montoSuperior').asNumber();

	//Plazo
	var plazoID = $('#plazoID').val();

	// Mínimo creditos
	var minimoCreditos = $('#minCredito').asNumber();

	// Maximo Créditos
	var maximoCreditos = $('#maxCredito').asNumber();

	// Nivel
	var nivelID = $('#nivelID').val();

	var mensaje = "";

	$('tr[name=renglon]').each(function() {
		numFilas = consultaFilas();
		var numero= this.id.substr(7,this.id.length);

		// Calificacion
		var jqCalificacion = eval("'#calificacion" + numero + "'");
		var valorCalificacion =$(jqCalificacion).val();

		// Monto Inferior
		var jqMontoInferior= eval("'#montoInferior" + numero + "'");
		var valorMontoInferior =$(jqMontoInferior).asNumber();

		// Monto Superior
		var jqMontoSuperior = eval("'#montoSuperior" + numero + "'");
		var valorMontoSuperior =$(jqMontoSuperior).asNumber();

		// Plazo del Producto
		var jqPlazoID = eval("'#plazoID" + numero + "'");
		var valorPlazoID =$(jqPlazoID).asNumber();

		// Minimo Creditos
		var jqMinimoCreditos = eval("'#minCredito" + numero + "'");
		var valorMinimoCreditos =$(jqMinimoCreditos).val();

		// Máximo Créditos
		var jqMaximoCreditos = eval("'#maxCredito" + numero + "'");
		var valorMaximoCreditos =$(jqMaximoCreditos).val();

		if(valorCalificacion == 'NO ASIGNADA'){
			var valCalificacion = 'N';
		}

		if(valorCalificacion == 'EXCELENTE'){
			var valCalificacion = 'A';
		}

		if(valorCalificacion == 'BUENA'){
			var valCalificacion = 'B';
		}

		if(valorCalificacion == 'REGULAR'){
			var valCalificacion = 'C';
		}

		if(valorPlazoID == 0){
			var valorPlazoTodos = 'T';
		}


		var jqNivelID = eval("'#nivelID" + numero + "'");
		var valorNivelID =$(jqNivelID).val();

		if(valorMontoSuperior == montoInferior && valorPlazoID == plazoID){
			mensaje=("El Monto Inferior Debe ser Mayor a $ "+ valMontoInferior+ ", ya Existe un Monto Superior por $ "+valMontoInferior);
			$('#montoInferior').focus();
		}
		else {

			if(valCalificacion == calificacion && plazoID == valorPlazoTodos && nivelID == valorNivelID){
				if(((valorMontoInferior >= montoInferior && valorMontoInferior <= montoSuperior && valorMinimoCreditos >= minimoCreditos && valorMinimoCreditos <= maximoCreditos )
						|| (valorMontoSuperior >= montoInferior && valorMontoSuperior <= montoSuperior && valorMaximoCreditos >= minimoCreditos && valorMaximoCreditos <= maximoCreditos)
						)){

					contadorRegistro = contadorRegistro+1;
					mensaje=("El Monto Inferior y Monto Superior ya se Encuentra Dentro de Otro Rango");
					$('#minCredito').focus();
				}
				else{
					if(contadorRegistro == 0){
						mensaje="";
					}

				}
			}
		}

	});

	 return mensaje;
}


// FUNCION PARA LLENAR COMBO NIVEL
function cargaComboNiveles() {
	var beanCon ={
			'nivelID' : 0
		};
	var tipoCon = 2;
	dwr.util.removeAllOptions('nivelID');
	dwr.util.addOptions('nivelID', {
		'0' : 'TODAS'
	});
	nivelCreditoServicio.listaCombo(tipoCon,beanCon, function(bean) {
		dwr.util.addOptions('nivelID', bean, 'nivelID','descripcion');
	});
}