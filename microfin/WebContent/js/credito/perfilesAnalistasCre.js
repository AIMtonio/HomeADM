var esTab = false;
var num_datos=0;
var cat_tipoPerfiles = {
	'Ejecutivos' : 2,
	'Analistas' : 1,
	'TipoAnalistas' : 'A',
	'TipoEjecutivos' : 'E'
};
var datosPerfiles = '';

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
		
	});
	$('#rolID').bind('keyup',function(e){
		lista('rolID', '1', '1', 'nombreRol',$('#rolID').val(), 'listaRoles.htm');
	});

	$('#rolID').blur(function() {
			consultaRoles(this.id);
	});

	$('#grabarAE').click(function(event){
		if(verificarCampo()){
		$('#tipoTransaccion').val(cat_tipoPerfiles.Analistas);
		$('#tipoPerfil').val(cat_tipoPerfiles.TipoAnalistas);
		grabaDetallesPerfilesAnalistas('tbParamAnalistas',event);
		$('#tipoTransaccion').val(cat_tipoPerfiles.Ejecutivos);
		$('#tipoPerfil').val(cat_tipoPerfiles.TipoEjecutivos);
		grabaDetallesPerfilesAnalistas('tbParamEjecutivos',event);
		}
	});
	
	extraerPerfilEdicionAnalista();
	inicializar();
	actualizaTabIndex();
});
/**
 * Llama al función grabaFormaTransaccionRetrollamada.
 * @param idControl : ID de la Tabla a grabar.
 * @author avelasco-ctomas
 */
function grabaDetallesPerfilesAnalistas(idControl,event){
	if(validarTabla(idControl)){
		if ($("#formaGenerica").valid()) {
			if(llenarDetalle(idControl))
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID','funcionExito','funcionError');

		}
	}
}


/**
 * Consulta la lista de perfiles de acuerdo al tipo de catálogo, y los muestra en el grid.
 * @param tipoLista : Número de lista a consultar: 1.- perfiles Analistas, 2.- perfiles Ejecutivos.
 * @author avelasco-ctomas
 */
function consultaPerfilesAnalistas(tipoLista){
	var perfilesBean = {
			'tipoLista':		tipoLista
	};
	// Se declaran estas variables de manera local.
	var gridDetalleDiv = '';
	var idBotonGrabar = '';
	var idBotonAgregar = '';
	var idTablaParametrizacion = '';
	var idTab = '';
    var numeroRenglones = Number(getRenglones('tbParametrizacion'));
    var idInput = '';

	// Dependiendo del tipo de perfil a consultar se pobla con datos el grid correspondiente.
	switch (tipoLista) {
	case cat_tipoPerfiles.Ejecutivos:
		gridDetalleDiv ='#gridEjecutivos';
		idBotonGrabar ='grabarEjecutivos';
		idBotonAgregar ='agregarEjecutivos';
		idTablaParametrizacion = 'tbParamEjecutivos';
		idTab = 'numTabEjecutivos';
		idInput='perfilIDEjecutivo';
		break;
	case cat_tipoPerfiles.Analistas:
		gridDetalleDiv ='#gridAnalistas';   
		idBotonGrabar ='grabarAnalistas';
		idBotonAgregar ='agregarAnalistas';
		idTablaParametrizacion = 'tbParamAnalistas';
		idTab = 'numTabAnalistas';
		idInput='perfilIDAnalista';
		break;
	}
	$(gridDetalleDiv).html("");
	$.post("perfilesAnalistasCreGrid.htm", perfilesBean, function(data) {
		if (data.length > 0 ) {
			num_datos=num_datos+1;
			$(gridDetalleDiv).html(data);
			$(gridDetalleDiv).show();
		} else {
			$("#numTab").val(4);
			$(gridDetalleDiv).html("");
			$(gridDetalleDiv).show();
		}
		// Se cambia el id de la tabla que viene desde el jsp del grid por uno nuevo.
		$("#tbParametrizacion").attr('id', idTablaParametrizacion);
		$("#btnAgregar").attr('id', idBotonAgregar);
		$("#numTab").attr('id', idTab);
		$("#agregarAnalistas").focus();
	});
	if(num_datos==0){
					deshabilitaBoton('grabarAE','submit');
		}
		deshabilitaBoton(idBotonAgregar,'submit');
		 
}

