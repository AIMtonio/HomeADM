
$(document).ready(function() {
	var tipoTransaccion = {
		'alta' : 1,
		'modifica' : 2,
		'elimina' : 3,
	}
	esTab = true;

	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('eliminar', 'submit');

	$("#clienteID").focus();

	
	$('#clienteID').bind('keyup',function(e) {
		lista('clienteID', '3', '8', 'nombreCompleto',$('#clienteID').val(),'listaCliente.htm');
	});

	$('#avalID').bind('keyup',function(e) {
		lista('avalID', '3', '5', 'nombreCompleto',$('#avalID').val(),'listaAvales.htm');
	});
	
	$('#prospectoID').bind('keyup',function(e) {
		lista('prospectoID', '3', '3', 'prospectoID',$('#prospectoID').val(),'listaProspecto.htm');
	});

	$('#garanteID').bind('keyup',function(e) { 
		lista('garanteID', '3', '2', 'nombreCompleto', $('#garanteID').val(), 'listaGarantes.htm');
	});
	
	$('#clienteID').blur(function() {
		if(esTab  && $('#clienteID').val()){
			$('#avalID').val("");				
			$('#nombreAval').val("");

			$('#prospectoID').val("");				
			$('#nombreProspecto').val("");

			$('#garanteID').val("");				
			$('#nombreGarante').val("");

			if(!consultaInconsistencia(this.id)){
				consultaCliente(this.id);
			}
		}
		
	});
	  
	$('#prospectoID').blur(function() {
		if(esTab && $('#prospectoID').val() != ''){

			$('#avalID').val("");				
			$('#nombreAval').val("");

			$('#clienteID').val("");				
			$('#nombreCliente').val("");

			$('#garanteID').val("");				
			$('#nombreGarante').val("");	

			if(!consultaInconsistencia(this.id)){
				consultaProspecto(this.id);
			}
		}
		
		
  	});
	
	$('#avalID').blur(function() {
		if(esTab && $('#avalID').val()){
			
			$('#clienteID').val("");				
			$('#nombreCliente').val("");

			$('#prospectoID').val("");				
			$('#nombreProspecto').val("");

			$('#garanteID').val("");				
			$('#nombreGarante').val("");


			if(!consultaInconsistencia(this.id)){
				consultaAval(this.id);
			}	
		}
		
	});

	$('#garanteID').blur(function() {
		if(esTab && $('#garanteID').val()){
			
			$('#clienteID').val("");				
			$('#nombreCliente').val("");

			$('#prospectoID').val("");				
			$('#nombreProspecto').val("");

			$('#avalID').val("");				
			$('#nombreAval').val("");


			if(!consultaInconsistencia(this.id)){
				consultaGarante(this.id);
			}	
		}
		
	});
	
	$('#grabar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.alta);
	});

	$('#modificar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.modifica);
	});
	
	$('#eliminar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.elimina);
	});
	
	$.validator.setDefaults({submitHandler : function(event) {
		if(validarCampos()){
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma','mensaje','true','clienteID','exitoGrabaTransaccion','errorGrabaTransaccion');
		}
	}});
	
	$('#formaGenerica').validate({
		rules: {
			nombreCompleto: 'required',
			comentarios: 'required'
		},		
		messages: {
			nombreCompleto: 'Especifique valor ',
			comentarios: 'Ingrese un comentario.',
		
		}		
	});
});





function consultaCliente(idControl) {
	setTimeout("$('#cajaLista').hide();", 200);	

	var jqCliente = eval("'#" + idControl + "'");
	var numCliente = $(jqCliente).val();	
	var tipConForanea = 24;		
	
	if(numCliente != '' && !isNaN(numCliente) && esTab){
		clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
			if(cliente!=null){	
				$('#nombreCliente').val(cliente.nombreCompleto);	

			}else{
				mensajeSis("No Existe el Cliente");
				$('#clienteID').focus();
				$('#clienteID').select();
				$('#clienteID').val("");	
				$('#nombreCliente').val("");	
				inicializaForma('formaGenerica','clienteID');
			}    	 						
		});
	}
}

