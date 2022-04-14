$(document).ready(function() {
	
	esTab = true;

	var catTransTiposResultados = {
		'alta'		: 1,
		'modifica'	: 2
	};
	var catConTipoResultados = {
		'principal'	:	1,
		'foranea'	: 	2
	};

	// ------------ Metodos y Manejo de Eventos
	
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');

	$(':text').focus(function(){
		esTab = false;
	});
	
	$('#resultadoSegtoID').focus();

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','resultadoSegtoID','funcionExito','funcionFallo');
		}
	});
	
	$('#agrega').click(function(){
		$('#tipoTransaccion').val(catTransTiposResultados.alta);
	});
	
	$('#modifica').click(function(){
		$('#tipoTransaccion').val(catTransTiposResultados.modifica);
	});	
	
	$('#resultadoSegtoID').bind('keyup',function(e){
		   lista('resultadoSegtoID', '2', '2', 'descripcion', $('#resultadoSegtoID').val(), 'listaSegtoResultados.htm');
	});
	
	
	$('#resultadoSegtoID').blur(function() {
		validaResultadoSegto(this.id);
	});
	
	// ------------ Validaciones de la Forma	
	$('#formaGenerica').validate({
		rules : {
			resultadoSegtoID: {
				required : true,
			},
			descripcion: {
				required : true,
			},
			alcance: {
				required : true,
			}, 
			reqSupervisor: {
				required : true,
			},
			estatus: {
				required : true,
			}
		},
		messages : {
			resultadoSegtoID: {
				required : 'Especificar el Resultado'
			},
			descripcion: {
				required : 'Especificar la Descripción'
			},
			alcance: {
				required : 'Especificar el Alcance'
			}, 
			reqSupervisor: {
				required : 'Especificar el Requiere Supervisor'
			},
			estatus: {
				required : 'Especificar el Estatus'
			}
		}
	});
	
	
	
	
	function validaResultadoSegto(idControl) {
		var jqResultadoSegtoID = eval("'#" + idControl + "'");
		var numResultadoSegtoID = $(jqResultadoSegtoID).val();
		
		if (numResultadoSegtoID == '0'){
			$('#descripcion').val('');
			$('#alcance').val('');
			$('#reqSupervisor').val('');
			$('#estatus').val('');
			habilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
		}else if (numResultadoSegtoID != '' && numResultadoSegtoID != 0 && !isNaN(numResultadoSegtoID) && esTab){
			var segtoresultadoBean = {					
				'resultadoSegtoID' : numResultadoSegtoID
			};
			segtoResultadosServicio.consulta( catConTipoResultados.principal, segtoresultadoBean, function (seguimientos) {
				if (seguimientos != null) {
					dwr.util.setValues(seguimientos);
					deshabilitaBoton('agrega', 'submit');
					if(seguimientos.estatus == 'V'){
						habilitaBoton('modifica', 'submit');
					}else{
						deshabilitaBoton('modifica', 'submit');						
					}
				}else {

					alert("El Resultado No Existe");
					$('#resultadoSegtoID').focus();
					$('#resultadoSegtoID').val('');
					$('#descripcion').val('');
					$('#alcance').val('');
					$('#reqSupervisor').val('');
					$('#estatus').val('');
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
				}
			});
			
		}else{
			if(isNaN(numResultadoSegtoID) && esTab){

				alert("El Resultado No Existe");
				$('#resultadoSegtoID').focus();
				$('#resultadoSegtoID').val('');
				$('#descripcion').val('');
				$('#alcance').val('');
				$('#reqSupervisor').val('');
				$('#estatus').val('');
				deshabilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				
			}
		}
	}
	
});


function funcionExito(){	
	$('#alcance').val('');
	$('#reqSupervisor').val('');
	$('#estatus').val('');
	$('#descripcion').val('');
}
function funcionFallo(){
	
}