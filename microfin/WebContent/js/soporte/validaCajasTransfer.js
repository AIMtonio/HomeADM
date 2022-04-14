var tipoTran = {
	'actualiza': 1,
	'destinatarios': 2
};

var tipoAct = {
	'config': 1,
	'remitente': 2
};

$(document).ready(function() {
	
	/**** CONFIGURACIONES INICIALES ****/
	funcionConsultaConfiguraciones();
	$('#horaInicio').mask('99:99');
	
	$(':text').focus(function() {
		 esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#remitenteID').bind('keyup', function(e) {
		if(this.value.length >1) {			
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#remitenteID').val();
			
			lista('remitenteID', '1', '2', camposLista, parametrosLista, 'listacorreo.htm');	
		}
	});
	
	$('#numEjecuciones').blur(function() {
		var numEjec = $('#numEjecuciones').val();
		
		if(!funcionIsNumeric(numEjec)) {
			mensajeSis('Favor de Introducir un Valor Numérico');
			$('#numEjecuciones').val('');
			$('#numEjecuciones').focus();
		} else {
			if(numEjec == 0) {
				mensajeSis('El Num. Ejecuciones Debe ser Entre 1 y 9');
				$('#numEjecuciones').val('');
				$('#numEjecuciones').focus();
			}
		}
	});
	
	$('#intervalo').blur(function() {
		var intervalo = $('#intervalo').val();
		
		if(!funcionIsNumeric(intervalo)) {
			mensajeSis('Favor de Introducir un Valor Numérico');
			$('#intervalo').val('');
			$('#intervalo').focus();
		} else {			
			if(intervalo == 0) {
				mensajeSis('El Intervalo Debe ser Entre 1 y 9');
				$('#intervalo').val('');
				$('#intervalo').focus();
			}
		}
	});
	
	$('#horaInicio').blur(function() {
		var horaInicio	= $('#horaInicio').val();
		var temp		= $('#horaInicio').val();
		var horas		= '';
		var minutos 	= '';
		
		horaInicio = horaInicio.replace('_', '', 'gi');
		if(horaInicio.length == 5) {
			minutos	= horaInicio.substr(-2,2);
			horas = temp.substr(0,2);
			if(horas > 23) {
				mensajeSis('Las Horas deben ser Entre 00 y 23');
				$('#horaInicio').val('');
				$('#horaInicio').focus();
			}
			
			if(minutos > 59) {
				mensajeSis('Los Minutos Deben ser Entre 00 y 59');
				$('#horaInicio').val('');
				$('#horaInicio').focus();
			}
		}
		
		horaInicio = horaInicio.replace(':', '');
			
		if(horaInicio.length == 3) {
			horas = horaInicio.substr(0,1);
			horas = '0' + horas;

			minutos	= horaInicio.substr(-2,2);
			if(minutos > 59) {
				mensajeSis('Los Minutos Deben ser Entre 00 y 59');
				$('#horaInicio').val('');
				$('#horaInicio').focus();
			} else {				
				horaInicio = horas + ':' + minutos;

				$('#horaInicio').val(horaInicio);
			}
		}
		if(esTab) $('#numEjecuciones').focus();
		
	});
	
	$('#remitenteID').blur(function() {
		if(esTab) consultaRemitente();
	});

	$('#guardar').click(function() {
		$('#tipoTransaccion').val(tipoTran.actualiza);
		$('#tipoActualizacion').val(tipoAct.config);
	});
	
	$('#guardarDestinatarios').click(function(event) {
		$('#tipoTransaccion').val(tipoTran.destinatarios);
		$('#tipoActualizacion').val(tipoAct.remitente);
		grabaDestinatarios(event);
	});
	
	$.validator.setDefaults({
	    submitHandler: function(event) {
	    	funcionCrearCron();
    		grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','horaInicio');
	    }
	 });
	
	
	/************************ VALIDACIÓN DE LA FORMA ************************/
	$('#formaGenerica').validate({
		rules: {
			horaInicio: {
				required: true
			},
			numEjecuciones: {
				required: true
			},
			intervalo: {
				required: true
			}
		},
		messages: {
			horaInicio: {
				required: 'Especificar Hora'
			},
			numEjecuciones: {
				required: 'Especificar Ejecuciones'
			},
			intervalo: {
				required: 'Especificar Intervalo'
			}
		}
	});
});

