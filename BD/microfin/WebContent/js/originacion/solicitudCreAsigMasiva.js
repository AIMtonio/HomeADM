
var esTab = false;

var cat_reasignar = {
	'Analistas' : 2
};
var tipo_lista = {
	'usuariosA' : 2
};

$(document).ready(function() {

	$('#productoID').bind('keyup',function(e){
		lista('productoID', '2', '1', 'descripcion', $('#productoID').val(), 'listaProductosCredito.htm');
	});

	$('#productoID').blur(function() {
		var tipoAsig=$('#tipoAsignacionID').val();
		
	});

	$('#usuarioID').bind('keyup',function(e){
		lista('usuarioID', '2', '16', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});

	$('#usuarioID').blur(function() {
		validaUsuario(this.id);
	});
	$('#grabarAE').click(function(event){
		$('#tipoTransaccion').val(cat_reasignar.Analistas);
		grabaReasignacionSolicitudes('tbAnalistasAsignacion',event);
		
	});
	
inicializar();
	
});

function grabaReasignacionSolicitudes(idControl,event){
		if ($("#formaGenerica").valid()) {
			if(llenarDetalle(idControl))
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID','funcionExito','funcionError');
		}
	
}


function validaUsuario(idControl) {
	var numUsuario =$('#'+idControl).val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numUsuario != '' && !isNaN(numUsuario) ){
			var usuarioBeanCon = {
					'usuarioID':numUsuario
			};
			usuarioServicio.consulta(19,usuarioBeanCon,{ async: false, callback:function(usuario) {
				if(usuario!=null){
                     $('#nombreAnalista').val(usuario.nombreCompleto);
                     	consultaListaAsignaciones(idControl);
				}else{
                   mensajeSis("Analista sin solicitudes de credito asignadas");    
                     $('#usuarioID').focus();
                     $('#nombreAnalista').val('');
                     $("#numTab").val(1);
                     funcionLimpiaGrid();
				}

			}});
	}
}


function consultaSolicitudesDeAnalista(idControl){
		var usuarioId = $('#'+idControl).val();

	var analistasAsigBean = {
			'tipoLista':	tipo_lista.usuariosA,
			'usuarioID':usuarioId

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
	$.post("solicitudCreAsigMasivaGrid.htm", analistasAsigBean, function(data) {
		if (data.length > 0 ) {
			$(gridDetalleDiv).html(data);
			$(gridDetalleDiv).show();

	     habilitaBoton('grabarAE','submit');
	      $("#grabarAE").focus();
		} else {
			$(gridDetalleDiv).html("");
			$(gridDetalleDiv).show();
		}
		// Se cambia el id de la tabla que viene desde el jsp del grid por uno nuevo.
		$("#tbParametrizacion").attr('id', idTablaParametrizacion);
		$("#numTab").attr('id', idTab);
		
	});	

}

function consultaListaAsignaciones(idControl){
	consultaSolicitudesDeAnalista(idControl);
}

function getRenglones(idTablaParametrizacion){
	var idTipoReng = '';
	var numRenglones = $('#'+idTablaParametrizacion+' >tbody >tr[name^="tr'+'"]').length;
	return numRenglones;
}

function llenarDetalle(idControl){
	var idTablaParametrizacion = $('#'+idControl).closest('table').attr('id');
	var idDetalle = '';
	var validar = true;

	idDetalle ='#listaAsignacionSol';

	$('#listaAsignacionSol').val('');

	$('#'+idTablaParametrizacion+' tr').each(function(index){
		if(index>0){
			var solicitudCre = "#"+$(this).find("input[name^='solicitudCreditoID"+"']").attr("id");
			var producto ="#"+$(this).find("input[name^='productoID"+"']").attr("id");
			var tipoAsignacion = "#"+$(this).find("input[name^='tipoAsignacionID"+"']").attr("id");
			var usuarioID = "#"+$(this).find("input[name^='usuarioID"+"']").attr("id");

            
            var solicitudId = $(solicitudCre).val();
			var productoI = $(producto).val();
			var tipoAsig = $(tipoAsignacion).val();
			var usuario = $(usuarioID).val();


			if (index == 1) {
				$(idDetalle).val( $(idDetalle).val()+
				solicitudId+']'+ tipoAsig+']' + productoI+']'+usuario+']');
			} else{
				$(idDetalle).val( $(idDetalle).val()+'['+
				solicitudId+']'+ tipoAsig+']' + productoI+']'+usuario+']');
			}
		}
	});
	deshabilitaBoton('grabarAE','submit');
	return true;
}

function inicializar(){
	deshabilitaBoton('grabarAE','submit');
   		$("#usuarioID").focus();

}
function funcionLimpiaGrid(){
var gridDetalleDiv = '';
	gridDetalleDiv ='#gridAsignacionAnalistas';
	$(gridDetalleDiv).html("");
	$(gridDetalleDiv).show();
}

/**
 * Función de  de éxito que se ejecuta cuando después de grabar
 * la transacción y ésta fue exitosa.
 * @author avelasco-ctomas
 */
function funcionExito(){
	inicializar();

	mensajeSis("Solicitudes Reasignadas exitosamente");
	funcionLimpiaGrid();
}

function funcionError(){
	
}