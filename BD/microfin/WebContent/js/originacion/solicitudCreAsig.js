
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

	$('#grabarAE').click(function(event){
		$('#tipoTransaccion').val(cat_tipoPerfiles.Analistas);
		grabaReasignacionAnalista(event);
		
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$('#solicitudCreditoID').bind('keyup',function(e){
		lista('solicitudCreditoID', '2', '1', 'solicitudCreditoID', $('#solicitudCreditoID').val(), 'listaSolicitudesCreAsig.htm');
	});
	$('#solicitudCreditoID').blur(function() {
  		validaSolicitudCreAsig(this);
	});


	$('#usuarioID').bind('keyup',function(e){
		lista('usuarioID', '2', '16', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});

	$('#usuarioID').blur(function() {
  		validaUsuario(this);
	});

	iniciar();
});


function grabaReasignacionAnalista(event){
	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID','funcionExito','funcionError');

}


function validaSolicitudCreAsig(control) {
	var numSolicitudCre = $('#solicitudCreditoID').val().trim();
    $('#solicitudCreditoID').val(numSolicitudCre);
	setTimeout("$('#cajaLista').hide();", 200);
	if(numSolicitudCre != '' && !isNaN(numSolicitudCre) ){
			var SolicitudCreBeanCon = {
					'solicitudCreditoID':numSolicitudCre
			};
			solicitudesCreAsigServicio.consulta(1,SolicitudCreBeanCon,{ async: false, callback:function(solicitudCre) {
				if(solicitudCre!=null){
					 $('#descripcion').val(solicitudCre.nombreCompletoC);
                     $('#usuarioAnalista').val(solicitudCre.usuarioID);
                     $('#nombreCompleto').val(solicitudCre.nombreAnalista);
                     $('#tipoAsignacionID').val(solicitudCre.tipoAsignacionID);
                     $('#productoID').val(solicitudCre.productoID);
				}else{
                   mensajeSis("Solicitud sin analista asignado");   
                   limpiarCampos(); 
                   	$("#solicitudCreditoID").focus();

				}

			}});
		
		}
	}


function validaUsuario(control) {
		var numSolicitudCre = $('#solicitudCreditoID').val();
		var numTipoAsignacion = $('#tipoAsignacionID').val();
		var numProductoID = $('#productoID').val();
	    var numUsuario = $('#usuarioID').val();

	setTimeout("$('#cajaLista').hide();", 200);
	if(numUsuario != '' && !isNaN(numUsuario)  && numUsuario!= 0 ){
			var SolicitudCreBeanCon = {
					'solicitudCreditoID':numSolicitudCre,
					'tipoAsignacionID':numTipoAsignacion,
					'productoID' :numProductoID,
					'usuarioID':numUsuario
			};
			solicitudesCreAsigServicio.consulta(2,SolicitudCreBeanCon,{ async: false, callback:function(solicitudCre) {
				if(solicitudCre!=null){
                     $('#nombreCompletoi').val(solicitudCre.nombreAnalista);
                     habilitaBoton('grabarAE','submit');
				}else{
                   mensajeSis("El analista no esta activo o no corresponde al tipo de credito");  
                   limpiarUsuario();  
				}

			}});
		
		}
		if(numUsuario==0){
		$('#nombreCompletoi').val("ANALISTA VIRTUAL");
	    $('#usuarioID').val('0');
	     habilitaBoton('grabarAE','submit');
	    }
	}



	/**
 * Función de  de éxito que se ejecuta cuando después de grabar
 * la transacción y ésta fue exitosa.
 * @author avelasco-ctomas
 */
function funcionExito(){
	limpiarCampos();
}
function iniciar(){
	limpiarCampos();
	   	$("#solicitudCreditoID").focus();
}
/**
 * Funcion de error que se ejecuta cuando después de grabar
 * la transacción marca error.
 * @author avelasco-ctomas
 */
function funcionError(){
	$("#usuarioID").val('');
	$("#usuarioID").focus();
}

	function limpiarUsuario(){
		$("#nombreCompletoi").val('');
		$("#usuarioID").focus();
	}


	function limpiarCampos(){
		$("#usuarioAnalista").val('');  
	    $("#nombreCompleto").val('');
	    $("#usuarioID").val('');
	       $("#descripcion").val('');
	    $("#nombreCompletoi").val('');
	      deshabilitaBoton('grabarAE','submit');
	}