// consulta el prospecto 
function consultaProspecto(idControl) {
	setTimeout("$('#cajaLista').hide();", 200);
	var jqProspecto = eval("'#" + idControl + "'");
	var numProspecto = $(jqProspecto).val();
	
	var prospectoBeanCon = {
		'prospectoID' : numProspecto
	};
	
	if (numProspecto != '' && !isNaN(numProspecto)) {
			prospectosServicio.consulta(6, prospectoBeanCon, {callback : function(prospectos) {
			if (prospectos != null) {

				$('#nombreProspecto').val(prospectos.nombreCompleto);	


			} else {
				mensajeSis("No Existe el Prospecto");
				$('#prospectoID').focus();
				$('#prospectoID').select();	
				$('#prospectoID').val("");	
				$('#nombreProspecto').val("");	
				inicializaForma('formaGenerica','prospectoID');
			}
		},
		errorHandler : function(message) {
			mensajeSis("Error en Consulta de Información del Prospecto." + message);
		}
		});
	}
}



function consultaAval(idControl) {
	var jqNumAval = eval("'#" + idControl + "'");
	var numAval = $(jqNumAval).val();

	var avalBean = {
		'avalID': numAval
	};

	if(numAval != '' && !isNaN(numAval) && esTab){
		avalesServicio.consulta(5,avalBean, function(avales) {
			if(avales!=null){
				$('#nombreAval').val(avales.nombreCompleto);
			}else{
				mensajeSis("No Existe el Aval");
				$('#avalID').focus();
				$('#avalID').select();
				$('#avalID').val("");
				$('#nombreAval').val("");
				inicializaForma('formaGenerica','avalID');
			}

		});
	}
}


function consultaGarante(idControl) {
	setTimeout("$('#cajaLista').hide();", 200);	

	var jqGarante = eval("'#" + idControl + "'");
	var numGarante = $(jqGarante).val();	
	var tipConForanea = 2;		
	
	if(numGarante != '' && !isNaN(numGarante) && esTab){
		garantesServicio.consulta(tipConForanea,numGarante,function(garante) {
			if(garante!=null){	
				$('#nombreGarante').val(garante.nombreCompleto);	

			}else{
				mensajeSis("No Existe el Garante");
				$('#garanteID').focus();
				$('#garanteID').select();
				$('#garanteID').val("");	
				$('#nombreGarante').val("");
				inicializaForma('formaGenerica','garanteID');
			}    	 						
		});
	}
}


function consultaInconsistencia(idControl){
	var jqnumPersona = eval("'#" + idControl + "'");
	var numPersona = $(jqnumPersona).val();

	var personaBean = {
		'clienteID' 	: $("#clienteID").val(),
		'prospectoID'	: $("#prospectoID").val(),
		'avalID'	 	: $("#avalID").val(),
		'garanteID' 	: $("#garanteID").val()
	};


	if(numPersona != '' && !isNaN(numPersona) && esTab){
		inconsistenciasServicio.consulta(1, personaBean, {async : false,callback :function(inconsistencias){
			if(inconsistencias!=null){

				$("#nombreCompleto").val(inconsistencias.nombreCompleto);
				$("#comentarios").val(inconsistencias.comentarios);
				habilitaBoton('modificar', 'submit');
				habilitaBoton('eliminar', 'submit');
				deshabilitaBoton('grabar', 'submit');
				return true;
			}
			else{
				habilitaBoton('grabar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				deshabilitaBoton('eliminar', 'submit');

				$("#nombreCompleto").val("");
				$("#comentarios").val("");

				return false;
			}
		}});

	}
	else{
		return false;
	}

}

function validarCampos(){
	numCliente = $('#clienteID').val();
	numProspecto = $('#prospectoID').val();
	numAval = $('#avalID');
	numGarante = $('#garanteID');

	if(numCliente && numProspecto && numAval && numGarante){
		mensajeSis("Ingrese un valor");
		return false;
	}
	else{
		return true;
	}
	
}

function inicializaCampos(){

	var campoFocus = '';
	if($('#clienteID').val()!=''){
		campoFocus = 'clienteID';
	}
	if($('#prospectoID').val()!=''){
		campoFocus = 'prospectoID';
	}
	if($('#avalID').val()!=''){
		campoFocus = 'avalID';
	}
	if($('#garanteID').val()!=''){
		campoFocus = 'garanteID';
	}
	limpiaFormaCompleta('formaGenerica', true, [ campoFocus]);

	$('#nombreCliente').val("");
	$('#nombreAval').val("");
	$('#nombreProspecto').val("");
	$('#nombreGarante').val("");
	$("#nombreCompleto").val("");
	$("#comentarios").val("");


}

function exitoGrabaTransaccion(){
	inicializaCampos();
}

function errorGrabaTransaccion(){
	
}

function validaSoloNumeros() {
	if ((event.keyCode < 48) || (event.keyCode > 57)) 
	event.returnValue = false;
}
