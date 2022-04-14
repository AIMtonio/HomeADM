var esTab;
var tab2 = false;

var cat_IngresosEgresos = {
		'alta' 		: 1,
		'modifica'	: 2
};
$(document).ready(function() {
	$('#tipo').focus();

	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	$(':text').focus(function() {
		esTab = false;
	});

	$('#tipo').blur(function() {
		var tipo =  $('#tipo').val();

		if(tipo != ""){			
			inicializar();
			$('#numero').focus();
		}
		else{
			limpiaCampos();			
			deshabilitaControl('numero');
			deshabilitaControl('estatus');
			deshabilitaControl('descripcion');
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('modificar', 'submit');	
		}
		
	});

	$('#numero').bind('keyup', function(e) {

		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		camposLista[2] = "tipo";
		parametrosLista[0] = $('#numero').val();
		parametrosLista[2] = $('#tipo').val();  
		lista('numero', '1', '1', camposLista, parametrosLista, 'catListaIngresosEgresosLista.htm');
	});

	$('#numero').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
				
		if (isNaN($('#numero').val())) { 			
			$('#numero').val("");
			$('#numero').focus();
			tab2 = false;
		} else {
			if ($('#numero').asNumber()==0 && esTab) {		
				habilitaBoton('grabar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				$("#descripcion").val("");
				$("#estatus").val("");
						
			}else{
				if (tab2 == false && esTab) { 
					esTab = true;
					consultaLista(this.id);
					
				}

			}
		}
	});
	
	$('#formaGenerica').validate({
		rules : {
		numero : {
			required : true
		},
		tipo : {
			required : true
		},
		descripcion : {
			required : true
		},
		estatus : {
			required : true
		}
	},
	messages : {
		numero : {
			required : 'Especifique el Número.'
		},
		tipo : {
			required : 'Especifique el Tipo de Lista.'
		},
		descripcion : {
			required : 'La Descripción es Requerida.'
		},
		estatus : {
			required : 'El Estatus es Requerido.'
		}
	}
	});

	$('#grabar').click(function(event) {
		$('#tipoTransaccion').val(cat_IngresosEgresos.alta);
		if ($("#formaGenerica").valid()) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'numero', 'exito', 'error');
		}
	});
	$('#modificar').click(function(event) {
		$('#tipoTransaccion').val(cat_IngresosEgresos.modifica);
		if ($("#formaGenerica").valid()) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'numero', 'exito', 'error');
		}
	});
});

function consultaLista(idControl) {
	var jqLista = eval("'#" + idControl + "'");
	var numero = $(jqLista).val();
	var principal = 1;
	var tipo = $("#tipo").val();
	
	var catIngresoEgresoBean = {
		'numero' : numero,
		'tipo'	 : tipo
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numero != '' && esTab) {
		catIngresosEgresosServicio.consulta(principal, catIngresoEgresoBean, function(bean) {
			if (bean != null) {
				dwr.util.setValues(bean);
				deshabilitaBoton('grabar', 'submit');
				habilitaBoton('modificar', 'submit');
			} else {
				if(tipo == "I"){
					mensajeSis("El tipo de Ingreso no fue Encontrado");
					
				}else{
					mensajeSis("El tipo de Egreso no fue Encontrado");

				}
				$("#numero").focus();
				limpiaCampos();
				
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				
			}
		});
	}
}
function inicializar() {	
	habilitaControl('numero');
	habilitaControl('estatus');
	habilitaControl('descripcion');
	limpiaCampos();
	
}
function exito() {
	$('#tipo').val("");
	limpiaCampos();
	deshabilitaControl('numero');
	deshabilitaControl('estatus');
	deshabilitaControl('descripcion');
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');

}
function limpiaCampos(){
	$('#numero').val("");
	$('#descripcion').val("");
	$('#estatus').val("");

}
function error() {
}
