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
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'uniConceptoInvID', 'funcionExito', 'funcionError');
		}
	
	});
	// Validaciones de la Forma 
	$('#formaGenerica').validate({
		rules : {
			uniConceptoInvID : {
				required : true
			},
			clave : {
				required : true
			},
			unidad : {
				required : true
			}
		},
		messages : {
			uniConceptoInvID : {
				required : 'El Número de la Unidad es Requerido.'
			},
			clave : {
				required : 'La Clave de la Unidad es Requerida.'
			},
			unidad : {
				required : 'La Unidad es Requerida.'
			}
		}
	});
	// Agrega el valior de la transaccion a el boton agregar 
	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.agrega);
	});
	// Agrega el valior de la transaccion a el boton modificar 
	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.modifica);
	});
	// Lista los conceptos
	$('#uniConceptoInvID').bind('keyup', function(e) {
		lista('uniConceptoInvID', '1', '1', 'clave', $('#uniConceptoInvID').val(), 'listaUnidadConceptoInvAgro.htm');
	});
	//Consulta si el valor ingresado en la caja uniConceptoInvID es número y si éste existe
	$('#uniConceptoInvID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		
		consultaUnidad(this.id);
	});

});
//Funcion que consulta la unidad
function consultaUnidad(){
	var unidad = $("#uniConceptoInvID").asNumber();
	var principal = 1;
	var bean = {
		'uniConceptoInvID' : unidad
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (unidad != 0 && esTab && unidad != ' ' && !isNaN(unidad)) { 
		uniConceptosInvAgroServicio.consulta(principal,bean,{ callback:function(bean) {
			if (bean != null) {
				dwr.util.setValues(bean);
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
			} else {
				mensajeSis("El Número de Unidad No Existe.");
				inicializa();
			}
		},errorHandler:function(message) {
			mensajeSis("Error al Consultar la Unidad.<br>"+message)
		}
		});
	} else {
		limpiaFormaCompleta('formaGenerica',true,['uniConceptoInvID']);
		habilitaBoton('agrega', 'submit');
		deshabilitaBoton('modifica', 'submit');
	}
}

   //Inicializa los valores de la forma 
function inicializa() {
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	limpiaFormaCompleta('formaGenerica',true,['uniConceptoInvID']);
	agregaFormatoControles('formaGenerica');
	$('#uniConceptoInvID').focus();
}
   //Si la transaccion se hace correctamente limpia la forma exepto uniConceptoInvID
function funcionExito(){
	inicializaForma('formaGenerica','uniConceptoInvID');
}
  //Si la transaccion no se hace correctamente 
function funcionError(){
	
}

    	