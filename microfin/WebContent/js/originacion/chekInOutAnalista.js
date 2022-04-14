
var esTab = false;
var cat_tipo = {
	'Actualizar' : 10
};

$(document).ready(function() {

    var parametroBean = consultaParametrosSession();
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

	$('#Actualizar').click(function(event){
		actualizaEstatusAnalista(event);
	});
	
	inicializar();

});

function actualizaEstatusAnalista(event){
	$('#tipoActualizacion').val(cat_tipo.Actualizar);
		if ($("#formaGenerica").valid()) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID','funcionExito','funcionError');
		}
	
}


function consultaUsuario(){
		var numUsuario = parametroBean.numeroUsuario;
		if(numUsuario != '' && !isNaN(numUsuario)){
		
				var usuarioBeanCon = {
						'usuarioID':numUsuario
				};
				usuarioServicio.consulta(20,usuarioBeanCon,{ async: false, callback:function(usuario) {
					if(usuario!=null){
						$('#nombreCompleto').val(usuario.nombreCompleto);
						$('#usuarioID').val(usuario.usuarioID);
                            if(usuario.estatusAnalisis=='I'){
                            	$('#estatusAnalisis').val("INACTIVO");
                            }else{
                            	$('#estatusAnalisis').val("ACTIVO");
                            }
					}else{
						inicializaForma('formaGenerica','usuarioID');
					    mensajeSis("Usuario sin Perfil de Analista");
					   deshabilitaBoton('Actualizar','submit');
					}
				}});
			  
		}
}


function funcionError(){
	
}

function inicializar(){
	consultaUsuario();
}
function funcionExito(){
	inicializar();
}
