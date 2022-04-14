$(document).ready(function() {
	
	esTab = true;

	var catTransTiposRecomendas = {
		'alta'		: 1,
		'modifica'	: 2
	};
	var catConTipoRecomendas = {
		'principal'	:	1,
		'foranea'	: 	2
	};

	// ------------ Metodos y Manejo de Eventos
	
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');

	$(':text').focus(function(){
		esTab = false;
	});
	
	$('#recomendacionSegtoID').focus();
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','recomendacionSegtoID','funcionExito','funcionFallo');

		}
	});
	
	$('#agrega').click(function(){
		$('#tipoTransaccion').val(catTransTiposRecomendas.alta);
	});
	
	$('#modifica').click(function(){
		$('#tipoTransaccion').val(catTransTiposRecomendas.modifica);
	});	
	
	$('#recomendacionSegtoID').bind('keyup',function(e){
		   lista('recomendacionSegtoID', '2', '2', 'descripcion', $('#recomendacionSegtoID').val(), 'listaSegtoRecomendas.htm');
	});
	
	
	$('#recomendacionSegtoID').blur(function() {
		validaRecomendacionSegto(this.id);
	});
	
	// ------------ Validaciones de la Forma	
	$('#formaGenerica').validate({
		rules : {
			recomendacionSegtoID: {
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
			recomendacionSegtoID: {
				required : 'Especificar la Recomendación'
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
	
	
	
	
	function validaRecomendacionSegto(idControl) {
		var jqRecomenSegtoID = eval("'#" + idControl + "'");
		var numRecomenSegtoID = $(jqRecomenSegtoID).val();
		
		if (numRecomenSegtoID == '0'){
			$('#descripcion').val('');
			$('#alcance').val('');
			$('#reqSupervisor').val('');
			$('#estatus').val('');
			habilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
		}else if (numRecomenSegtoID != '' && numRecomenSegtoID != 0 && !isNaN(numRecomenSegtoID) && esTab){
			var segtorecomendasBean = {
				'recomendacionSegtoID' : numRecomenSegtoID
			};
			segtoRecomendasServicio.consulta( catConTipoRecomendas.principal, segtorecomendasBean, function (seguimientos) {
				if (seguimientos != null) {
					dwr.util.setValues(seguimientos);
					deshabilitaBoton('agrega', 'submit');
					if(seguimientos.estatus == 'V'){
						habilitaBoton('modifica', 'submit');
					}else{
						deshabilitaBoton('modifica', 'submit');						
					}
					
				}else {
					alert("La Recomendación No Existe");
					$('#recomendacionSegtoID').focus();
					$('#recomendacionSegtoID').val('');
					$('#descripcion').val('');
					$('#alcance').val('');
					$('#reqSupervisor').val('');
					$('#estatus').val('');
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
				}
			});
			
		}else{
			if(isNaN(numRecomenSegtoID) && esTab){
				alert("La Recomendación No Existe");
				setTimeout("$('#cajaLista').hide();", 200);	
				$('#recomendacionSegtoID').focus();
				$('#recomendacionSegtoID').val('');
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