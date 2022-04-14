esTab = true;       
//Definicion de Constantes y Enums
var Enum_TipoConsulta = { 
	'principal':1,
	'foranea':2
};

var Enum_TipoTransaccion = {
	'grabar'	:1,
	'modificar'	:2,
	'eliminar'	:3
};

var Enum_Constantes ={
	'SI' : 'S',
	'NO' : 'N'	
};

var Enum_TipoCargo ={
	'MONTO' : 'M',
	'PORCENTAJE' : 'P'
};

var Enum_Dispersion = {
	'TipoSpei' :'S',
	'TipoCheque' :'C',
	'TipoOrdenDePago' :'O',
	'TipoEfectivo' :'E',
	'DescSpei' :'SPEI',
	'DescCheque' :'CHEQUE',
	'DescOrdenDePago' :'ORDEN DE PAGO',
	'DescEfectivo' :'EFECTIVO'
};
$(document).ready(function() {
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('eliminar', 'submit');
	ocultaTRS(true);
	$('#productoCreditoID').focus();

	$(':text').focus(function() {	
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','productoCreditoID','exito','error');
		}
	});					
	
	$('#grabar').click(function() {	
		$('#tipoTransaccion').val(Enum_TipoTransaccion.grabar);		
	});

	$('#eliminar').click(function() {
		$('#tipoTransaccion').val(Enum_TipoTransaccion.eliminar);		
	});
	
	$('#productoCreditoID').bind('keyup',function(e){
		lista('productoCreditoID', '1', '15', 'descripcion', $('#productoCreditoID').val(), 'listaProductosCredito.htm');
	});
	
	$('#productoCreditoID').blur(function() {	 
		consultaProducCredito(this.id);
		ocultaTRS(true);
	});
	
	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});
	
	$('#institucionID').blur(function() {	 
		consultaInstitucion(this.id);
	});

	$('#montoCargo').blur(function(event){
		var montoCargo = $('#montoCargo').asNumber();
		var tipoCargo = $('#tipoCargo').val();
		if(tipoCargo == Enum_TipoCargo.PORCENTAJE){
			if(montoCargo > 100){
				mensajeSis('El Porcentaje de Cargo No debe de ser Mayor al 100%.');
				$('#montoCargo').val('0.00');
				$('#montoCargo').focus();
			}
		} else {
			$('#porcentaje').hide();
		}
	});

	$('#tipoCargo').change(function(event){
		var tipoCargo = $('#tipoCargo').val();
		if(tipoCargo == Enum_TipoCargo.PORCENTAJE){
			$('#porcentaje').show();
		} else {
			$('#porcentaje').hide();
		}
	});

	$('#tipoDispersion').change(function(event){
		var tipoDispersion = $('#tipoDispersion').val();
		if(tipoDispersion != ''){
			ocultaTipoCargo(false);
		} else {
			ocultaTipoCargo(true);
			ocultaTR2(true);
		}
	});

	$('#tipoCargo').change(function(event){
		var tipoCargo = $('#tipoCargo').val();
		if(tipoCargo != ''){
			ocultaTR2(false);
		} else {
			ocultaTR2(true);
		}
	});

	$('#nivel').change(function(event){
		var nivel = $('#nivel').val();
		if(nivel != ''){
			ocultaMontoCargo(false);
		} else {
			ocultaMontoCargo(true);
		}
	});

	$('#nivel').blur(function(event){
		consultaEsquemaCobroDisp();
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			productoCreditoID : 'required',
			institucionID : 'required',
			montoCargo : {
				required : true,
				maxlength : 12
			},
			tipoDispersion : {required: function() {return $('#tipoTransaccion').val() == Enum_TipoTransaccion.grabar;},},
			tipoCargo : {required: function() {return $('#tipoTransaccion').val() == Enum_TipoTransaccion.grabar;},},
			nivel : {required: function() {return $('#tipoTransaccion').val() == Enum_TipoTransaccion.grabar;},},
		},
		
		messages: {
			productoCreditoID : 'Especifique el Producto de Crédito.',
			institucionID : 'Especifique la Institución.',
			montoCargo : {
				required : 'Especifique el Valor de Cargo.',
				maxlength : 'Máximo 9 dígitos.'
			},
			tipoDispersion : 'Especifique el Tipo Dispersión.',
			tipoCargo : 'Especifique el Tipo Cargo.',
			nivel : 'Especifique el Nivel.',
		}
	});
	
}); // fin function principal
 /**
  * Consulta el Esquema para el Producto de Crédito y la Institución Financiera consultados.
  * @author avelasco
  */
