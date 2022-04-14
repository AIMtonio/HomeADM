$(document).ready(function() {
	esTab = true;
	// Definicion de Constantes y Enums
	var catTipoTransCalifReserva = {
		'agrega' : 1,
		'modifica' : 2
	};
	var cont = 0;	
	deshabilitaBoton('grabar', 'submit');
	
	$(':text').focus(function() {
	 	esTab = false;
	});
	consultaTipoInst();
	$.validator.setDefaults({
		submitHandler: function(event) {
			if (cont > 0 ){
				mensajeSis("Faltan Datos");
			}else{
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','','Exito','Error');
				
			}
		}
    });
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#grabar').click(function() {
		cont = 0;
		$('#gridCalifRango input[type=text]').each(function() {
			if ($(this).val() == ''){
				cont++;
			}
		});
		$('#tipoTransaccion').val(catTipoTransCalifReserva.agrega);
		creaReservaDiasAtraso();
	});
	
	$("input[name='clasificacion']").change(function(){
		consultaPlazos();
	});
	var Var_TipoReserva='R';
	$("#tipo").val(Var_TipoReserva);
	$('#formaGenerica').validate({
		rules: {
			tipoInstitucion: { 
				required : true
			},
			tipo:{
				required: true
			}
		},
		messages: { 			
		 	tipoInstitucion: {
				required: 'Seleccione el tipo Institucion'
			},
			tipo:{
				required: 'Seleccione el tipo'
			}
		}		
	});
		
	function consultaPlazos(){
		deshabilitaBoton('grabar','submit');
		var tipoInstitucion = $('#tipoInstitucion').val();
		var clasificacion   = $("input[name='clasificacion']:checked").val();
		var tipo = $("#tipo").val();
		if (tipoInstitucion != '' && tipo != ''){
			var params = {};
			params['tipoLista'] = 3;
			params['tipoInstitucion'] = tipoInstitucion;
			params['clasificacion'] = clasificacion;
			params['tipo'] = tipo; 
			$.post("gridCalifRangoReserva.htm", params, function(data){
				if(data.length >0) {
					$('#gridCalifRango').html(data);
					$('#gridCalifRango').show();
					habilitaBoton('grabar', 'submit');
					agregaFormatoTasa('formaGenerica');
				}else{
					$('#gridCalifRango').html("");
					$('#gridCalifRango').show();
					if(clasificacion==''){
						deshabilitaBoton('grabar', 'submit');
					}
				}
			});
		}else{
			$('#gridCalifRango').hide();
			$('#gridCalifRango').html('');
			deshabilitaBoton('grabar','submit');
		}
	}
		
	function creaReservaDiasAtraso(){
		var contador = 1;
		$('#limInferiores').val("");
		$('#limSuperiores').val("");
		$('#lisCalifica').val("");
				
		$('input[name=plazoInferior]').each(function() {
			if (contador != 1){
				$('#limInferiores').val($('#limInferiores').val() + ','  + this.value);
			}else{
				$('#limInferiores').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=plazoSuperior]').each(function() {
			if (contador != 1){
				$('#limSuperiores').val($('#limSuperiores').val() + ','  + this.value);
			}else{
				$('#limSuperiores').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('select[name=calif]').each(function() {
			if (contador != 1){
				$('#lisCalifica').val($('#lisCalifica').val() + ','  + this.value);
			}else{
				$('#lisCalifica').val(this.value);
			}
			contador = contador + 1;
		});
	}
	
	function consultaTipoInst() {
		dwr.util.removeAllOptions('tipoInstitucion'); 
		dwr.util.addOptions('tipoInstitucion');
		paramsCalificaServicio.listaCombo( 3, function(tipoInst){
			dwr.util.addOptions('tipoInstitucion', tipoInst, 'tipoInstitucion', 'tipoInstitucion');
		});
	}

});
	function Exito(){
	}
	function Error(){
	}