function grabaDestinatarios(event) {
	if(getRenglones('tbParametrizacion') > 1) {		
		if(validaTabla(1) && validaTabla(2)) {
			if($('#remitenteID').val() != null || $('#remitenteID').val() != '') {				
				if(llenaDetalle()) {
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'remitenteID', 'funcionExito','funcionError');
				}
			} else  {
				$('#tipoTransaccion').val('');
				$('#tipoActualizacion').val('');
				$('#remitenteID').focus();
				mensajeSis('Es Necesario Agregar Remitente');
			}
		}
	} else {
		$('#tipoTransaccion').val('');
		$('#tipoActualizacion').val('');
		mensajeSis('Es Necesario Agregar un Destinatario');
	}
}

function llenaDetalle() {
	var idDetalle = '#detalle';
	
	$(idDetalle).val('');
	$('#tbParametrizacion tr').each(function(index) {
		if(index > 0) {
			var tipo 		   = "#"+$(this).find("input[name^='tipo']").attr("id");
			var destinatarioID = "#"+$(this).find("input[name^='destinatarioID']").attr("id");
			
			$(tipo).val('D');
			if(index == 1) {
				$(idDetalle).val($(idDetalle).val() +
						$(destinatarioID).val()+']' +
						$(tipo).val()+']');
			} else {
				$(idDetalle).val($(idDetalle).val() +'['+
						$(destinatarioID).val()+']' +
						$(tipo).val()+']');
			}
		}
	});
	
	$('#tbParametrizacion2 tr').each(function(index) {
		if(index > 0) {
			var tipo 	   = "#"+$(this).find("input[name^='tipo']").attr("id");
			var conCopiaID = "#"+$(this).find("input[name^='conCopiaID']").attr("id");

			$(tipo).val('C');
			$(idDetalle).val($(idDetalle).val()+'['+
					$(conCopiaID).val()+']' +
					$(tipo).val()+']');
		}
	});
	
	return true;
}

function funcionListaUsuario(idControl) {
	lista(idControl, '2', '20', 'nombreCompleto',  document.getElementById(idControl).value, 'listaUsuarios.htm');
}

function funcionCrearCron() {
	var horaInicio  = $('#horaInicio').val();
	var intervalo   = parseInt($('#intervalo').val());
	var ejecuciones = $('#numEjecuciones').val();
	var hora	    = horaInicio.substr(0,1);
	var minutos	    = horaInicio.substr(-2,1);
	var hrsCron	    = '';
	var cron	    = '';
	
	if(hora == '0') hora = parseInt(horaInicio.substr(1,1));
	else hora = parseInt(horaInicio.substr(0,2));
	
	if(minutos == '0') minutos = parseInt(horaInicio.substr(-1,1));
	else minutos = parseInt(horaInicio.substr(-2,2));
	
	for(var i = 1; i <= ejecuciones; i++) {
		if(i == 1) {			
			hrsCron = hora + ','; 
		}
		if(i > 1 && i < ejecuciones){
			hora = hora + intervalo;
			if(hora > 23) {
				hora = hora - 24;
			}
			hrsCron = hrsCron + hora + ',';
		}
		if(i == ejecuciones){
			hora = hora + intervalo;
			if(hora > 23) {
				hora = hora - 24;
			}
			hrsCron = hrsCron + hora;
		}
	}
	cron = '0 ' + minutos + ' ' + hrsCron + ' ? * * *';
	$('#expresionCron').val(cron);
}

