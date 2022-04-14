
var esTab = false;
var num_datos=0;

var var_tipoAsignacion={
   'Por_producto': 1
};
var catTipoProductoCredito = {
	'principal' : 1
};
var cat_tipoPerfiles = {
	'Analistas' : 1
};
var datosAnalistas = '';

$(document).ready(function() {
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#tipoAsignacionID').change(function() {
		 $('#productoID').val('0');
		 var tipoAsigna=$('#tipoAsignacionID').val();
         consultaListaAsignaciones(tipoAsigna);
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$('#formaGenerica').validate({
		
	});

	$('#productoID').bind('keyup',function(e){
		lista('productoID', '2', '1', 'descripcion', $('#productoID').val(), 'listaProductosCredito.htm');
	});

	$('#productoID').blur(function() {
		var tipoAsig=$('#tipoAsignacionID').val();
		validaProductoCredito(this.id);
		consultaAnalistaAsignaciones(tipoAsig,this.id);
		
	});

	$('#usuarioIDi').bind('keyup',function(e){
		lista('usuarioIDi', '2', '17', 'nombreCompleto', $('#usuarioIDi').val(), 'listaUsuarios.htm');
	});

	$('#usuarioIDi').blur(function() {
  		validaUsuario(this);
	});
	$('#grabarAE').click(function(event){
		$('#tipoTransaccion').val(cat_tipoPerfiles.Analistas);
		grabaDetallesAnalistaAsignaciones('tbAnalistasAsignacion',event);
		
	});
	
inicializar();
funcionCargaComboClasificacion();

	
});
/**
 * Llama al función grabaFormaTransaccionRetrollamada.
 * @param idControl : ID de la Tabla a grabar.
 * @author avelasco-ctomas
 */
function grabaDetallesAnalistaAsignaciones(idControl,event){
		if ($("#formaGenerica").valid()) {
			if(llenarDetalle(idControl))
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID','funcionExito','funcionError');

		}
	
}


/**
 * Consulta la lista los analistas de cuerdo a su asignacion correspondiete, y los muestra en el grid.
 * @author avelasco-ctomas
 */
function consultaAnalistaAsignaciones(tipoLista,tipoProduc){
		var productoI = $('#'+tipoProduc).val();

	var analistasAsigBean = {
			'tipoLista':	cat_tipoPerfiles.Analistas,
			'tipoAsignacionID':tipoLista,
			'productoID':productoI

	};
	// Se declaran estas variables de manera local.
	var gridDetalleDiv = '';
	var idBotonGrabar = '';
	var idBotonAgregar = '';
	var idTablaParametrizacion = '';
	var idTab = '';
    var numeroRenglones = Number(getRenglones('tbParametrizacion'));
    var idInput = '';

		gridDetalleDiv ='#gridAsignacionAnalistas';

		idTablaParametrizacion = 'tbAnalistasAsignacion';
		idTab = 'numTabEjecutivos';
		idInput='perfilIDEjecutivo';
		
	$(gridDetalleDiv).html("");
	$.post("analistasAsignacionGrid.htm", analistasAsigBean, function(data) {
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
		$("#numTab").attr('id', idTab);
		$("#agregarAnalistas").focus();
		
	});		 
}

/**
 * Inicializa la forma. Carga y lista los perfiles de los dos catálogos.
 * @author avelasco-ctomas
 */
 


function inicializar(){
	$("#tipoAsignacionID").focus();
	var tipoAsigna= $('#tipoAsignacionID').val();
	if(tipoAsigna==1){
	}else{
    $('#productoID').val('0');
	   ocultarProducto();
	}
	deshabilitaBoton('grabarAE','submit');
	deshabilitaBoton('agregarAnalistasAsig','submit');

}

/**
 * Función de  de éxito que se ejecuta cuando después de grabar
 * la transacción y ésta fue exitosa.
 * @author avelasco-ctomas
 */
