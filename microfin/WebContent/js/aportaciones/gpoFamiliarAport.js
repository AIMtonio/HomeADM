var esTab = false;

$(document).ready(function() {
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$('#formaGenerica').validate({
		rules: {
			clienteID: 'required',
		},
		messages: {
			clienteID: 'Especifique el Número de '+$('#safilocaleCTE').val()+'.',
		}
	});

	$('#clienteID').focus();
	deshabilitaBoton('grabar', 'submit');

	$('#clienteID').bind('keyup',function(e) {
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function(e) {
		consultaNombreCte(this.id,'clienteIDDes', true);
	});

	$('#grabar').click(function(event){
		$('#tipoTransaccion').val(1);
		grabaDetalles(event);
	});

});// FIN DOCUMENT READY
/**
 * Llama al función grabaFormaTransaccionRetrollamada.
 * @author avelasco
 */
function grabaDetalles(event){
	if(validarTabla()){
		if($("#formaGenerica").valid()) {
			if(llenarDetalle())
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID','funcionExito','funcionError');
		}
	}
}
/**
 * Consulta la lista de integrantes de un Grupo Familiar.
 * @author avelasco
 */
function consultaGrupoFam(){
	var numCliente = $('#clienteID').val();
	var gpoFamBean = {
			'tipoLista'		: 1,
			'clienteID'		: numCliente,
	};
	$('#gridGrupoFam').html("");
	$.post("grupoFamGridVista.htm", gpoFamBean, function(data) {
		if (data.length > 0 ) {
			$('#gridGrupoFam').html(data);
			$('#gridGrupoFam').show();
			habilitaBoton('btnAgregar');
		} else {
			$("#numTab").val(4);
			$('#gridGrupoFam').html("");
			$('#gridGrupoFam').show();
		}
	});
	$('#btnAgregar').focus();
}
/**
 * Inicializa la forma.
 * @author avelasco
 */
function inicializar(iniCte){
	if(iniCte){
		$('#clienteID').val('');
	}
	$('#clienteIDDes').val('');
	$('#gridGrupoFam').html("");
	$('#gridGrupoFam').hide();
	deshabilitaBoton('grabar');
}
/**
 * Función de  de éxito que se ejecuta cuando después de grabar
 * la transacción y ésta fue exitosa.
 * @author avelasco
 */
function funcionExito(){
	inicializar(false);
}
/**
 * Funcion de error que se ejecuta cuando después de grabar
 * la transacción marca error.
 * @author avelasco
 */
function funcionError(){

}
/**
 * Agrega un nuevo renglón (detalle) a la tabla del grid.
 * @param idControl : ID de algún campo para obtener el ID de la tabla a la que pertenece.
 * @author avelasco
 */
function agregarDetalle(idControl){
	if(validarTabla('tbIntegrantesGpoFam')){
		var numTab=$("#numTab").asNumber();
		var numeroFila=parseInt(getRenglones());
		numTab++;
		numeroFila++;
		var nuevaFila =
		'<tr id="tr'+numeroFila+'" name="tr"> ' +
			'<td> ' +
				'<input type="text" id="famClienteID'+numeroFila+'" tabindex="'+numTab+'" name="famClienteID" size="12" value="" maxlength="60" onblur="validaTitularCte(this.id,\'nomFamiliar'+numeroFila+'\',false);" onkeypress="listaCteGrid(this.id)" /> ' +
			'</td> ' +
			'<td> ' +
				'<input type="text" id="nomFamiliar'+numeroFila+'" name="nomFamiliar" size="45" value="" maxlength="100" readonly="readonly" disabled="true"/> ' +
			'</td> ' +
			'<td> ' +
				'<input type="text" id="tipoRelacionID'+numeroFila+'" tabindex="'+numTab+'" name="tipoRelacionID" size="10" value="" maxlength="45" onblur="consultaRelacion(this.id,\'descRelacion'+numeroFila+'\');" onkeypress="listaParentGrid(this.id)" /> ' +
			'</td> ' +
			'<td> ' +
				'<input type="text" id="descRelacion'+numeroFila+'" name="descRelacion" size="30" value="" maxlength="100" readonly="readonly" disabled="true"/> ' +
			'</td> ' +
			'<td> ' +
				'<input type="button" id="eliminar'+numeroFila+'" name="eliminar" value="" class="btnElimina" onclick="eliminarParam(\'tr'+numeroFila+'\')" tabindex="'+numTab+'"/> ' +
				'<input type="button" id="agrega'+numeroFila+'" name="agrega" value="" class="btnAgrega" onclick="agregarDetalle(this.id)" tabindex="'+numTab+'"/> ' +
			'</td> ' +
		'</tr> ' ;
		$('#tbIntegrantesGpoFam').append(nuevaFila);
		$("#numTab").val(numTab);
		$("#numeroFila").val(numeroFila);
	}
	habilitaBoton('grabar');
}
/**
 * Remueve de la tabla un tr.
 * @param id : ID del tr.
 * @author avelasco
 */
function eliminarParam(id){
	$('#'+id).remove();
}
/**
 * Válida que todos los campos requeridos del grid.
 * @returns {Boolean} : Si es váildo o no.
 * @author avelasco
 */
function validarTabla(){
	var validar = true;
	$('#tbIntegrantesGpoFam tr').each(function(index){
		if(index>1){
			var famClienteID = "#"+$(this).find("input[name^='famClienteID']").attr("id");
			var tipoRelacionID = "#"+$(this).find("input[name^='tipoRelacionID']").attr("id");

			if($(famClienteID).val().trim()==='') {
				agregarFormaError(famClienteID);
				validar=false;
			}

			if($(tipoRelacionID).val().trim()==='') {
				agregarFormaError(tipoRelacionID);
				validar=false;
			}
		}
	});
	return validar;
}
/**
 * Función arma la cadena con los detalles del grid.
 * @returns {Boolean}
 * @author avelasco
 */
function llenarDetalle(){
	var idDetalle = '#detalle';
	var numCliente = $('#clienteID').asNumber();
	var integrantes = '';
	$(idDetalle).val('');
	$('#tbIntegrantesGpoFam tr').each(function(index){
		if(index>1){
			var famClienteID = "#"+$(this).find("input[name^='famClienteID']").attr("id");
			var tipoRelacionID = "#"+$(this).find("input[name^='tipoRelacionID']").attr("id");

			if (index == 1) {
				integrantes = integrantes +
					numCliente+']'+
					$(famClienteID).val().trim()+']'+
					$(tipoRelacionID).val().trim()+']';
			} else {
				integrantes = integrantes + '[' +
					numCliente+']'+
					$(famClienteID).val().trim()+']'+
					$(tipoRelacionID).val().trim()+']';
			}
		}
	});
	$(idDetalle).val(integrantes);
	return true;
}
/**
 * Cancela las teclas [ ] en el formulario
 * @param e
 * @returns {Boolean}
 */
document.onkeypress = pulsarCorchete;

function pulsarCorchete(e) {
	tecla = (document.all) ? e.keyCode : e.which;
	if (tecla == 91 || tecla == 93) {
		return false;
	}
	return true;
}
/**
 * Regresa el número de renglones de un grid.
 * @returns Número de renglones de la tabla.
 * @author avelasco
 */
function getRenglones(){
	var maxNumRenglon = 0;
	var aux = 0;
	$('tr[name=tr]').each(function() {
		var numero= this.id.substr(2,this.id.length);
		if(aux == 0){
			maxNumRenglon = numero;
			aux= aux+1;
		}else{
			if(numero >= maxNumRenglon){
				maxNumRenglon = numero;
			}
		}
	});

	return maxNumRenglon;
}
/**
 * Valida que el integrante no sea el titular del grupo.
 * @param idControl ID del input que origina la consulta.
 * @param idControlDesc ID del input en el que se va a mostrar la descripción.
 * @param consulta indica si debe o no consultar los integrantes del grupo familiar del cliente.
 * @author avelasco
 */
function validaTitularCte(idControl,idControlDesc,consulta){
	var titularCte = $('#clienteID').asNumber();
	var integranteCte = $('#'+idControl).asNumber();
	if((titularCte != 0 && integranteCte != 0) && titularCte === integranteCte){
		mensajeSis('El ' + $('#safilocaleCTE').val() + ' Titular No puede Agregarse como Integrante del Grupo');
		$('#'+idControl).focus();
		$('#'+idControl).val('');
		$('#'+idControlDesc).val('');
	} else {
		consultaNombreCte(idControl,idControlDesc,consulta);
		validaIntegrante(idControl,idControlDesc);
	}
}
/**
 * Consulta el nombre completo del cliente.
 * @param idControl ID del input que origina la consulta.
 * @param idControlDesc ID del input en el que se va a mostrar la descripción.
 * @param consulta indica si debe o no consultar los integrantes del grupo familiar del cliente.
 * @author avelasco
 */
function consultaNombreCte(idControl,idControlDesc,consulta){
	var jqCte = eval("'#" + idControl + "'");
	var jqNomb = eval("'#" + idControlDesc + "'");
	var numCliente = $(jqCte).val().trim();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numCliente != '' && Number(numCliente)>0 && esTab) {
		clienteServicio.consulta(Number(1), numCliente,"",function(cliente) {
			if (cliente != null) {
				if(cliente.tipoPersona != 'M'){
					$(jqNomb).val(cliente.nombreCompleto);
					if(consulta){
						consultaGrupoFam();
					}
				} else {
					mensajeSis('El ' + $('#safilocaleCTE').val() + ' es Persona Moral.')
					$(jqCte).val('');
					$(jqCte).focus();
					$(jqNomb).val('');
				}
			} else {
				mensajeSis('El ' + $('#safilocaleCTE').val() + ' No Existe.')
				$(jqCte).val('');
				$(jqNomb).val('');
				if(consulta){
					$(jqCte).focus();
					inicializar(true);
				}
			}
		});
	}
}
/**
 * Valida la existencia de un integrante en otro grupo.
 * @param famClienteID ID del cliente familiar a validar.
 * @param nomFamiliarID ID del nombre del cliente familiar.
 * @author avelasco
 */
