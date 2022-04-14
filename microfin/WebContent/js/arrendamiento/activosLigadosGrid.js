$(document).ready(function() {
	var tipoTransaciones = {
			'agregar' : 1
	};
	
	$(':button, :submit').focus(function() {
	 	esTab = false;
	});
	
	$(':button, :submit').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#grabar').blur(function() {
		if (esTab) {
			$("#arrendaID").focus();
		}
	});
	
	$('#grabar').click(function() {
		$('#tipoTransaccion').val(tipoTransaciones.agregar);
	});
});// fin del Document

function eliminarParam(id) {
	$('#'+id).remove();
}
