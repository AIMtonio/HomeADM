$(document).ready(function() {
	$(':button, :submit').focus(function() {
		esTab = false;
	});
	
	$(':button, :submit').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('input:checkbox').focus(function() {
		esTab = false;
	});
	
	$('input:checkbox').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#btnAnterior, #btnSiguiente, :input:checkbox').blur(function() {
		if($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout( function() {
				$('#radioBuscarPor').focus();
			}, 0);
		}
	});
	
	$("#seleccionTodosPagina").click(function() {
		if($("#seleccionTodosPagina").is(':checked')) {
			for(var casilla = 1; casilla <= 25; casilla++){
				$("#seleccion"+casilla).attr('checked', true);
				$("#seleccion"+casilla).change();
			}
		} else {
			for(var casilla = 1; casilla <= 25; casilla++){
				$("#seleccion"+casilla).attr('checked', false);
				$("#seleccion"+casilla).change();
			}
			$("#seleccionTodos").attr('checked', false);
		}
	});
	
	$('input:checkbox').change(function () {
		var checkboxHabilitados = $('input:checkbox[name="seleccion"]').filter(":checked").length;
		if (checkboxHabilitados == 0) {
			deshabilitaBoton('enviar', 'submit');
		} else {
			habilitaBoton('enviar', 'submit');
		}
	});
	
	$('input:checkbox[name="seleccion"]').change(function () {
		if ($(this).is(':checked')) {
			$('#anioMes' + this.value).attr('name', 'listaPeriodos');
			$('#sucursalID' + this.value).attr('name', 'listaSucursales');
			$('#clienteID' + this.value).attr('name', 'listaClientes');
			$('#correo' + this.value).attr('name', 'listaCorreos');
			$('#rutaPDF' + this.value).attr('name', 'listaPDF');
			$('#rutaXML' + this.value).attr('name', 'listaXML');
		} else {
			$('#anioMes' + this.value).removeAttr('name');
			$('#sucursalID' + this.value).removeAttr('name');
			$('#clienteID' + this.value).removeAttr('name');
			$('#correo' + this.value).removeAttr('name');
			$('#rutaPDF' + this.value).removeAttr('name');
			$('#rutaXML' + this.value).removeAttr('name');
		}
	});
	
	$("#seleccionTodos").click(function() {
		if($("#seleccionTodos").is(':checked')) {
			$("#seleccionTodosPagina").attr('checked', true);
			for(var casilla = 1; casilla <= 25; casilla++){
				$("#seleccion" + casilla).attr('checked', true);
			}
			habilitaBoton('enviar', 'submit');
			$('#btnAnterior').hide();
			$('#btnSiguiente').hide();
		} else {
			$("#seleccionTodosPagina").attr('checked', false);
			for(var casilla = 1; casilla <= 25; casilla++){
				$("#seleccion" + casilla).attr('checked', false);
			}
			deshabilitaBoton('enviar', 'submit');
			$('#btnAnterior').show();
			$('#btnSiguiente').show();
		}
		
		for(var casilla = 1; casilla <= 25; casilla++){
			$('#anioMes' + casilla).removeAttr('name');
			$('#sucursalID' + casilla).removeAttr('name');
			$('#clienteID' + casilla).removeAttr('name');
			$('#correo' + casilla).removeAttr('name');
			$('#rutaPDF' + casilla).removeAttr('name');
			$('#rutaXML' + casilla).removeAttr('name');
		}
	});
	
	$(".iconoPDF").click(function(){
		var pagina ='reporteEdoCta.htm?rutaPDF=' + this.title;
		window.open(pagina,'_blank');
	});
	
	$(".iconoXML").click(function(){
		var pagina ='xmlEdoCta.htm?rutaXML=' + this.title;
		window.open(pagina,'_blank');
	});
});

function cambioPaginaGridEdoCtaEnvioCorreo(valorPagina){
	var params = {};
	params['anioMes'] = $('#anioMes').val();
	params['clienteID'] = $('#clienteID').val();
	params['tipoLista'] = $('#tipoLista').val();
	params['page'] = valorPagina;
	$.post("edoCtaEnvioCorreoGridVista.htm", params, function(data){
			if(data.length > 0) {
				$('#formaTabla').html(data);
				$('#formaTabla').show();
				$('#enviar').show();
				if($('#numeroRegistros').val() <= 0) {
					mensajeSis('No se encontraron estados de cuenta pendientes por enviar');
					$('#enviar').hide();
					$('#anioMes').focus();
				}
			} else {
				mensajeSis("Error al generar la lista");
				$('#formaTabla').hide();
				$('#enviar').hide();
			}
	}).fail(function() {
		mensajeSis("Error al generar el grid");
		$('#formaTabla').hide();
		$('#enviar').hide();
	});
}