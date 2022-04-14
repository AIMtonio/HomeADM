var esTab = false;
//Definicion de Constantes y Enums
var catTipoTransaccion = {
	'agrega' : '1',
	'modifica' : '2',
};

var catTipoConsulta = {
	'principal' : 1,

};

//------------ Metodos y Manejo de Eventos -----------------------------------------
$(document).ready(function() {
	inicializa();
	inicializaCombos();
	$(':text').focus(function() {
		esTab = false;
	});
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'tipoLineaAgroID', 'funcionExito', 'funcionError');
		}

	});


	// Validaciones de la Forma
	$('#formaGenerica').validate({
		rules : {
			tipoLineaAgroID : {
				required : true
			},
			nombre : {
				required : true
			},
			montoLimite : {
				required : true
			},
			plazoLimite : {
				required : true
			},
			manejaComAdmon : {
				required : true
			},
			manejaComGaran : {
				required : true
			},
			productosCredito : {
				required : true
			},
			estatus : {
				required : true
			}
		},
		messages : {
			tipoLineaAgroID : {
				required : 'El Número de Tipo Línea es Requerido.'
			},
			nombre : {
				required : 'EL nombre del tipo de Línea es Requerido.'
			},
			montoLimite : {
				required : 'El monto Límite es requerido.'
			},
			plazoLimite : {
				required : 'El plazo límite es requerido.'
			},
			manejaComAdmon : {
				required : 'Selecciona una opción de Comisión Admón.'
			},
			manejaComGaran : {
				required : 'Selecciona una opción de Comisión Garantia.'
			},
			productosCredito : {
				required : 'Se requiere  Producto Crédito.'
			},
			estatus : {
				required : 'Se requiere estatus.'
			}
		}
	});

	// Lista los conceptos
	$('#tipoLineaAgroID').bind('keyup', function(e) {
		deshabilitaBoton('modifica', 'submit');
		deshabilitaBoton('agrega', 'submit');
		lista('tipoLineaAgroID', '1', '1', 'nombre', $('#tipoLineaAgroID').val(), 'listaTiposLineaAgro.htm');
	});

	// Formato numerico en cantidad
	$('#montoLimite').formatCurrency({
		positiveFormat : '%n',
		roundToDecimalPlace : 2
	});

	// Agrega el valior de la transaccion a el boton agregar
	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.agrega);
	});

	// Agrega el valior de la transaccion a el boton modificar
	$('#modifica').click(function() {
		if(validaEstatus()){
			$('#tipoTransaccion').val(catTipoTransaccion.modifica);
		}else{
			event.preventDefault();
		}
	});
	
	//Consulta el tipo de linea en caso de existir
	$('#tipoLineaAgroID').blur(function() {
		deshabilitaBoton('agrega', 'submit');
		inicializaCombos();
		setTimeout("$('#cajaLista').hide();", 200);
		consultaTipoLinea(this.id);
	});

	//Consulta el tipo de linea en caso de existir
	$('#montoLimite').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		var MontoTemp = $("#montoLimite").asNumber();
		if(MontoTemp > 100000000){
			mensajeSis("Monto límite no puede ser superior a 100,000,000.00 ");
			$('#montoLimite').val("100,000,000.00");
			$('#montoLimite').focus();
		}
	});

});

//Funcion que consulta el tipo de linea
function consultaTipoLinea(){
	inicializaCombos();

	var tipoLinea = $("#tipoLineaAgroID").asNumber();
	var principal = 1;
	var bean = {
		'tipoLineaAgroID' : tipoLinea
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (tipoLinea != 0 && esTab && tipoLinea != ' ' && !isNaN(tipoLinea)) {
		tiposLineasAgroServicio.consulta(principal,bean,{ 
			callback:function(bean) {
				if (bean != null) {
					dwr.util.setValues(bean);
					consultaComboProductos(bean.productosCredito);
					deshabilitaBoton('agrega', 'submit');
					habilitaBoton('modifica', 'submit');
					$('#estatus').attr('disabled',false);
					inhabilitarCampos(true);
					if(bean.estatus==='I'){
						inhabilitarCamposTodos(true);
						deshabilitaBoton('modifica', 'submit');
					}else{
						inhabilitarCamposTodos(false);
						habilitaControl('estatus');

					}
					$('#montoLimite').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});
				} else {
					mensajeSis("El Número de Tipo Línea No Existe.");
					inicializa();
				}
			}
		});
	} else
	if(tipoLinea==0){
		habilitaBoton('agrega', 'submit');
		$('#tipoLineaAgroID').val(0);
		inhabilitarCampos(false);
		inhabilitarCamposTodos(false);
		$('#estatus').attr('disabled',true);
		$('#nombre').focus();
		limpiaFormaCompleta('formaGenerica',true,['tipoLineaAgroID']);
		$('#estatus').val('A');
	}else{
		limpiaFormaCompleta('formaGenerica',true);
		$('#tipoLineaAgroID').focus();
	}
}

/**
* Consulta los tipos de producto
*/
function funcionCargaProductosCredito() {
	dwr.util.removeAllOptions('productosCredito');
	productosCreditoServicio.listaCombo(10, function(tiposInstrum) {
		dwr.util.addOptions('productosCredito', tiposInstrum, 'producCreditoID', 'descripcion');
	});
}

/**
* Inicializa combos
*/
function inicializaCombos(){
	$("#productosCredito").each(function(){
		$("#productosCredito option").removeAttr("selected");
	});
}

/**
Consulta y carga los tipos segun el tipo de Linea
*/
function consultaComboProductos(productosCredito) {
	var frec= productosCredito.split(',');
	var tamanio = frec.length;

	for (var i=0;i< tamanio;i++) {
		var fre = frec[i];
		var jqFrecuencia = eval("'#productosCredito option[value="+fre+"]'");
		$(jqFrecuencia).attr("selected","selected");
	}
}

function validaEstatus(){
	var estatus = $('#estatus').val();
	if (estatus === 'I'){
		if(confirm("Si desea continuar, se dará de baja el Tipo de Línea.")){
			return true;
		}else{
			return false;
		}
	}
	return true;
}

//Inicializa los valores de la forma
function inicializa() {
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	limpiaFormaCompleta('formaGenerica',true,['tipoLineaAgroID']);
	agregaFormatoControles('formaGenerica');
	funcionCargaProductosCredito();
	$('#tipoLineaAgroID').focus();
}

//funcion para inhabilitar campos
function inhabilitarCampos(valor){
	$('#montoLimite').attr('disabled',valor);
	$('#plazoLimite').attr('disabled',valor);
}

//funcion para inhabilitar campos
function inhabilitarCamposTodos(valor){
	$('#nombre').attr('disabled',valor);
	$('#manejaComAdmon').attr('disabled',valor);
	$('#manejaComGaran').attr('disabled',valor);
	$('#productosCredito').attr('disabled',valor);
	$('#estatus').attr('disabled',valor);
	if(valor){
		$('#estatus').attr('disabled',false);
	}
}


//Si la transaccion se hace correctamente limpia la forma exepto uniConceptoInvID
function funcionExito(){
	inicializaForma('formaGenerica','tipoLineaAgroID');
	limpiaFormaCompleta('formaGenerica',true,['tipoLineaAgroID']);
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	$("#estatus").val('A');
	deshabilitaControl('estatus');
}

//Si la transaccion no se hace correctamente
function funcionError(){
}