function consultaUsuario(idControl, count, tipo) {
	var usuarioID  = $('#'+idControl).val();
	var tipoCon	   = 1;
	var usuarioNom = '';
	var usuarioBeanCon = {
		'usuarioID': usuarioID
	};
	
	if(tipo == 1) usuarioNom = 'destinatarioNombre' + count;
	if(tipo == 2) usuarioNom = 'conCopiaNombre' + count;
	
	usuarioServicio.consulta(tipoCon, usuarioBeanCon, function(usuario) {
		if(usuario != null) {
			$('#'+usuarioNom).val(usuario.nombreCompleto);
		}
	});
}

function consultaRemitente() {
	var tipoCon = 3;
	var remitenteID = $('#remitenteID').val();
	var validaCajasTransferBean = {
		'remitenteID': remitenteID
	}
	
	if(remitenteID != null && remitenteID != '') {		
		tarEnvioCorreoParamServicio.consulta(tipoCon, validaCajasTransferBean, function(remitente) {
			if(remitente != null) {				
				$('#descripcion').val(remitente.descripcion);
			} else {
				mensajeSis('El Remitente consultado está Bloqueado o no Existe');
				$('#remitenteID').val('');
				$('#remitenteID').focus();
				$('#descripcion').val('');
			}
		});
	}
}

function funcionConsultaConfiguraciones() {
	var tipoCon = 1;
	var validaCajasTransferBean = {
		'valCajaParamID': 1
	}
	
	validaCajasTransferServicio.consulta(validaCajasTransferBean, tipoCon, function(config) {
		if(config != null) {
			$('#horaInicio').val(config.horaInicio);
			$('#numEjecuciones').val(config.numEjecuciones);
			$('#intervalo').val(config.intervalo);
			
			$('#horaInicio').mask('99:99');
			if(config.remitenteID != 0) {				
				$('#remitenteID').val(config.remitenteID);
				consultaRemitente();
			}
			funcionCrearCron();
			listaDestinatarios(1);
			listaDestinatarios(2);
		}
	});
}

function agregarDetalle(){
	reasignaTabIndex(1);
	
	if(validaTabla(1)) {
		var numTab = $('#numTab').asNumber();
		var numeroFila = parseInt(getRenglones('tbParametrizacion'));
		
		numTab++;
		numeroFila++;
		var nuevaFila = 
			"<tr id=\"tr"+numeroFila+"\" name=\"trDestinatario\">" +
				"<td nowrap=\"nowrap\">" +
					"<input type=\"text\" id=\"destinatarioID"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"destinatarioID\" size=\"5\" onblur=\"consultaUsuario(this.id, "+numeroFila+", 1)\" onkeypress=\"funcionListaUsuario(this.id)\"/>&nbsp;" +
					"<input type=\"text\" id=\"destinatarioNombre"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"destinatarioNombre\" size=\"40\" readonly/>" +
					"<input type=\"hidden\" id=\"tipo"+numeroFila+"\" name=\"tipo\" value=\"D\"/>" +
				"</td>" +
				"<td nowrap=\"nowrap\">" +
					"<input type=\"button\" id=\"eliminar"+numeroFila+"\" name=\"eliminar\" value=\"\" class=\"btnElimina\" onclick=\"eliminarParam('tr"+numeroFila+"')\" tabindex=\""+(numTab)+"\"/> " +
					"<input type=\"button\" id=\"agrega"+numeroFila+"\" name=\"agrega\" value=\"\" class=\"btnAgrega\" onclick=\"agregarDetalle(this.id)\" tabindex=\""+(numTab)+"\"/>" +
				"</td>" +
			"</tr>";
		$('#tbParametrizacion').append(nuevaFila);
		$('#numTab').val(numTab);
		$("#numeroFila").val(numeroFila);
	}
}

