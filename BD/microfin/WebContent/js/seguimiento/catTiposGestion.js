$(document).ready(function() {
	esTab = false;

	var catTransTiposGestor = {
		'alta'		: 1,
		'modifica'	: 2
	};
	var catConTipoGestor = {
		'principal'	:	1,
		'foranea'	: 	2
	};
	var catConUsuario ={
		'supervisor'	: 12
	};
	// ------------ Metodos y Manejo de Eventos
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	$('#tipoGestionID').focus();
	
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
	    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoGestionID', 
	    			  'funcionExito','funcionError');
	      }
	});
	
	$('#agrega').click(function(){
		$('#tipoTransaccion').val(catTransTiposGestor.alta);
	});
	
	$('#modifica').click(function(){
		$('#tipoTransaccion').val(catTransTiposGestor.modifica);
	});	

	$('#tipoGestionID').bind('keyup',function(e){
		   lista('tipoGestionID', '2', '1', 'tipoGestionID', $('#tipoGestionID').val(), 'listaTipoGestion.htm');
	});
	
	$('#supervisorID').bind('keyup',function(e){
	   lista('supervisorID', '2', '4', 'nombreCompleto', $('#supervisorID').val(), 'listaUsuarios.htm');
	});

	$('#tipoGestionID').blur(function() {
		validaTipoGestion(this.id);
	});

	// ------------ Validaciones de la Forma
	
	$('#formaGenerica').validate({
		rules : {
			tipoGestorID: {
				required : true,
			},
			descripcion: {
				required : true,
			}, 
			tipoAsigna: {
				required : true,
			},
			estatus: {
				required : true,
			}
		},
		messages : {
			tipoGestorID: {
				required : 'Especificar el Tipo Gestión.'
			},
			descripcion: {
				required : 'Especificar la Descripción.'
			}, 
			tipoAsigna: {
				required : 'Especificar el Tipo de Asignación.'
			},
			estatus: {
				required : 'Especificar el Estatus.'
			}
		}
	});
	
	
	// ------------ Validaciones de Controles-------------------------------------
	
	function validaTipoGestion(idControl) {
		var jqTipoGestion = eval("'#" + idControl + "'");
		var numTipoGestion = $(jqTipoGestion).val();
		
		if (numTipoGestion == 0 && esTab && numTipoGestion != ''){
			$('#descripcion').val('');
			$('#supervisorID').val('');
			$('#nomSupervisor').val('');
			$('#tipoAsigna').val('');
			$('#estatus').val('');
			
			habilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
		}else if (numTipoGestion != '' && numTipoGestion != 0 && !isNaN(numTipoGestion) && esTab){
			var catTiposGestorBean = {
				'tipoGestionID' : numTipoGestion
			};
		catTiposGestionServicio.consulta( catConTipoGestor.foranea, catTiposGestorBean, function (catTiposGestores) {
				if (catTiposGestores != null) {
					dwr.util.setValues(catTiposGestores);
					esTab = true;
					deshabilitaBoton('agrega', 'submit');
					habilitaBoton('modifica', 'submit');
				}else {
					alert("El Tipo de Gestión No Existe.");
					$('#tipoGestionID').focus();
					limpiaFormulario();
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
				}
			});
			
		}else{
			if(isNaN(numTipoGestion) && esTab){
				setTimeout("$('#cajaLista').hide();", 200);
				alert("El Tipo de Gestión No Existe.");
				$('#tipoGestionID').focus();
				limpiaFormulario();
				deshabilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
			}
		}
	}

});

	function limpiaFormulario(){
		$('#tipoGestionID').val('');
		$('#descripcion').val('');
		$('#tipoAsigna').val("").selected = true;
		$('#estatus').val("").selected = true;
	}
	
	function funcionExito(){
		$('#descripcion').val('');
		$('#tipoAsigna').val("").selected = true;
		$('#estatus').val("").selected = true;
		deshabilitaBoton('agrega', 'submit');
		deshabilitaBoton('modifica', 'submit');
	}
	
	function funcionError(){
		
	}