/**
 * Inicializa la forma. Carga y lista los perfiles de los dos catálogos.
 * @author avelasco-ctomas
 */
 


function inicializar(){
	consultaPerfilesAnalistas(cat_tipoPerfiles.Analistas);
	consultaPerfilesAnalistas(cat_tipoPerfiles.Ejecutivos);
}
/**
 * Actualiza los tabindex de ambas tablas.
 * @author avelasco-ctomas
 */
function actualizaTabIndex(){
	reasignaTabIndex('tbParamEjecutivos');
	reasignaTabIndex('tbParamAnalistas');
}
/**
 * Función de  de éxito que se ejecuta cuando después de grabar
 * la transacción y ésta fue exitosa.
 * @author avelasco-ctomas
 */
function funcionExito(){
	inicializar();
	actualizaTabIndex();
}
/**
 * Funcion de error que se ejecuta cuando después de grabar
 * la transacción marca error.
 * @author avelasco-ctomas
 */
function funcionError(){
	
}
/**
 * Agrega un nuevo renglón (detalle) a la tabla del grid.
 * @param idControl : ID de algún campo para obtener el ID de la tabla a la que pertenece.
 * @author avelasco-ctomas
 */
function agregarDetalle(idControl){	
	var idTablaParametrizacion = $('#'+idControl).closest('table').attr('id');
	var idBotonGrabar = '';
	var idTipoReng = '';
	var idBotonAgre= '';
	var nomInRol='';
	var idTab = '';
	var numDato=0;
	var idDatosPer='';
	var idAnterior=0; // toma el siguiente de la tabla analistas para insertar en la tabla
    var idAnteriorA=0; 
    var idAnteriorE=0; 
	if(idTablaParametrizacion == 'tbParamEjecutivos'){
		$("#"+'perfilIDAnalista').val('');
		$('#'+'nombreRolAnalista').val('');
		idBotonGrabar ='grabarEjecutivos';
		idTipoReng = 'E';
		idBotonAgre='perfilIDEjecutivo';
		nomInRol='nombreRolEjecutivo';
		idTab = 'numTabEjecutivos';
		idDatosPer=$('#'+nomInRol).val();
		if(idDatosPer !=''){
			numDato=1;
			}

	} else if(idTablaParametrizacion == 'tbParamAnalistas'){
		$("#"+'perfilIDEjecutivo').val('');
		$('#'+'nombreRolEjecutivo').val('');
		idBotonGrabar ='grabarAnalistas';
		idTipoReng = 'A';
		idBotonAgre='perfilIDAnalista';
		nomInRol='nombreRolAnalista';
		idTab = 'numTabAnalistas';
		idDatosPer=$('#'+nomInRol).val();
		if(idDatosPer !=''){
			numDato=1;
			}
	}
	if(numDato==1){

	if(!verificaSeleccionado(datosPerfiles.nombreRol,idTipoReng)){
	reasignaTabIndex(idTablaParametrizacion);

	if(validarTabla(idTablaParametrizacion)){
		var numTab=$("#"+idTab).asNumber();
 		var numeroFila=parseInt(getRenglones(idTablaParametrizacion));
 		var numeroFilaA=parseInt(getRenglones('tbParamAnalistas'));
 		var numeroFilaE=parseInt(getRenglones('tbParamEjecutivos'));
     	 idAnteriorA=parseInt($("#perfilIDA"+numeroFilaA).val());
   		 idAnteriorE=parseInt($("#perfilIDE"+numeroFilaE).val());


	    if(idAnteriorA>=idAnteriorE	){
	    	idAnterior=idAnteriorA;
	    }else{
	    	idAnterior=idAnteriorE;
	    }	
	    idAnterior++;
		numTab++;
		numeroFila++;

		var nuevaFila=
		"<tr id=\"tr"+idTipoReng+numeroFila+"\" name=\"tr"+idTipoReng+"\">"+
			"<td nowrap=\"nowrap\">"+
			"<input type=\"text\" id=\"rolID"+idTipoReng+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"rolID"+idTipoReng+"\" value=\""+(datosPerfiles.rolID) +"\"  size=\"3\" maxlength=\"3\"  onkeypress=\"listaRoles(this.id)\" readonly=\"readonly\" disabled=\"true\"/>"+
			"</td>"+
			"<td>"+
				"<input type=\"text\" id=\"nombreRol"+idTipoReng+numeroFila+"\" value=\""+(datosPerfiles.nombreRol) +"\"   name=\"nombreRol"+idTipoReng+"\" size=\"32\" maxlength=\"150\" readonly=\"readonly\" disabled=\"true\"/>"+
			"</td>"+
			"<td nowrap=\"nowrap\">"+
				"<input type=\"button\" id=\"eliminar"+idTipoReng+numeroFila+"\"name=\"eliminar"+idTipoReng+"\" value=\"\" class=\"btnElimina\" onclick=\"eliminarParam('tr"+idTipoReng+numeroFila+"')\" tabindex=\""+(numTab)+"\"/> "+
			"</td>"+
		"</tr>";
		$('#'+idTablaParametrizacion).append(nuevaFila);
		$("#"+idTab).val(numTab);
		$("#numeroFila").val(numeroFila);
		$('#'+nomInRol).val('');
		$('#'+idBotonAgre).val('');
		habilitaBoton('grabarAE','submit');

	  }
	  }
	
		$("#"+idBotonAgre).focus();
		$("#"+idBotonAgre).val('');
		$('#'+nomInRol).val('');
	}
}
/**
 * Remueve de la tabla un tr.
 * @param id : ID del tr.
 * @author avelasco-ctomas
 */
