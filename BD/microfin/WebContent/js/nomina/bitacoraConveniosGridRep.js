$(document).ready(function() {
	esTab = false;
	agregaFormatoControles('formaGenerica');

	$(':text, :button, :submit, select').focus(function() {
		esTab = false;
	});

	$(':text, :button, :submit, select').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text, :button, :submit, textarea, select').blur(function() {
		if($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout( function() {
				$('#institNominaID').focus();
			}, 0);
		}
	});
});