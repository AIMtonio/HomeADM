$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	parametros = consultaParametrosSession();

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	$('#fechaInicio').val(parametros.fechaAplicacion); 	
	$('#fechaFin').val(parametros.fechaAplicacion);

	$(':text').focus(function() {	
		esTab = false;
	});

	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({

		rules: {

			fechaInicio: {
				required: true,
				date: true
			},

			fechaFin: {
				required: true,
				date: true
			}
		},		
		messages: {


			fechaInicio: {
				required: 'Especifica Fecha.',
				date: 'Fecha incorrecta'
			},

			fechaFin: {
				required: 'Especifica Fecha.',
				date: 'Fecha incorrecta'
			}

		}		
	});
	//------------ Validaciones de la Forma -------------------------------------

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#imprimir').click(function() {		
		var fechaInicio = $('#fechaInicio').val();
		var fechaFin = $('#fechaFin').val();
		var etiquetaSocio = $('#alertSocio').val();
		var fechaSistema = parametros.fechaAplicacion;
		var nombreUsuario =parametros.claveUsuario;
		var nombreInstitucion=parametros.nombreInstitucion;
		if(fechaInicio=='' || fechaFin==''){
			alert("La fecha esta vacía");

		} else {
			if(fechaInicio>fechaFin){
				alert("La Fecha Final no debe de ser menor que la Fecha Inicial");
			} else {
				var pagina= 'paramSegtoOperRep.htm?fechaInicio='+fechaInicio+'&fechaFin='+fechaFin
							+'&fechaSistema='+fechaSistema+'&nombreUsuario='+nombreUsuario.toUpperCase()+'&nombreInstitucion='+nombreInstitucion
							+'&etiquetaSocio='+etiquetaSocio;
				window.open(pagina,'_blank');
			}
		}
	});

});

