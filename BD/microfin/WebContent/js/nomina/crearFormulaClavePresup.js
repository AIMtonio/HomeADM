var formula = "";
var desFormula = "";

$(document).ready(function(){
	esTab = true;

	consultaGridClavePresup();

	$.validator.setDefaults({submitHandler : function(event) {
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','formula','exitoTransParametro','falloTransParametro');
		}
	});

	/***********MANEJO DE EVENTOS******************/
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab = true;
		}
	});

	$('#limpiar').click(function() {
		$('#formula').val("");
		$('#desFormula').val("");
	});

	$('#operadorMas').click(function() {
		var operadorMas = $('#operadorMas').val();

		desFormula = $('#desFormula').val();
		formula = $('#formula').val();

		if(desFormula != ""){
			desFormula += operadorMas + " ";
			$('#desFormula').val(desFormula);

			formula += operadorMas;
			$('#formula').val(formula);
		}else{
			desFormula += operadorMas + " ";
			$('#desFormula').val(desFormula);

			formula += operadorMas;
			$('#formula').val(formula);
		}
	});

	$('#operadorMeno').click(function() {
		var operadorMeno = $('#operadorMeno').val();

		desFormula = $('#desFormula').val();
		formula = $('#formula').val();

		if(desFormula != ""){
			desFormula += operadorMeno + " ";
			$('#desFormula').val(desFormula);

			formula += operadorMeno;
			$('#formula').val(formula);
		}else{
			desFormula += operadorMeno + " ";
			$('#desFormula').val(desFormula);

			formula += operadorMeno;
			$('#formula').val(formula);
		}
	});

	$('#operadorMult').click(function() {
		var operadorMult = $('#operadorMult').val();

		desFormula = $('#desFormula').val();
		formula = $('#formula').val();

		if(desFormula != ""){
			desFormula += operadorMult + " ";
			$('#desFormula').val(desFormula);

			formula += operadorMult;
			$('#formula').val(formula);
		}else{
			desFormula += operadorMult + " ";
			$('#desFormula').val(desFormula);

			formula += operadorMult;
			$('#formula').val(formula);
		}
	});

	$('#operadorDiv').click(function() {
		var operadorDiv = $('#operadorDiv').val();

		desFormula = $('#desFormula').val();
		formula = $('#formula').val();

		if(desFormula != ""){
			desFormula += operadorDiv + " ";
			$('#desFormula').val(desFormula);

			formula += operadorDiv;
			$('#formula').val(formula);
		}else{
			desFormula += operadorDiv + " ";
			$('#desFormula').val(desFormula);

			formula += operadorDiv;
			$('#formula').val(formula);
		}
	});

	$('#operadorParantesi').click(function() {
		var operadorParantesi = $('#operadorParantesi').val();

		desFormula = $('#desFormula').val();
		formula = $('#formula').val();

		if(desFormula != ""){
			desFormula += operadorParantesi + " ";
			$('#desFormula').val(desFormula);

			formula += operadorParantesi;
			$('#formula').val(formula);
		}else{
			desFormula += operadorParantesi + " ";
			$('#desFormula').val(desFormula);

			formula += operadorParantesi;
			$('#formula').val(formula);
		}
	});

	$('#operadorParantesi2').click(function() {
		var operadorParantesi2 = $('#operadorParantesi2').val();

		desFormula = $('#desFormula').val();
		formula = $('#formula').val();

		if(desFormula != ""){
			desFormula += operadorParantesi2 + " ";
			$('#desFormula').val(desFormula);

			formula += operadorParantesi2;
			$('#formula').val(formula);
		}else{
			desFormula += operadorParantesi2 + " ";
			$('#desFormula').val(desFormula);

			formula += operadorParantesi2;
			$('#formula').val(formula);
		}
	});

	$('#desResguardo').click(function() {
		var desResguardo = $('#desResguardo').val();
		var resguardo = $('#resguardo').val();

		desFormula = $('#desFormula').val();
		formula = $('#formula').val();

		if(desFormula != ""){
			desFormula += desResguardo + " ";
			$('#desFormula').val(desFormula);

			formula += resguardo;
			$('#formula').val(formula);


		}else{
			desFormula += desResguardo + " ";
			$('#desFormula').val(desFormula);

			formula += resguardo;
			$('#formula').val(formula);
		}
	});

	$('#descDeudaCasaComer').click(function() {
		var descDeudaCasaComer = $('#descDeudaCasaComer').val();
		var deudaCasaComercial = $('#deudaCasaComercial').val();

		desFormula = $('#desFormula').val();
		formula = $('#formula').val();

		if(desFormula != ""){
			desFormula += descDeudaCasaComer + " ";
			$('#desFormula').val(desFormula);

			formula += deudaCasaComercial;
			$('#formula').val(formula);


		}else{
			desFormula += descDeudaCasaComer + " ";
			$('#desFormula').val(desFormula);

			formula += deudaCasaComercial;
			$('#formula').val(formula);
		}
	});

	$('#descPorcCapaci').click(function() {
		var descPorcCapaci = $('#descPorcCapaci').val();
		var porcentajeCapacidad = $('#porcentajeCapacidad').val();

		desFormula = $('#desFormula').val();
		formula = $('#formula').val();

		if(desFormula != ""){
			desFormula += descPorcCapaci + " ";
			$('#desFormula').val(desFormula);

			formula += porcentajeCapacidad;
			$('#formula').val(formula);


		}else{
			desFormula += descPorcCapaci + " ";
			$('#desFormula').val(desFormula);

			formula += porcentajeCapacidad;
			$('#formula').val(formula);
		}
	});


	$('#formaGenerica').validate({
		rules : {
		},

		messages : {
		}
	});
});

	function exitoTransParametro(){
	}

	function falloTransParametro(){
	}


	/* ========================== FUNCION CONSULTAR GRID CLASIFICACION DE CLAVE PRESUPUESTAL ====================*/
	function consultaGridClavePresup(){
		var params = { };
		params['tipoLista'] = 2;

		$.post("crearFromulaClaveGridVista.htm", params, function(data){
			if(data.length > 0) {
				$('#gridClasifClave').html(data);
				$('#gridClasifClave').show();
			}else{
				$('#gridClasifClave').html("");
				$('#gridClasifClave').show();
			}
		});
	}

	function creaFormulaCap(control){
		var numero = control.substr(7,control.length);

		var jqIdAsignadoClaveID = eval("'claveID" + numero+ "'");
		var jqIdAsignadoDesClave = eval("'desClave" + numero+ "'");

		desFormula = $('#desFormula').val();
		formula = $('#formula').val();

		var claveID = document.getElementById(jqIdAsignadoClaveID).value;
		var desClave = document.getElementById(jqIdAsignadoDesClave).value;

		if(desFormula != ""){
			desFormula += desClave + " ";
			$('#desFormula').val(desFormula);

			formula += claveID;
			$('#formula').val(formula);
		}else{
			desFormula += desClave + " ";
			$('#desFormula').val(desFormula);

			formula += claveID;
			$('#formula').val(formula);
		}
	}
