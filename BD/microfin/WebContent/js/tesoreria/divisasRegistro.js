$(document)	.ready(	function() {
//	Definicion de Constantes y Enums  
	var esTab = false;
	var catTipoTransaccionDivisa = {
			'agrega' : '1',
			'modifica' : '2',
			'elimina' : '3'
	};

	var catTipoConsultaDivisa = {
			'resumen' : '3'
	};

	$('#monedaId').focus();
//	------------ Msetodos y Manejo de Eventos -----------------------------------------

	actualizaFormatosMoneda('formaGenerica');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');

	$.validator.setDefaults({submitHandler : function(event) {
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true', 'monedaId', 'exito', 'error');
	}});

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#monedaId').focus(function() {	
		deshabilitaBoton('modifica', 'submit');
	});

	$('#monedaId').blur(function() {
		buscarDivisa(this.id); 
	});

	$('#monedaId').bind('keyup',function(e){
		lista('monedaId', '0', 2, 'monedaID', $('#monedaId').val(), 'listaMonedas.htm');
	});

	$('#agrega').click(function(event) {
		$('#tipoTransaccion').val(catTipoTransaccionDivisa.agrega);
	});

	$('#modifica').click(function(event) {
		$('#tipoTransaccion').val(catTipoTransaccionDivisa.modifica);		
	});


	//------------ Validaciones de la Forma -------------------------------------	

	$('#formaGenerica').validate({
		rules : {	
			monedaId:	 {
				number: true,
				required: true
			},	
			tipCamComVen: {
				required: true,
				number: true,
				min: 1
			},
			tipCamVenVen: {
				required: true,
				number: true,
				min: 1
			},
			tipCamComInt: {
				required: true,
				number: true,
				min: 1
			},
			tipCamVenInt: {
				required: true,
				number: true,
				min: 1
			},
			tipCamFixCom: {
				required: true,
				number: true,
				min: 1
			},
			tipCamFixVen: {
				required: true,
				number: true,
				min: 1
			},
			tipCamDof: {
				required: true,
				number: true,
				min: 1
			},
			descripcion : {
				required: true
			},
			descriCorta : {
				required: true
			},
			simbolo 	: {
				required: true
			},
			tipoMoneda 	: {
				required:true
			},
			eqCNBVUIF 	: {
				required: true
			}
		},

		messages : {
			monedaId:	 {
				number: 'Sólo números.',
				required: 'El Número de Divisa es Requerido.'
			},	
			tipCamComVen: {
				required: 'La compra es requerida.',
				number: 'Sólo números.',
				min: 'El Valor no debe ser menor o igual a 0.'
			},
			tipCamVenVen: {
				required:'La venta es requerida.',
				number: 'Sólo números.',
				min: 'El Valor no debe ser menor o igual a 0.'
			},
			tipCamComInt: {
				required: 'La compra es requerida.',
				number: 'Sólo números.',
				min: 'El Valor no debe ser menor o igual a 0.'
			},
			tipCamVenInt: {
				required:'La venta es requerida.',
				number: 'Sólo números.',
				min: 'El Valor no debe ser menor o igual a 0.'
			},
			tipCamFixCom: {
				required: 'La compra es requerida.',
				number: 'Sólo números.',
				min: 'El Valor no debe ser menor o igual a 0.'
			},
			tipCamFixVen: {
				required: 'La venta es requerida.',
				number: 'Sólo números.',
				min: 'El Valor no debe ser menor o igual a 0.'

			},
			tipCamDof: {
				required:'El tipo de Cambio es requerido.',
				number: 'Sólo números.',
				min: 'El Valor no debe ser menor o igual a 0.'
			},
			descripcion : {
				required : 'El campo Descripción es requerido.'
			},
			descriCorta :{
				required:'La Descripción corta es requerida.'
			},
			simbolo 	:{
				required:'El campo simbolo es requerido.'
			},
			tipoMoneda 	: {
				required:'El tipo de moneda es requerido.'
			},
			eqCNBVUIF 	: {
				required:'El equivalente CNBV es requerido.'
			}
		}
	});

	//------------ Validaciones de Controles -------------------------------------
	function buscarDivisa(monedaID) {
		var monedaid = eval("'#" + monedaID + "'");
		var monedaNum = $(monedaid).val();
		if(monedaNum != '' && !isNaN(monedaNum) && esTab) {
			if(monedaNum=='0'){
				limpiaFormaCompleta('formaGenerica', true, [ 'monedaId' ]);
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
			} else {
				var divisaBean = {
						'monedaId' : monedaNum
				};
				divisasServicio.consultaExisteDivisa(3,divisaBean,function(divisa) {
					if (divisa != null) {
						dwr.util.setValues(divisa);
						deshabilitaBoton('agrega','submit');
						habilitaBoton('modifica','submit');
					} else {
						mensajeSis("No Existe la Divisa.");
						exito();
						$('#monedaId').focus();
						$('#monedaId').select();	
					}
				});
			}
		}
	}
});

function exito(){
	limpiaFormaCompleta('formaGenerica', true, [ 'monedaId' ]);
	deshabilitaBoton('agrega','submit');
	deshabilitaBoton('modifica','submit');
}

function error(){

}