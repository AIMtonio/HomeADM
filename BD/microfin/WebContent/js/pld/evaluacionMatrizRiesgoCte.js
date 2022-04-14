var Enum_Constantes = {
	'SI' : 'S',
	'NO' : 'N'
};

var Enum_TipoTransaccion = {
	'evaluacionManual' : 2  
};

var EjecucionProceso = 'N';
var FechaEjecucion = '1900-01-01';

$(document).ready(function() {
	agregaFormatoControles('formaGenerica');

	var parametroBean = consultaParametrosSession();

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$.validator.setDefaults({
		submitHandler: function(event) {
			if(confirm('¿Está seguro que desea ejecutar el proceso?')){
				if(EjecucionProceso == Enum_Constantes.SI){
					mensajeSis('El proceso de evaluación ya fue ejecutado en este día.\nÚltima ejecución del proceso: '+ FechaEjecucion+'.');
					deshabilitaBoton('procesar');
				} else {
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','fechaEvaluar','funcionExito','funcionError');
				}
			}
		}
	});
    
	$('#procesar').focus();
	$('#procesar').click(function() {
		$('#tipoTransaccion').val(Enum_TipoTransaccion.evaluacionManual);
	});

	$('#fechaEvaluar').val(parametroBean.fechaAplicacion);
	consultaEjecucion();
    
	$('#formaGenerica').validate({
		rules: {
			fechaEvaluar: {
				required: true
			}
		},
		messages: {
			fechaEvaluar: {
				required: 'Especifíque la fecha.'
			}
		}
	});

});
/**
 * Comprueba si el proceso de evaluación de la matriz ya fue ejecutado en la fecha del sistema.
 * @author avelasco
 */
function consultaEjecucion(){
	var bean = {
		procesoBatchID : 505,
		fecha: $('#fechaEvaluar').val().trim()
	};

	var consultaExiste = 2;

	bitacoraBatchServicio.consulta(consultaExiste, bean, function(datos){
		if (datos != null ){
			EjecucionProceso = datos.existeEjecucion;
			FechaEjecucion = (datos.fecha).trim().replace('.0','');
		} else {
			EjecucionProceso = Enum_Constantes.NO;
			FechaEjecucion = '1900-01-01';
		}
	});
}

function funcionExito(){
	consultaEjecucion();
}

function funcionError(){
	consultaEjecucion();
}