function consultaEsquemaCobroDisp() {
	var estProducCred  = $('#estatusProducCredito').val(); ;
	var ProdCred = $('#productoCreditoID').val();
	var Institucion = $('#institucionID').val();
	var tipoDispersion = $('#tipoDispersion').val();
	var tipoCargo = $('#tipoCargo').val();
	var nivel = $('#nivel').val();
	var esquemaBean = {
			'productoCreditoID'	:ProdCred,
			'institucionID'		:Institucion,
			'tipoDispersion'	:tipoDispersion,
			'tipoCargo'			:tipoCargo,
			'nivel'				:nivel
	}; 
	setTimeout("$('#cajaLista').hide();", 200);
	if(ProdCred != '' && !isNaN(ProdCred) &&
		Institucion != '' && !isNaN(Institucion) &&
		tipoDispersion != '' && tipoCargo != '' &&
		nivel != '' && !isNaN(nivel)){
		esquemaCargoDispServicio.consulta(esquemaBean,Enum_TipoConsulta.principal,{ async: false, callback:function(datos) {
			if(datos!=null){
				$('#tipoDispersion').val(datos.tipoDispersion);
				$('#tipoCargo').val(datos.tipoCargo);
				$('#nivel').val(datos.nivel);
				$('#montoCargo').val(datos.montoCargo);
				$('#tipoCargo').change();
				ocultaTRS(false);
				ocultaTipoCargo(false);
				ocultaMontoCargo(false);
				deshabilitaBoton('grabar', 'submit');
				if(estProducCred == 'I'){
					deshabilitaBoton('eliminar', 'submit');
					mensajeSis("El Producto "+$('#descripProducto').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
					$('#productoCreditoID').focus();
				}else{
					habilitaBoton('eliminar', 'submit');
				}
				
			} else {
				$('#montoCargo').val('0.00');
				if(estProducCred == 'I'){
					deshabilitaBoton('grabar', 'submit');
					mensajeSis("El Producto "+$('#descripProducto').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
					$('#productoCreditoID').focus();
				}else{
					habilitaBoton('grabar', 'submit');
				}
				deshabilitaBoton('eliminar', 'submit');
			}
		}});
	}
}
 /**
  * Consulta el nombre del Producto de Crédito.
  * @param idControl : ID del input del producto de crédito.
  * @author avelasco
  */
function consultaProducCredito(idControl) {
	var jqProdCred  = eval("'#" + idControl + "'");
	var ProdCred = $(jqProdCred).val();
	var ProdCredBeanCon = {
			'producCreditoID':ProdCred 
	}; 
	setTimeout("$('#cajaLista').hide();", 200);
	if(ProdCred != '' && !isNaN(ProdCred) && esTab){
		productosCreditoServicio.consulta(Enum_TipoConsulta.principal,ProdCredBeanCon,{ async: false, callback:function(prodCred) {
			if(prodCred!=null){
				$('#descripProducto').val(prodCred.descripcion);
				consultaEsquema();
				validaCalendarioProducto(ProdCred);
				cargaComboNiveles();
				limpiaFormaCompleta('formaGenerica', true, [ 'productoCreditoID','descripProducto']);
				$('#estatusProducCredito').val(prodCred.estatus);
			} else {
				mensajeSis("No Existe el Producto de Crédito.");
				$('#productoCreditoID').focus();
				$('#productoCreditoID').select();
				exito();
			}
		}});
	}
}
/**
 * Consulta el nombre de la institucion.
 * @param idControl : ID del input de la institucion.
 * @author avelasco
 */
function consultaInstitucion(idControl){
	var jqInst = eval("'#" + idControl + "'");
	var jqDesc = '#nombInstitucion';
	var producCreditoID = $('#productoCreditoID').asNumber();
	var numInstituto = $(jqInst).val();
	var InstitutoBeanCon = {
			'institucionID':numInstituto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numInstituto != '' && !isNaN(numInstituto) && esTab) {
		institucionesServicio.consultaInstitucion(Enum_TipoConsulta.principal, InstitutoBeanCon, function(instituto) {
			if (instituto != null) {
				$(jqDesc).val(instituto.nombre);
				ocultaTR1(false);
				ocultaTR2(true);
				ocultaTipoCargo(true);
				ocultaMontoCargo(true);
				inicializaDetalle();
			} else {
				mensajeSis("No Existe la Institución.");
				ocultaTR1(false);
				ocultaTR2(true);
				ocultaTipoCargo(true);
				ocultaMontoCargo(true);
				inicializaDetalle();
				$(jqInst).val('');
				$(jqDesc).val('');
				$(jqInst).focus();
			}
		});
	}
}

/**
 * Consulta la lista del esquema por producto y los muestra en el grid.
 * @author avelasco
 */
function consultaEsquema(){
	var producCreditoID = $('#productoCreditoID').val();
	var esquemaBean = {
			'tipoLista'			: 1,
			'productoCreditoID'	: producCreditoID,
	};
	$('#gridEsquemaCobro').html("");
	$.post("esquemaCargoGrid.htm", esquemaBean, function(data) {
		if (data.length > 0 ) {
			$('#gridEsquemaCobro').html(data);
			$('#gridEsquemaCobro').show();
		} else {
			$('#gridEsquemaCobro').html("");
			$('#gridEsquemaCobro').show();
		}
	});
}
/**
 * Inicializa la forma y deshabilita los botones.
 * @autor avelasco
 */
function exito(){
	deshabilitaBoton('eliminar', 'submit');
	deshabilitaBoton('grabar', 'submit');
	limpiaFormaCompleta('formaGenerica', true, [ 'productoCreditoID' ]);
	$('#gridEsquemaCobro').html("");
	$('#gridEsquemaCobro').hide();
	$('#estatusProducCredito').val('');
	ocultaTRS(true);
}

function error(){

}

function consultaComboTipoDispersion(tipoDispersion){
	dwr.util.removeAllOptions('tipoDispersion');
	dwr.util.addOptions('tipoDispersion', {
		'' : 'SELECCIONAR'
	});
	if(tipoDispersion != null){
		var tipoDis= tipoDispersion.split(',');
		var tamanio = tipoDis.length;
		for (var i=0;i< tamanio;i++) {
			var tipoD = tipoDis[i];
			switch(tipoD){
				case Enum_Dispersion.TipoSpei: 
					dwr.util.addOptions('tipoDispersion', {'S' : Enum_Dispersion.DescSpei});
					break;
				case Enum_Dispersion.TipoCheque: 
					dwr.util.addOptions('tipoDispersion', {'C' : Enum_Dispersion.DescCheque});
					break;
				case Enum_Dispersion.TipoOrdenDePago: 
					dwr.util.addOptions('tipoDispersion', {'O' : Enum_Dispersion.DescOrdenDePago});
					break;
			}
		}
	}
}

// FUNCION PARA LLENAR COMBO NIVEL
function cargaComboNiveles() {
	var beanCon ={
			'nivelID' : 0 
		};
	var tipoCon = 2;
	dwr.util.removeAllOptions('nivel');
	dwr.util.addOptions('nivel', {
		'' : 'SELECCIONAR'
	});
	dwr.util.addOptions('nivel', {
		'0' : 'TODAS'
	});
	nivelCreditoServicio.listaCombo(tipoCon,beanCon, function(bean) {
		dwr.util.addOptions('nivel', bean, 'nivelID','descripcion');
	});
}

function validaCalendarioProducto(productoCreditoID) {
	var producto = productoCreditoID;
	var calendarioBeanCon = {
		'productoCreditoID' :producto
	};

	setTimeout("$('#cajaLista').hide();", 200);
	if(producto != '' && !isNaN(producto)){
		calendarioProdServicio.consulta(1, calendarioBeanCon,{ async: false, callback:function(calendario) {
			if(calendario!=null){
				var tipoDispersion = calendario.tipoDispersion;
				consultaComboTipoDispersion(tipoDispersion);
			}
		}});
	}
}
function inicializaDetalle(){
	$('#tipoDispersion').val('');
	$('#tipoCargo').val('');
	$('#nivel').val('');
	$('#montoCargo').val('0.00');
}
function ocultaTRS(oculta){
	if(oculta){
		ocultaTR1(oculta);
		ocultaTR2(oculta);
	} else {
		$('#tr1').show();
		$('#tr2').show();
	}
}

function ocultaTR1(oculta){
	if(oculta){
		$('#tr1').hide();
		$('#tipoDispersion').val('');
		ocultaMontoCargo(oculta);
	} else {
		$('#tr1').show();
	}
}

function ocultaTR2(oculta){
	if(oculta){
		$('#tr2').hide();
		$('#nivel').val('');
		$('#montoCargo').val('0.00');
		ocultaMontoCargo(true);
	} else {
		$('#tr2').show();
	}
}

function ocultaTipoCargo(oculta){
	if(oculta){
		$('#tipoCargo1').hide();
		$('#tipoCargo2').hide();
		$('#tipoCargo').val('');
	} else {
		$('#tipoCargo1').show();
		$('#tipoCargo2').show();
	}
}

function ocultaMontoCargo(oculta){
	if(oculta){
		$('#montoCargo1').hide();
		$('#montoCargo2').hide();
		$('#montoCargo').val('0.00');
	} else {
		$('#montoCargo1').show();
		$('#montoCargo2').show();
	}
}