function agregarConCopia(){
	reasignaTabIndex(2);
	
	if(validaTabla(2)) {
		var numTab = $('#numTab').asNumber();
		var numeroFila = parseInt(getRenglones('tbParametrizacion2'));
		
		numTab++;
		numeroFila++;
		var nuevaFila = 
			"<tr id=\"trCC"+numeroFila+"\" name=\"trConCopia\">" +
				"<td nowrap=\"nowrap\">" +
					"<input type=\"text\" id=\"conCopiaID"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"conCopiaID\" size=\"5\" onblur=\"consultaUsuario(this.id, "+numeroFila+", 2)\" onkeypress=\"funcionListaUsuario(this.id)\"/>&nbsp;" +
					"<input type=\"text\" id=\"conCopiaNombre"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"conCopiaNombre\" size=\"40\" readonly/>" +
					"<input type=\"hidden\" id=\"tipo"+numeroFila+"\" name=\"tipo\" value=\"C\"/>" +
				"</td>" +
				"<td nowrap=\"nowrap\">" +
					"<input type=\"button\" id=\"eliminarCC"+numeroFila+"\" name=\"eliminarCC\" value=\"\" class=\"btnElimina\" onclick=\"eliminarParamCC('trCC"+numeroFila+"')\" tabindex=\""+(numTab)+"\"/> " +
					"<input type=\"button\" id=\"agregaCC"+numeroFila+"\" name=\"agregaCC\" value=\"\" class=\"btnAgrega\" onclick=\"agregarConCopia(this.id)\" tabindex=\""+(numTab)+"\"/>" +
				"</td>" +
			"</tr>";
		$('#tbParametrizacion2').append(nuevaFila);
		$('#numTab').val(numTab);
		$("#numeroFila").val(numeroFila);
	}
}

/**
* Remueve de la tabla un tr.
* @param id : ID del tr.
*/
function eliminarParam(id){
	
	$('#'+id).remove();
	reasignaTabIndex(1);
	ordenaControles(1);
	if($('#tbParametrizacion tr').length == 0) {
		deshabilitaBoton('guardarDestinatarios', 'submit');
	}
}

/**
* Remueve de la tabla un tr.
* @param id : ID del tr.
*/
function eliminarParamCC(id){
	$('#'+id).remove();
	reasignaTabIndex(2);
	ordenaControles(2);
}

/**
* Reasigna/actualiza el número de tabindex de los inputs que se encuentran dentro de la tabla.
*/
function reasignaTabIndex(tipo) {
	var idTab = '';
		idTab = 'numTab';
		
	if(tipo == 1) {
		var numInicioTabs = getRenglones('tbParametrizacion');
		$('#tbParametrizacion tr').each(function(index){
			if(index > 1) {
				var destinatarioID = "#"+$(this).find("input[name^='destinatarioID"+"']").attr("id");
				var destinatarioNombre = "#"+$(this).find("input[name^='destinatarioNombre"+"']").attr("id");
				
				var agrega="#"+$(this).find("input[name^='agrega"+"']").attr("id");
				var elimina="#"+$(this).find("input[name^='eliminar"+"']").attr("id");
				
				numInicioTabs++;
				$(destinatarioID).attr('tabindex' , numInicioTabs);
				$(destinatarioNombre).attr('tabindex' , numInicioTabs);
				
				$(elimina).attr('tabindex' , numInicioTabs);
				$(agrega).attr('tabindex' , numInicioTabs);
			}
		});
		$('#'+idTab).val(numInicioTabs);
	}
	
	if(tipo == 2) {
		var numInicioTabs = getRenglones('tbParametrizacion2');
		$('#tbParametrizacion2 tr').each(function(index){
			if(index > 1) {
				var conCopiaID = "#"+$(this).find("input[name^='conCopiaID"+"']").attr("id");
				var conCopiaNombre = "#"+$(this).find("input[name^='conCopiaNombre"+"']").attr("id");

				var agrega="#"+$(this).find("input[name^='agregaCC"+"']").attr("id");
				var elimina="#"+$(this).find("input[name^='eliminarCC"+"']").attr("id");
				
				numInicioTabs++;
				$(conCopiaID).attr('tabindex' , numInicioTabs);
				$(conCopiaNombre).attr('tabindex' , numInicioTabs);
				
				$(elimina).attr('tabindex' , numInicioTabs);
				$(agrega).attr('tabindex' , numInicioTabs);
			}
		});
		$('#'+idTab).val(numInicioTabs);
	}
}

