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

	/*	var f = new Date();
	var dia = (f.getMonth()+1);
	var mes = f.getDate();
	if(dia<10) dia = '0'+dia;
	if(mes<10) mes = '0'+mes;
	$('#fechaInicio').val(f.getFullYear()+'-'+dia+'-'+mes);
	$('#fechaFin').val(f.getFullYear()+'-'+dia+'-'+mes);*/

	$('#imprimir').click(function() {		
		var fechaInicio = $('#fechaInicio').val();
		var fechaFin = $('#fechaFin').val();
		if(fechaInicio=='' || fechaFin==''){
			alert("La fecha esta vacía");

		}
		else{
			if(fechaInicio>fechaFin){
				alert("La Fecha Final no debe de ser menor que la Fecha Inicial");
			}
			else{
				var pagina= 'BitacoraBatchPLDRep.htm?fechaInicio='+fechaInicio+'&fechaFin='+fechaFin;
				window.open(pagina,'_blank');
			}
		}
	});

});