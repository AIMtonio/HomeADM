//Definicion de Constantes y Enums
var parametroBean = '';
var EstaActivoCRW = 'N';
var catTipoTransaccionParam = {
	'agregar':1,
	'modificar':2,
};

var catTipoConsultaParam = {
	'principal':1,
	'foranea':2
};

$(document).ready(function() {
	esTab = true;

	parametroBean = consultaParametrosSession();
	inicializaPantalla();
	agregaFormatoControles('formaGenerica');
	$('#habilitaFondeoSi').focus();
	 //------------ Metodos y Manejo de Eventos -----------------------------------------

	deshabilitaBoton('grabar', 'submit');

	$(':text').focus(function() {
	 	esTab = false;
	});

	$.validator.setDefaults({
      submitHandler: function(event) {
      quitaFormatoControles('formaGenerica');
      	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','productoCreditoID','exito','error');
      }

   });

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#agregar').click(function() {
	});

	$('#modificar').click(function() {
	});

	$('input[name="habilitaFondeo"]').change(function (event){
		muestraCampos(false);
	});

	$('#productoCreditoID').bind('keyup',function(e){
		lista('productoCreditoID', '1', '1', 'descripcion', $('#productoCreditoID').val(), 'listaProductosCredito.htm');
	});

	$('#productoCreditoID').blur(function() {
		consultaProducCredito(this.id);
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {

			habilitaFondeo: {
				required : true,
			},

			productoCreditoID: {
				required : function() { return $('input[name=habilitaFondeo]:checked').val()==='S';}
			},

			formulaRetencion: {
				required : function() { return $('input[name=habilitaFondeo]:checked').val()==='S';}
			},
			tasaISR: {
				required : function() { return $('input[name=habilitaFondeo]:checked').val()==='S';},
				numeroPositivo:true
			},
			porcISRMoratorio: {
				required : function() { return $('input[name=habilitaFondeo]:checked').val()==='S';},
				numeroPositivo: true
			},
			porcISRComision: {
				required : function() { return $('input[name=habilitaFondeo]:checked').val()==='S';},
				numeroPositivo: true
			},
			minPorcFonProp: {
				required : function() { return $('input[name=habilitaFondeo]:checked').val()==='S';},
				numeroPositivo: true
			},
			maxPorcPagCre: {
				required : function() { return $('input[name=habilitaFondeo]:checked').val()==='S';},
				numeroPositivo: true
			},
			maxDiasAtraso: {
				required : function() { return $('input[name=habilitaFondeo]:checked').val()==='S';},
				numeroPositivo: true
			},
			diasGraciaPrimVen: {
				required : function() { return $('input[name=habilitaFondeo]:checked').val()==='S';},
				numeroPositivo: true
			}

		},
		messages: {

			habilitaFondeo: {
				required: 'Especificar Si se Habilita el Fondeo.',
			},
			productoCreditoID: {
				required: 'Especificar Producto de Crédito.',
				numeroPositivo : 'Solo Numeros Positivos'
			},
			formulaRetencion: {
				required: 'Especificar Formula',
				numeroPositivo : 'Solo Numeros Positivos'
			},
			tasaISR: {
				required: 'Especificar Tasa',
				numeroPositivo:'Solo Numeros Positivos'
			},
			porcISRMoratorio: {
				required: 'Especificar Porcentaje',
				numeroPositivo: 'Solo Numeros Positivos'
			},
			porcISRComision: {
				required: 'Especificar Porcentaje',
				numeroPositivo: 'Solo Numeros Positivos'
			},
			minPorcFonProp: {
				required: 'Especificar Porcentaje',
				numeroPositivo: 'Solo Numeros Positivos'
			},
			maxPorcPagCre: {
				required: 'Especificar Porcentaje',
				numeroPositivo: 'Solo Numeros Positivos'
			},
			maxDiasAtraso: {
				required: 'Especificar Dias',
				numeroPositivo: 'Solo Numeros Positivos'
			},
			diasGraciaPrimVen: {
				required: 'Especificar Dias',
				numeroPositivo: 'Solo Numeros Positivos'
			}
		}
	});
});

