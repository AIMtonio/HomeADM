var esTab=false;
var tipoComisionPorcentaje = "P";
var tipoComisionMonto = "M";
var no_cobra= "N";
var cat_TipoTransaccion = {
'grabar' : 1,
'modificar' : 2
};
$(document).ready(function() {
	inicializar();
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	$(':text').focus(function() {
		esTab = false;
	});
	$('#formaGenerica').validate({
	rules : {
		producCreditoID : 'required',
		cobraComision:	'required',
		tipoComision:	{
			required : function() {
				return $('#cobraComision').val() == 'S';
			}
		},
		baseCalculo:	{
			required : function() {
				return $('#cobraComision').val() == 'S' && $('#tipoComision').val() == 'P';
			}
		},
		montoComision:	{
			required : function() {
				return $('#cobraComision').val() == 'S' && $('#tipoComision').val() == 'M';
			},
			maxlength: 18
		},
		porcentajeComision:	{
			required : function() {
				return $('#cobraComision').val() == 'S' && $('#tipoComision').val() == 'P';
			}
		},
		diasGracia:	{
			required : function() {
				return $('#cobraComision').val() == 'S';
			},
			number: true,
			min:1
		}
	},
	messages : {
		producCreditoID : 'Especifique producto de crédito.',
		cobraComision : 'Especifique el Cobro de Comisión.',
		tipoComision:	{
			required : 'Especifique el Tipo de Comisión.'
		},
		baseCalculo:	{
			required : 'Especifique la Base de Cálculo.'
		},
		montoComision:	{
			required : 'Especifique el Monto de la Comisión.',
			maxlength: 'Máximo 18 Números.'
		},
		porcentajeComision:	{
			required : 'Especifique el Porcentaje de la Comisión.'
		},
		diasGracia:	{
			required : 'Especifique los Días de Gracia.',
			number: 'Sólo Números.',
			min: 'El Valor debe Ser Mayor a Cero.'
		}
	}
	});

	$('#producCreditoID').bind('keyup', function(e) {
		var lista_productos_ind = 17;
		lista('producCreditoID', '1', lista_productos_ind, 'descripcion', $('#producCreditoID').val(), 'listaProductosCredito.htm');
	});
	$('#producCreditoID').blur(function() {
		var producto = $('#producCreditoID').asNumber();
		if (producto > 0 && esTab) {
			consultaProductosCredito(this.id);
		} else {
			agregaFormatoControles('formaGenerica');
			deshabilitaBoton('grabar', 'submit');
		}
	});
	$('#cobraComision').change(function() {
		var cobraComision = $('#cobraComision').val();
		validaCobraComision(cobraComision);
	});
	$('#tipoComision').change(function() {
		var tipoComision = $('#tipoComision').val();
		validaTipoComision(tipoComision);
	});
	$('#baseCalculo').change(function() {
		var baseCalculo = $('#baseCalculo').val();
	});
	$('#grabar').click(function(event) {
		if ($("#formaGenerica").valid()) {
			$('#tipoTransaccion').val(cat_TipoTransaccion.grabar);
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma','mensaje', 'true',
			'producCreditoID','funcionExito','funcionError');
		}
	});
	$('#modificar').click(function(event) {
		if ($("#formaGenerica").valid()) {
			$('#tipoTransaccion').val(cat_TipoTransaccion.modificar);
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma','mensaje', 'true',
			'producCreditoID','funcionExito','funcionError');
		}
	});
});
/**
 * Inicializa la forma
 */
function inicializar() {
	agregaFormatoControles('formaGenerica');
	limpiaFormaCompleta('formaGenerica', true, [ 'producCreditoID' ]);
	$('#producCreditoID').focus();
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	deshabilitaControl('baseCalculo');
	deshabilitaControl('montoComision');
	deshabilitaControl('porcentajeComision');
}

function funcionExito(){
	agregaFormatoControles('formaGenerica');
	limpiaFormaCompleta('formaGenerica', true, [ 'producCreditoID' ]);
}

function funcionError(){
	
}