function validaIntegrante(famClienteID,nomFamiliarID){
	var numCteTitular = $('#clienteID').val();
	var numCteFam = $('#'+famClienteID).val();
	var tipoConsulta = 1;
	var gruposFamBean = {
		'clienteID'	:numCteTitular,
		'famClienteID'	:numCteFam
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numCteFam != '' && !isNaN(numCteFam) && esTab){
		gruposFamiliarServicio.consulta(tipoConsulta, gruposFamBean,function(gpoFam) {
			if(gpoFam!=null){
				if(gpoFam.existe === 'S'){
					if(!confirm(gpoFam.mensaje)){
						$('#'+famClienteID).focus();
						$('#'+famClienteID).val('');
						$('#'+nomFamiliarID).val('');
					}
				}
			}
		});
	}
}

/**
 * Lista de Clientes en un determinado renglón del grid.
 * @param idControl : ID del input que origina la lista.
 * @author avelasco
 */
function listaCteGrid(idControl){
	lista(idControl, '3', '1', 'nombreCompleto', $('#'+idControl).val(), 'listaCliente.htm');
}

/**
 * Lista de Parentescos en un determinado renglón del grid.
 * @param idControl : ID del input que origina la lista.
 * @author avelasco
 */
function listaParentGrid(idControl){
	lista(idControl, '2', '3', 'descripcion', $('#'+idControl).val(), 'listaParentescos.htm');
}

/**
 * Consulta el parentesco en el Grid.
 * @param idControl ID del input que origina la consulta.
 * @param idControlDesc ID del input en el que se va a mostrar la descripción.
 * @author avelasco
 */
function consultaRelacion(idControl,idControlDesc){
	var jqRel = eval("'#" + idControl + "'");
	var jqNomb = eval("'#" + idControlDesc + "'");
	var relacionID = $(jqRel).val();
	var tipConPrincipal = 3; // Consulta Parentescos Familiares.
	var ParentescoBean = {
			'parentescoID' : relacionID
	};

	setTimeout("$('#cajaLista').hide();", 200);
	if (!isNaN(relacionID) && Number(relacionID)>0 && esTab) {
		parentescosServicio.consultaParentesco(tipConPrincipal, ParentescoBean,function(parentesco) {
			if (parentesco != null) {
				$(jqNomb).val(parentesco.descripcion);
			} else {
				mensajeSis('El Parentesco No Existe.')
				$(jqRel).val('');
				$(jqNomb).val('');
			}
		});
	}else{
		$(jqRel).val('');
		$(jqNomb).val('');
	}
}
