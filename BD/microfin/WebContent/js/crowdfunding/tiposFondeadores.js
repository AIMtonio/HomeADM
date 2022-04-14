esTab = true;

//Definicion de Constantes y Enums
var catTipoTransaccionFondeador = {
	'agrega':'1',
	'modifica':'2'	,
	'elimina':'3'};

var catTipoConsultaFondeador = {
	'principal'	: 1

};
$(document).ready(function() {
	//------------ Msetodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('elimina', 'submit');
	agregaFormatoControles('formaGenerica');

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
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoFondeadorID','exito','error');
		}
	});

	$('#tipoFondeadorID').focus();

	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionFondeador.agrega);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionFondeador.modifica);
	});

	$('#elimina').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionFondeador.elimina);
	});

	$('#tipoFondeadorID').blur(function() {
  		validaFondeador(this.id);
	});

	$('#tipoFondeadorID').bind('keyup',function(e){
		lista('tipoFondeadorID', '1', '1', 'descripcion', $('#tipoFondeadorID').val(), 'listaFondeoCrwLista.htm');
	});

	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			tipoFondeadorID: {
				required: true
			},
			descripcion: {
				required: true
			},
			porcentajeMora: {
				required: true
			},
			porcentajeComisi: {
				required: true
			}
		},
		messages: {
			tipoFondeadorID: {
				required: 'Especificar No.'
			},
			descripcion: {
				required: 'Especificar Descripción'
			},
			porcentajeMora: {
				required: 'Especifica el Porcentaje'
			},
			porcentajeComisi: {
				required: 'Especifica el porcentaje'
			}
		}
	});
});



//------------ Validaciones de Controles -------------------------------------

function validaFondeador(control) {
	var numfondeador = $('#tipoFondeadorID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numfondeador != '' && !isNaN(numfondeador) && esTab){
		if(numfondeador=='0'){
			habilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
			deshabilitaBoton('elimina', 'submit');
			limpiaFormaCompleta('formaGenerica', true, [ 'tipoFondeadorID' ]);
			$('#esObligadoSolNo').attr("checked",true);
			$('#pagoEnIncumpleNo').attr("checked",true);
			$('#estatus').val('VIGENTE');
		} else {
			var fondeadorBeanCon = {
				'tipoFondeadorID':$('#tipoFondeadorID').val()
			};

			tiposFondeadoresServicio.consulta(catTipoConsultaFondeador.principal,fondeadorBeanCon,function(fondeadores) {
				if(fondeadores!=null){
					dwr.util.setValues(fondeadores);

					if(fondeadores.estatus=='V'){
						$('#estatus').val('VIGENTE');
						habilitaBoton('modifica', 'submit');
						habilitaBoton('elimina', 'submit');
					} else {
						$('#estatus').val('INACTIVO');
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('elimina', 'submit');
					}
					deshabilitaBoton('agrega', 'submit');
				}else{
					mensajeSis("No Existe el fondeador.");
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('elimina', 'submit');
					limpiaFormaCompleta('formaGenerica', true, [ 'tipoFondeadorID' ]);
					$('#esObligadoSolNo').attr("checked",true);
					$('#pagoEnIncumpleNo').attr("checked",true);
					$('#tipoFondeadorID').select();
				}
			});
		}
	}
}

function exito(){
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('elimina', 'submit');
	limpiaFormaCompleta('formaGenerica', true, [ 'tipoFondeadorID' ]);
	agregaFormatoControles('formaGenerica');
}

function error(){
	agregaFormatoControles('formaGenerica');
}