function validaTipoComision(tipoComision) {
	if (tipoComision == tipoComisionPorcentaje) {
		habilitaControl('baseCalculo');
		habilitaControl('montoComision');
		habilitaControl('porcentajeComision');
		$('#baseCalculo').val("");
		$('#montoComision').val("");
		$('#porcentajeComision').val("");
		$('#esPorcentaje').show();
		$('#esMonto').hide();
	} else if (tipoComision == tipoComisionMonto) {
		deshabilitaControl('baseCalculo');
		habilitaControl('montoComision');
		deshabilitaControl('porcentajeComision');
		$('#baseCalculo').val("");
		$('#montoComision').val("");
		$('#porcentajeComision').val("");
		$('#esPorcentaje').hide();
		$('#esMonto').show();
	} else {
		deshabilitaControl('baseCalculo');
		deshabilitaControl('montoComision');
		deshabilitaControl('porcentajeComision');
		$('#baseCalculo').val("");
		$('#montoComision').val("");
		$('#porcentajeComision').val("");
		$('#esPorcentaje').hide();
		$('#esMonto').show();
	}
}
/**
 * Consulta el nombre de los productos de crédito
 */
function consultaProductosCredito(idControl) {
	var jqProducto = eval("'#" + idControl + "'");
	var numProducto = $(jqProducto).val();
	var ProductoCreditoCon = {
		'producCreditoID' : numProducto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numProducto != '' && !isNaN(numProducto)) {
		productosCreditoServicio.consulta(1, ProductoCreditoCon, {async: false,callback:function(productos) {
			if (productos != null) {
				$('#descripProducto').val(productos.descripcion);
				consultarEsquema(productos.estatus);
			} else {
				mensajeSis("No Existe el producto de crédito.");
				$(jqProducto).val('');
				$(jqProducto).focus();
			}
		},
		errorHandler:function(message) { mensajeSis("Error al Consultar el Producto de Crédito:"+message); }
		});
	} else {
		mensajeSis("Producto de Crédito No Válido.");
		$(jqProducto).val('');
		$(jqProducto).focus();
	}
}

function validaCobraComision(cobraComision){

	if (cobraComision=="" || cobraComision == no_cobra) {
		deshabilitaControl('tipoComision');
		deshabilitaControl('baseCalculo');
		deshabilitaControl('montoComision');
		deshabilitaControl('porcentajeComision');
		deshabilitaControl('diasGracia');
		limpiaFormaCompleta('formaGenerica', true, [ 'producCreditoID','descripProducto','cobraComision']);
		$('#esPorcentaje').hide();
		$('#esMonto').show();
	} else {
		habilitaControl('tipoComision');
		deshabilitaControl('baseCalculo');
		deshabilitaControl('montoComision');
		deshabilitaControl('porcentajeComision');
		habilitaControl('diasGracia');
		limpiaFormaCompleta('formaGenerica', true, [ 'producCreditoID','descripProducto','cobraComision' ]);
		$('#esPorcentaje').hide();
		$('#esMonto').show();
	}
}

function consultarEsquema(estatusProducCred){
	var numProducto = $("#producCreditoID").val();
	var ProductoCreditoCon = {
		'producCreditoID' : numProducto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numProducto != '' && !isNaN(numProducto)) {
		esquemaComAnualServicio.consulta(1, ProductoCreditoCon, {callback:function(productos) {
			if (productos != null) {
				validaCobraComision(productos.cobraComision);
				validaTipoComision(productos.tipoComision)
				dwr.util.setValues(productos);
				deshabilitaBoton('grabar', 'submit');
				if(estatusProducCred == 'I'){
					deshabilitaBoton('modificar', 'submit');
					mensajeSis("El Producto "+$('#descripProducto').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
					$('#producCreditoID').focus();
				}else{
					habilitaBoton('modificar', 'submit');
				}	
			} else {
				if(estatusProducCred == 'I'){
					deshabilitaBoton('grabar', 'submit');
					mensajeSis("El Producto "+$('#descripProducto').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
					$('#producCreditoID').focus();
				}else{
					habilitaBoton('grabar', 'submit');
				}
				deshabilitaBoton('modificar', 'submit');
				deshabilitaControl('tipoComision');
				deshabilitaControl('baseCalculo');
				deshabilitaControl('montoComision');
				deshabilitaControl('porcentajeComision');
				limpiaFormaCompleta('formaGenerica', true, [ 'producCreditoID','descripProducto']);
				$('#esPorcentaje').hide();
				$('#esMonto').show();
			}
		},
		errorHandler:function(message) { mensajeSis("Error al Consultar Esquema:"+message); }
		});
	}
}