$(document).ready(function() {
	esTab = false;

	var catTransTiposGestor = {
		'alta'		: 1,
		'modifica'	: 2
	};
	var catConTipoGestion = {
		'principal'	:	1,
		'foranea'	: 	2
	};
	var catSegtoCategoria ={
		'principal' :	1,
		'foranea'	: 	2
	};
	
	// ------------ Metodos y Manejo de Eventos
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	$('#categoriaID').focus();
	
	$(':text').focus(function(){
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	$.validator.setDefaults({
	      submitHandler: function(event) { 
	    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','categoriaID', 
	    			  'funcionExito','funcionError');
	      }
	});
	
	$('#agrega').click(function(){
		$('#tipoTransaccion').val(catTransTiposGestor.alta);
	});
	
	$('#modifica').click(function(){
		$('#tipoTransaccion').val(catTransTiposGestor.modifica);
	});	
	
	$('#categoriaID').bind('keyup',function(e){
		lista('categoriaID', '2', '1', 'categoriaID', $('#categoriaID').val(), 'listaSegtoCategoria.htm');
	});
	
	$('#categoriaID').blur(function() {
		consultaCategoria(this.id);
	});
		
	$('#tipoGestionID').bind('keyup',function(e){
		lista('tipoGestionID', '2', '1', 'tipoGestionID', $('#tipoGestionID').val(), 'listaTipoGestion.htm');
	});

	$('#tipoGestionID').blur(function() {
		validaTipoGestion(this.id);
	});

	// ------------ Validaciones de la Forma	
	$('#formaGenerica').validate({
		rules : {
			categoriaID: {
				required : true,
			},
			tipoGestionID: {
				required : true,
			},
			descripcion: {
				required : true,
			}, 
			nombreCorto: {
				required : true,
			},
			tipoCobranza: {
				required : true,
			},
			estatus: {
				required : true,
			}
		},
		messages : {
			categoriaID: {
				required : 'Especificar la Categoría.'
			},
			tipoGestionID: {
				required : 'Especificar el Tipo Gestión.'
			},
			descripcion: {
				required : 'Especificar la Descripción.'
			}, 
			nombreCorto: {
				required : 'Especificar el Nombre Corto.'
			},
			tipoCobranza: {
				required : 'Especificar el Tipo de Cobranza.'
			},
			estatus: {
				required : 'Especificar el Estatus.'
			}
		}
	});
	
	// ------------ Validaciones de Controles-------------------------------------

	function consultaCategoria(idControl){
		var jqCategoria = eval("'#" + idControl + "'");
		var numCategoria = $(jqCategoria).val(); 
		var categoriaBean ={
			'categoriaID' : numCategoria
		};
	
		if (numCategoria == 0 && esTab) {
			$('#descripcion').val('');
			$('#nombreCorto').val('');
			$('#tipoGestionID').val('');
			$('#descGestion').val('');
			$('#tipoCobranza').val('');
			$('#estatus').val('');
			habilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
		}else	if (numCategoria != '' && !isNaN(numCategoria) && esTab) {
			var categoriaBean ={
				'categoriaID' : numCategoria
			};
			catSegtoCategoriasServicio.consulta(catSegtoCategoria.principal, categoriaBean, function (categorias) {
				if (categorias != null) {
					dwr.util.setValues(categorias);
					esTab = true;
					validaTipoGestion('tipoGestionID');
					deshabilitaBoton('agrega', 'submit');
					habilitaBoton('modifica', 'submit');
				}else {
					alert("La Categoría No Existe.");
					$('#descripcion').val('');
					$('#nombreCorto').val('');
					$('#tipoGestionID').val('');
					$('#descGestion').val('');
					$('#tipoCobranza').val('');
					$('#estatus').val('');
					$(jqCategoria).focus();
					limpiaFormulario();
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
				}
			});
		}else{
			if(isNaN(numCategoria) && esTab){
				setTimeout("$('#cajaLista').hide();", 200);
				alert("La Categoría No Existe");
				$('#descripcion').val('');
				$('#nombreCorto').val('');
				$('#tipoGestionID').val('');
				$('#descGestion').val('');
				$('#tipoCobranza').val('');
				$('#estatus').val('');
				$(jqCategoria).focus();
				limpiaFormulario();
				deshabilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
			}
		}
	}
		
	function validaTipoGestion(idControl) {
		var jqTipoGestion = eval("'#" + idControl + "'");
		var numTipoGestion = $(jqTipoGestion).val();		
		if (numTipoGestion != '' && numTipoGestion != 0 && !isNaN(numTipoGestion) && esTab){
			var tiposGestionBean = {
				'tipoGestionID' : numTipoGestion
			};
			catTiposGestionServicio.consulta( catConTipoGestion.foranea, tiposGestionBean, function (catTipoGestion) {
				if (catTipoGestion != null) {
					if(catTipoGestion.estatus == 'A'){
						$('#descGestion').val(catTipoGestion.descripcion);
					}else{
						if(catTipoGestion.estatus == 'C'){
							alert("El Tipo de Gestión se encuentra Cancelado.");
							$('#tipoGestionID').focus();
							$('#tipoGestionID').val('');
							$('#descGestion').val('');
						}
					}
					
				}else {
					alert("El Tipo Gestión No Existe.");
					$('#tipoGestionID').focus();
					$('#tipoGestionID').val('');
					$('#descGestion').val('');
				}
			});		
		}else{
			if(isNaN(numTipoGestion) && esTab){
				setTimeout("$('#cajaLista').hide();", 200);
				alert("El Tipo de Gestión No Existe.");
				$('#tipoGestionID').focus();
				$('#tipoGestionID').val('');
				$('#descGestion').val('');
			}
		}
	}
});

function limpiaFormulario(){
	$('#categoriaID').val('');
	$('#descripcion').val('');
	$('#nombreCorto').val('');
	$('#tipoGestionID').val('');
	$('#descGestion').val('');
	$('#tipoCobranza').val("").selected = true;
	$('#estatus').val("").selected = true;
}

function funcionExito(){
	$('#descripcion').val('');
	$('#nombreCorto').val('');
	$('#tipoGestionID').val('');
	$('#descGestion').val('');
	$('#tipoCobranza').val("").selected = true;
	$('#estatus').val("").selected = true;
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
}

function funcionError(){

}