function eliminarParam(id){
	$('#'+id).remove();
	habilitaBoton('grabarAE','submit');
}

/**
 * Válida que todos el campo con name perfilID de la tabla este requisitado correctamente.
 * @param idControl : ID de la tabla a validar.
 * @returns {Boolean}
 * @author avelasco-ctomas
 */
function validarTabla(idControl){
	var validar = true;
	var idTipoReng ='';
	if(idControl == 'tbParamEjecutivos'){
		idTipoReng = 'E';
	} else if(idControl == 'tbParamAnalistas'){
		idTipoReng = 'A';
	}
	$('#'+idControl+' tr').each(function(index){
		if(index>0){
			var perfilID = "#"+$(this).find("input[name^='perfilID"+idTipoReng+"']").attr("id");
			var nombreRol="#"+$(this).find("input[name^='nombreRol"+idTipoReng+"']").attr("id");
			var perfil = $(perfilID).val();
			var nomRol = $(nombreRol).val();
			if(perfil==='') {
				agregarFormaError(perfilID);
				validar=false;
			}
		}
	});
	return validar;
}
/**
 * Función arma la cadena con los detalles del grid dependiendo del tipo de catálogo.
 * @param idControl : ID de algún campo para obtener el ID de la tabla a la que pertenece.
 * @returns {Boolean}
 * @author avelasco-ctomas
 */