/**
* Ordena los IDs de los Campos cuando se elimina algun registro del GRID
*/
function ordenaControles(tipo){
	var contador = 1;
	if(tipo == 1) {		
		$('input[name=destinatarioID]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "destinatarioID" + contador);
			
			contador = contador + 1;
		});
		contador = 1;
		
		$('input[name=destinatarioNombre]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "destinatarioNombre" + contador);
			
			contador = contador + 1;
		});
		
		$('input[name=tipo]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "tipo" + contador);
			
			contador = contador + 1;
		});
	}
	
	if(tipo == 2) {
		$('input[name=conCopiaID]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "conCopiaID" + contador);
			
			contador = contador + 1;
		});
		contador = 1;
		
		$('input[name=conCopiaNombre]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "conCopiaNombre" + contador);
			
			contador = contador + 1;
		});
		
		$('input[name=tipo]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "tipo" + contador);
			
			contador = contador + 1;
		});
	}
	
}

function validaTabla(tipo) {
	var validar = true;
	
	if(tipo == 1) {
		if(getRenglones('tbParametrizacion') > 0) {	
			$('#tbParametrizacion tr').each(function(index) {
				if(index >= 0) {
					var destinatarioID = "#"+$(this).find("input[name^='destinatarioID"+"']").attr("id");
					var destinatarioNombre = "#"+$(this).find("input[name^='destinatarioNombre"+"']").attr("id");
					
					var destID = $(destinatarioID).asNumber();
					var destNombre = $(destinatarioNombre).val();
					
					if(destID === '') {
						agregarFormaError(destinatarioID);
						validar = false;
					}
					
					if(destNombre === '') {
						agregarFormaError(destinatarioID);
						validar = false;
					}
				}
			});
		}
	}
	
	if(tipo == 2) {
		if(getRenglones('tbParametrizacion') > 0) {			
			$('#tbParametrizacion2 tr').each(function(index) {
				if(index >= 0) {
					var conCopiaID = "#"+$(this).find("input[name^='conCopiaID"+"']").attr("id");
					var conCopiaNombre = "#"+$(this).find("input[name^='conCopiaNombre"+"']").attr("id");
					
					var cCopiaID = $(conCopiaID).asNumber();
					var cCopiaNombre = $(conCopiaNombre).val();
					
					if(cCopiaID === '') {
						agregarFormaError(conCopiaID);
						validar = false;
					}
					
					if(cCopiaNombre === '') {
						agregarFormaError(conCopiaID);
						validar = false;
					}
				}
			});
		}
	}
	return validar;
}

/**
* Regresa el número de renglones de un grid.
* @param idTablaParametrizacion : ID de la tabla a la que se va a contar el número de renglones.
* @returns Número de renglones de la tabla.
*/
function getRenglones(idTablaParametrizacion){
	var numRenglones = $('#'+idTablaParametrizacion+' >tbody >tr').length;
	return numRenglones;
}

/**
 * Lista los destinatarios 
 **/
function listaDestinatarios(tipoLista) {
	var validaCajasTrans = {
		'tipoLista': tipoLista
	};
	
	$.post('validaCajasTransGrid.htm', validaCajasTrans, function(data) {

		if(tipoLista == 1) {
			$("#gridDirigido").html(data);
			$("#gridDirigido").show();
		} 
		
		if(tipoLista == 2){				
			$("#gridConCopia").html(data);
			$("#gridConCopia").show();
		}
	});
}

/**
* Valida si es un número
* @param input : valor a validar.
* @returns true/false.
**/
function funcionIsNumeric(input){ 
	var RE = /^-{0,1}\d*\.{0,1}\d+$/; 
	return (RE.test(input)); 
}

/**
 * Función de  de éxito que se ejecuta cuando después de grabar
 * la transacción y ésta fue exitosa.
 * @author avelasco
 */
function funcionExito() {}
/**
 * Funcion de error que se ejecuta cuando después de grabar
 * la transacción marca error.
 * @author avelasco
 */
function funcionError() {}