//------------ Validaciones de Controles -------------------------------------
function consultaParametros() {
	var parametrosBeanCon = {
		'productoCreditoID':$('#productoCreditoID').val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if($('#productoCreditoID').asNumber()>0 && esTab){
		parametrosCRWServicio.consulta(catTipoConsultaParam.principal, parametrosBeanCon,function(parametros) {
			if(parametros!=null){
				$('#formulaRetencion').val(parametros.formulaRetencion);
				$('#tasaISR').val(parametros.tasaISR);
				$('#porcISRMoratorio').val(parametros.porcISRMoratorio);
				$('#porcISRComision').val(parametros.porcISRComision);
				$('#minPorcFonProp').val(parametros.minPorcFonProp);
				$('#maxPorcPagCre').val(parametros.maxPorcPagCre);
				$('#maxDiasAtraso').val(parametros.maxDiasAtraso);
				$('#diasGraciaPrimVen').val(parametros.diasGraciaPrimVen);
				$('#tipoTransaccion').val(catTipoTransaccionParam.modificar);
			}else{
				$('#tipoTransaccion').val(catTipoTransaccionParam.agregar);
				limpiaFormaCompleta('formaGenerica', true, [ 'habilitaFondeoSi', 'habilitaFondeoNo', 'productoCreditoID', 'descripcion', 'tipoTransaccion' ]);
			}
		});
	}
}

function habilitaFondeoCRW(idClass,muestra){
	mostrarElementoPorClase(idClass,muestra);
}

function consultaProducCredito(idControl) {
	var jqProdCred  = eval("'#" + idControl + "'");
	var ProdCred = $(jqProdCred).val();
	var ProdCredBeanCon = {
			'producCreditoID':ProdCred
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(ProdCred != '' && !isNaN(ProdCred) && esTab){
		productosCreditoServicio.consulta(catTipoConsultaParam.principal,ProdCredBeanCon,{ async: false, callback:function(prodCred) {
			if(prodCred!=null){
				$('#descripcion').val(prodCred.descripcion);
				consultaParametros();
				habilitaBoton('grabar', 'submit');
			} else {
				mensajeSis("No Existe el Producto de Crédito.");
				$('#productoCreditoID').focus();
				$('#productoCreditoID').select();
				deshabilitaBoton('grabar', 'submit');
				exito();
			}
		}});
	}
}

function exito(){
	deshabilitaBoton('grabar', 'submit');
	limpiaFormaCompleta('formaGenerica', true, [ 'habilitaFondeoSi', 'habilitaFondeoNo', 'productoCreditoID' ]);
	agregaFormatoControles('formaGenerica');
}

function error(){
	agregaFormatoControles('formaGenerica');
}
function consultaModuloHabilitado(){
	var tipoConsulta = 38;
	paramGeneralesServicio.consulta(tipoConsulta,{ async: false, callback: function(valor){
		if(valor!=null){
			EstaActivoCRW = valor.valorParametro;
		} else {
			EstaActivoCRW = 'N';
		}
	}});
}
function muestraCampos(esXParametro){
	if(!esXParametro){
		EstaActivoCRW = $('input[name=habilitaFondeo]:checked').val();
	}
	if(EstaActivoCRW==='N'){
		$('#habilitaFondeoNo').attr("checked",true);
		limpiaFormaCompleta('formaGenerica', true, [ 'habilitaFondeoSi', 'habilitaFondeoNo' ])
		habilitaBoton('grabar', 'submit');
	} else {
		$('#habilitaFondeoSi').attr("checked",true);
	}

	habilitaFondeoCRW('tdhabilitaFondeo',$('input[name=habilitaFondeo]:checked').val());
}
function inicializaPantalla(){
	consultaModuloHabilitado();
	muestraCampos(true);
}