function funcionExito(){
	inicializar();
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

   if(verificaSeleccionado(datosAnalistas.clave)){
     $('#'+'usuarioIDi').focus();
   }else{

		var numTab=$('#numTabEjecutivos').val();
 		var numeroFila = $('#numeroFila').val();

		numTab++;
		numeroFila++;
		
		var nuevaFila=
		"<tr id=\"tr"+numeroFila+"\" name=\"tr"+"\">"+
			"<td nowrap=\"nowrap\">"+
			"<input type=\"text\" id=\"clave"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"clave"+"\" value=\""+(datosAnalistas.clave) +"\"  size=\"15\" maxlength=\"3\"   readonly=\"readonly\" disabled=\"true\"/>"+
			"</td>"+
			"<td>"+
				"<input type=\"text\" id=\"nombreCompleto"+numeroFila+"\" value=\""+(datosAnalistas.nombreCompleto) +"\"   name=\"nombreCompleto"+"\" size=\"32\" maxlength=\"150\" readonly=\"readonly\" disabled=\"true\"/>"+
			"</td>"+
			"<td nowrap=\"nowrap\">"+
				"<input type=\"button\" id=\"eliminar"+numeroFila+"\"name=\"eliminar"+"\" value=\"\" class=\"btnElimina\" onclick=\"eliminarParam('tr"+numeroFila+"')\" tabindex=\""+(numTab)+"\"/> "+
			"</td>"+
			"<td nowrap=\"nowrap\">"+
			"<input type=\"hidden\" id=\"usuarioID"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"usuarioID"+"\" value=\""+(datosAnalistas.usuarioID) +"\"  size=\"15\" maxlength=\"3\"  readonly=\"readonly\" disabled=\"true\"/>"+
			"</td>"
		"</tr>";
		$('#'+idTablaParametrizacion).append(nuevaFila);
		$('#numTabEjecutivos').val(numTab);
		$("#numeroFila").val(numeroFila);
		habilitaBoton('grabarAE','submit');
		limpiarUsuario();
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
 * Función arma la cadena con los detalles del grid dependiendo del tipo de catálogo.
 * @param idControl : ID de algún campo para obtener el ID de la tabla.
 * @returns {Boolean}
 * @author avelasco-ctomas
 */
function llenarDetalle(idControl){
	var idTablaParametrizacion = $('#'+idControl).closest('table').attr('id');
	var idDetalle = '';
	var validar = true;

		idDetalle ='#detalleAsignacion';

	$('#detalleAsignacion').val('');

	$('#'+idTablaParametrizacion+' tr').each(function(index){
		if(index>0){
			var usuarioID = "#"+$(this).find("input[name^='usuarioID"+"']").attr("id");
			var clave = "#"+$(this).find("input[name^='clave"+"']").attr("id");
		//	var productoID="#"+$(this).find("input[name^='productoID"+"']").attr("id");
			
            
            var usuarioId = $(usuarioID).val();
			var claveU = $(clave).val();
			var productoI = $('#productoID').val();
			var tipoAsig=$('#tipoAsignacionID').val();

			if (index == 1) {
				$(idDetalle).val( $(idDetalle).val()+
				usuarioId+']'+ claveU+']' + productoI+']'+tipoAsig+']');
			} else{
				$(idDetalle).val( $(idDetalle).val()+'['+
				usuarioId+']'+ claveU+']' + productoI+']'+tipoAsig+']');
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
 * Valida si se repite un analista en una asignaacion.
 * @param idControl : ID del input que genera el evento.
 * @returns 
 * @author avelasco-ctomas
 */
function seRepite(idControl){
	var serepite = 0;
	var valor=idControl;

	// busca coincidencias en la tabla de analistas asignacion.
	$("#tbAnalistasAsignacion input[name^='clave']").each(function(){
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
function verificaSeleccionado(id){
	var valorCampo=$('#'+'usuarioIDi').val();
   if(valorCampo!=''){
	   	if(seRepite(id)){
		    mensajeSis("Usuario: "+id+" ya se encuentra en la lista ");
	       limpiarUsuario();
			return true;
		}else{
			return false;
		}
   }else{
      return true;
   }
}

/**
 * Regresa el número de renglones de un grid.
 * @param idTablaParametrizacion : ID de la tabla a la que se va a contar el número de renglones.
 * @returns Número de renglones de la tabla.
 * @author avelasco-ctomas
 */
function getRenglones(idTablaParametrizacion){
	var idTipoReng = '';

	var numRenglones = $('#'+idTablaParametrizacion+' >tbody >tr[name^="tr'+'"]').length;
	return numRenglones;
}




function validaProductoCredito(control) {
	var numProdCredito = $('#productoID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numProdCredito != '' && !isNaN(numProdCredito)){

			var prodCreditoBeanCon = {
					'producCreditoID':$('#productoID').val()
			};
			productosCreditoServicio.consulta(catTipoProductoCredito.principal,prodCreditoBeanCon,function(prodCred) {
				if(prodCred!=null){
		            $('#descripcion').val(prodCred.descripcion); 
                 }else{
                 	 $('#descripcion').val(''); 
                 	 $("#productoID").focus();
                 }

			});
		}else{
			 $('#descripcion').val(''); 
			 $("#productoID").focus();
		}
	}




function validaUsuario(control) {
	var numUsuario = $('#usuarioIDi').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numUsuario != '' && !isNaN(numUsuario) ){
			var usuarioBeanCon = {
					'usuarioID':numUsuario
			};
			usuarioServicio.consulta(20,usuarioBeanCon,{ async: false, callback:function(usuario) {
				if(usuario!=null){
					 datosAnalistas = usuario;
                     $('#nombreCompleto').val(usuario.nombreCompleto);
                     	habilitaBoton('agregarAnalistasAsig','submit');
				}else{
                   mensajeSis("El usuario no es un analista de credito");    
                     $('#usuarioIDi').focus();
				}

			}});
		
		}
	}


	function consultaListaAsignaciones(control){
		if(control==var_tipoAsignacion.Por_producto){
		desocultarProducto();
		var producr=eval("'" + 'productoID' + "'");
		  consultaAnalistaAsignaciones(control,producr);
     	$('#productoID').focus();
		}
		else{
			var producr=eval("'" + 'productoID' + "'");
			ocultarProducto();
           consultaAnalistaAsignaciones(control,producr);
           $('#usuarioIDi').focus();
		}
		limpiarEncabezado();
	}

	function ocultarProducto(){
		$('#productoID').hide();
		$('#descripcion').hide();
		$('#xx').hide();
	}
	function desocultarProducto(){
		$('#productoID').show();
		$('#descripcion').show();
		$('#xx').show();
	}
	function limpiarEncabezado(){
		$('#productoID').val('');
		$('#descripcion').val('');
		$('#usuarioIDi').val('');
		$('#nombreCompleto').val('');
	}

	function limpiarUsuario(){
		$("#usuarioIDi").val('');
		$("#nombreCompleto").val('');
		$("#usuarioIDi").focus();
	}


function funcionCargaComboClasificacion(){
	dwr.util.removeAllOptions('tipoAsignacionID'); 
	analistasAsignacionServicio.listaComboCatalogoAsignaciones(1, function(beanLista){
		dwr.util.addOptions('tipoAsignacionID', {'':'SELECCIONAR'});	
		dwr.util.addOptions('tipoAsignacionID', beanLista, 'tipoAsignacionID', 'descripcion');
	});
}	