function llenarDetalle(idControl){
	var idTablaParametrizacion = $('#'+idControl).closest('table').attr('id');
	var idDetalle = '';
	var validar = true;
	var idTipoReng ='';
	var perfilExp='';
	if(idTablaParametrizacion == 'tbParamEjecutivos'){
		idDetalle ='#detalleEjecutivos';
		idTipoReng = 'E';
	} else if(idTablaParametrizacion == 'tbParamAnalistas'){
		idDetalle ='#detalleAnalistas';
		idTipoReng = 'A';
	}
	
	$('#detalleAnalistas').val('');
	$('#detalleEjecutivos').val('');
		
		perfilExp=$('#perfilExpediente').val();
	$('#'+idTablaParametrizacion+' tr').each(function(index){
		if(index>0){
			var perfilID = "#"+$(this).find("input[name^='perfilID"+idTipoReng+"']").attr("id");
			var nombreRol="#"+$(this).find("input[name^='nombreRol"+idTipoReng+"']").attr("id");
			var rolID = "#"+$(this).find("input[name^='rolID"+idTipoReng+"']").attr("id");
			var perfil = $(perfilID).val();
			var rol = $(rolID).val();
			var nombRol = $(nombreRol).val();
			if (index == 1) {
				$(idDetalle).val( $(idDetalle).val()+
				rol+']'+ nombRol+']' + idTipoReng+']'+perfilExp+']');
			} else{
				$(idDetalle).val( $(idDetalle).val()+'['+
				rol+']'+ nombRol+']' + idTipoReng+']'+perfilExp+']');
			}
		}
	});
	deshabilitaBoton('grabarAE','submit');
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
 * Consulta un perfil del catálogo perfiles
 * @param idControl : ID del input que tiene el ID del país.
 * @param idControlNom	: ID del input para mostrar el nombre del país consultado.
 * @author avelasco-ctomas
 */

	function consultaRoles(idControl,idControlDesc) {
		var jqRol = eval("'#" + idControl + "'");
		var jqDesc = eval("'#" + idControlDesc + "'");
		var numRol = $(jqRol).val();
		var conRol=2;
		var rolesBeanCon = {
				'rolID':numRol
		};
		setTimeout("$('#cajaLista').hide();", 200);
              esTab=true;
		if(numRol != '' && !isNaN(numRol) && esTab){
			rolesServicio.consultaRoles(conRol,rolesBeanCon,function(roles) {
				if(roles!=null){
						$(jqDesc).val(roles.nombreRol);
						 datosPerfiles = roles;
						 if(idControlDesc=='perfilExpedienteID'){
						 habilitaBoton('grabarAE','submit');	
						 deshabilitaBoton('agregarAnalistas','submit');
						 deshabilitaBoton('agregarEjecutivos','submit');
						 }else{
							if(idControl=='perfilIDAnalista'){
								habilitaBoton('agregarAnalistas','submit');
								 $("#agregarAnalistas").focus();
								}
							else{
								habilitaBoton('agregarEjecutivos','submit');
								 $("#agregarEjecutivos").focus();
								}	
						
							}
				}else{
					mensajeSis("El Perfil no existe");
					if(idControlDesc=="perfilExpedienteID"){
					$(jqRol).focus();
					}else{
					$(jqRol).focus();
					$(jqDesc).val('');
					$(jqRol).val("");
					}
				}
			});
		}else{
		$(jqRol).val('');
	}
	}



/**
 * Lista los perfiles en un determinado renglón del grid.
 * @param idControl : ID del input que tiene el ID del país.
 * @author avelasco-ctomas
 */

function listaRoles(idControl){
	lista(idControl, '1', '1', 'nombreRol',$('#'+idControl).val(), 'listaRoles.htm');
}
/**
 * Valida si se repite un perfil en alguno de los catálogos.
 * @param idControl : ID del input que genera el evento.
 * @returns 
 * @author avelasco-ctomas
 */
function seRepite(idControl){
	var serepite = 0;
	var valor=idControl;
	// busca coincidencias en la tabla de perfiles no cooperantes
	$("#tbParamAnalistas input[name^='nombreRolA']").each(function(){
		var valor2=$('#'+this.id).val();
		if (idControl!=this.id && (valor2!=undefined && valor2!='') && valor == valor2) {
			serepite++;
			return false;
		}
	});
	// busca coincidencias en la tabla de perfiles en mejora
	$("#tbParamEjecutivos input[name^='nombreRolE']").each(function(){
		var valor2=$('#'+this.id).val();
		if (idControl!=this.id && (valor2!=undefined && valor2!='') && valor == valor2) {
			serepite++;
			return false;
		}
	});
	if(serepite>0){
		return true;
	}
	return false;

}
/**
 * Válida que no este repetida la frecuencia
 * @param id : ID del input que genera el evento.
 * @author avelasco-ctomas
 */
function verificaSeleccionado(id,id_catalogo){
	if(seRepite(id)){
	    mensajeSis("Perfil: "+id+" ya asignado ");
	    $("#"+id).focus();
		return true;
	}
	return false;
}

/**
 * Regresa el número de renglones de un grid.
 * @param idTablaParametrizacion : ID de la tabla a la que se va a contar el número de renglones.
 * @returns Número de renglones de la tabla.
 * @author avelasco-ctomas
 */
function getRenglones(idTablaParametrizacion){
	var idTipoReng = '';
	if(idTablaParametrizacion == 'tbParamEjecutivos'){
		idTipoReng = 'E';
	} else if(idTablaParametrizacion == 'tbParamAnalistas'){
		idTipoReng = 'A';
	}
	var numRenglones = $('#'+idTablaParametrizacion+' >tbody >tr[name^="tr'+idTipoReng+'"]').length;
	return numRenglones;
}
/**
 * Reasigna/actualiza el número de tabindex de los inputs que se encuentran dentro de la tabla. 
 * @param idTablaParametrizacion : ID de la tabla a actualizar.
 * @author avelasco-ctomas
 */
function reasignaTabIndex(idTablaParametrizacion){
	var numInicioTabs = 0;
	var idTipoReng = '';
	var idTab = '';
	if(idTablaParametrizacion == 'tbParamEjecutivos'){
		numInicioTabs = 301;
		idTipoReng = 'E';
		idTab = 'numTabEjecutivos';
	} else if(idTablaParametrizacion == 'tbParamAnalistas'){
		numInicioTabs = 1;
		idTipoReng = 'A';
		idTab = 'numTabAnalistas';
	}
	$('#'+idTablaParametrizacion+' tr').each(function(index){
		if(index>0){
			var perfilID = "#"+$(this).find("input[name^='perfilID"+idTipoReng+"']").attr("id");
			var agrega="#"+$(this).find("input[name^='agrega"+idTipoReng+"']").attr("id");
			var elimina="#"+$(this).find("input[name^='eliminar"+idTipoReng+"']").attr("id");
			numInicioTabs++;
			$(perfilID).attr('tabindex' , numInicioTabs);
			$(elimina).attr('tabindex' , numInicioTabs);
			$(agrega).attr('tabindex' , numInicioTabs);
		}
	});
	$('#'+idTab).val(numInicioTabs);
}


// Funcion para extraer el perfil expediente
function extraerPerfilEdicionAnalista(){
	var jqDesc = eval("'#" + 'perfilExpedienteID' + "'");
	var jqRol= eval("'#" + 'perfilExpediente' + "'");

	var tipoConsulta = 40;
	var bean = { 
			'empresaID'		: 1		
	};
	paramGeneralesServicio.consulta(tipoConsulta, bean,{ async: false, callback: function(parametro) {			

			if (parametro != null){	 
			 $(jqRol).val(parametro.valorParametro);
			}
			else{
					mensajeSis("Perfil Edicion Expediente no capturado");
					$(jqRol).focus();
				}
			
	}	
	});
	 consultaRoles('perfilExpediente','perfilExpedienteID');
	 	deshabilitaBoton('grabarAE','submit');

	 $("#perfilExpediente").focus();

}

function verificarCampo(){
 var pa=$("#perfilIDAnalista").val();
 var pe=$("#perfilIDEjecutivo").val();
	if(pa!=''|| pe!='')
		{
	      mensajeSis("Es necesario presionar boton Agregar");
	      return false;
		}
	  return true;
}

