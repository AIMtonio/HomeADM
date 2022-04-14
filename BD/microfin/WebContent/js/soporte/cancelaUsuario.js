$(document).ready(function() {
	esTab = false;
	//-------------DEFINICION DE CONSTANTES Y ENUMS  
	var catTipoActualizaUsuario = {
			'actualizaCancel':3,
			'resetPassword':4, 
			'reactiva':9,       
	};
	var catTipoConsultaUsuario = { 
			'cancela':5, 
	};
	var cancelado ='C';
	var activo = 'A';
	var bloqueado = 'B';
	var parametroBean = consultaParametrosSession(); 

	//------------ METODOS Y MANEJO DE EVENTOS -----------------------------------------
	limpiaPantalla();
	$('#usuarioID').focus();

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','usuarioID','funcionExito', 'funcionError'); 
		}
	});	
	
	$('#cancelar').click(function() {
		$('#usuarioIDRespon').val(parametroBean.numeroUsuario);
		$('#tipoTransaccion').val(catTipoActualizaUsuario.actualizaCancel);  
	});
	
	$('#reactivar').click(function() {	
		$('#usuarioIDRespon').val(parametroBean.numeroUsuario);
		$('#tipoTransaccion').val(catTipoActualizaUsuario.reactiva);  
	});

	$('#usuarioID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('usuarioID', '2', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});

	$('#usuarioID').blur(function() {
		if(esTab){
			consultaUsuario(this.id);
		}		
	});


	//------------ VALIDACIONES DE LA FORMA -------------------------------------

	$('#formaGenerica').validate({

		rules: {

			usuarioID: {
				required: true

			},
			motivoCancel: {
				required: function() { if($('#tipoTransaccion').val() == catTipoActualizaUsuario.actualizaCancel) return true; else return false;}

			},
			motivoReactiva: {
				required: function() { if($('#tipoTransaccion').val() == catTipoActualizaUsuario.reactiva) return true; else return false;}

			},
			motivoNuevo: {
				required: function() { if($('#esNuevoComenCance').val() == 'S') return true; else return false;}

			}

		},
		messages: {


			usuarioID: {
				required: 'Especifique Numero'

			},
			motivoCancel: {
				required: 'Especifique motivo de cancelación'

			},
			motivoReactiva: {
				required: 'Especifique motivo de reactivación'

			},
			motivoNuevo: {
				required: 'Especifique nuevo motivo'

			}


		}		
	});

	//------------ VALIDACIONES DE CONTROLES -------------------------------------
	
	// FUNCION PARA CONSULTAR LOS DATOS DEL USUARIO
	function consultaUsuario(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();	
		var usuarioBeanCon = {  
				'usuarioID':numUsuario 
		};		
		setTimeout("$('#cajaLista').hide();", 200);
		
		limpiaPantalla();		
		if(numUsuario != '' && !isNaN(numUsuario) && numUsuario > 0 ){
			usuarioServicio.consulta(catTipoConsultaUsuario.cancela,usuarioBeanCon,function(usuario) {  
				if(usuario!=null){
					dwr.util.setValues(usuario); 
					var status = usuario.estatus; 
					if(status == activo){
						habilitaBoton('cancelar', 'submit');
						$('#fechaCancel').val(parametroBean.fechaSucursal);
						habilitaControl('motivoCancel');
						$('#motivoCancel').focus(); 
					}else{
						if(status == bloqueado){ 
							habilitaBoton('cancelar', 'submit');
							habilitaControl('motivoCancel');
							$('#fechaCancel').val(parametroBean.fechaSucursal);
							$('#motivoCancel').focus();
						} else{
							if(status == cancelado){    
								habilitaBoton('reactivar', 'submit'); 
								$('#fechaReactiva').val(parametroBean.fechaSucursal);	
							}
						}
					}
					if(usuario.fechaCancel != '' && usuario.fechaReactiva != ''){// SE CANCELA UN USUARIO QUE YA SE REACTIVO
						$('#trNuevoMotivo').show();
						$('#tdFechaReactiva').show();
						$('#tdInputFechaReactiva').show();
						$('#tdUsuResp').show();
						$('#tdInputUsuarioRes').show();
						$('#trMotivoClaveUsu').show();
						consultaClaveNombreUsuario(usuario.usuarioIDReactiva);
						$('#esNuevoComenCance').val('S');// BANDERA PARA SABER SI SE VA A CANCELAR OTRA VEZ EL USUARIO
						$('#motivoNuevo').focus();
					}else{
						if(usuario.fechaCancel == ''){// SE CANCELA POR PRIMERA VEZ UN USUARIO
							habilitaControl('motivoCancel');
							$('#motivoCancel').focus();
						}else{
							if(usuario.fechaCancel != '' && status == cancelado){// SE REACTIVA UN USUARIO QUE ESTA CNACELADO
								$('#tdFechaReactiva').show();
								$('#tdInputFechaReactiva').show();
								$('#tdUsuResp').show();
								$('#tdInputUsuarioRes').show();
								$('#trMotivoClaveUsu').show();
								consultaClaveNombreUsuario(usuario.usuarioIDCancel);
								habilitaControl('motivoReactiva');
								
								$('#motivoReactiva').focus();
							}							
						}
					}					
				}else{ 
					$(jqUsuario).focus();
					$(jqUsuario).select();
					mensajeSis("No Existe el Usuario");
				}    						
			});
		}else{
			if(isNaN(numUsuario)){
				$(jqUsuario).focus();
				$(jqUsuario).select();
				mensajeSis("No Existe el Usuario");
			}else{
				if(numUsuario =='' || numUsuario == 0){
					$(jqUsuario).val('');
				}
			}
		}
	}

	function consultaClaveNombreUsuario(numUsuario) {
		var numConsulta = 1;
		var usuarioBeanCon = {  
				'usuarioID':numUsuario 
		};				
		
		if(numUsuario != '' && !isNaN(numUsuario) && numUsuario > 0 ){
			usuarioServicio.consulta(numConsulta,usuarioBeanCon,function(usuario) {  
				if(usuario!=null){
					$('#nombreUsuarioRespon').val(usuario.nombreCompleto.toUpperCase());
					$('#claveUsuarioRespon').val(usuario.clave.toUpperCase());
				}   						
			});
		}
	}


}); // FIN READY

// FUNCION PARA LIMIAR LOS CAMPOS DE LA PANTALLA MENOS EL DE USUARIO
function limpiaPantalla(){
	inicializaForma('formaGenerica', 'usuarioID');
	$('#estatus option[value=A]').attr('selected',true);
	deshabilitaBoton('cancelar', 'submit');
	deshabilitaBoton('reactivar', 'submit');
	$('#trNuevoMotivo').hide();
	deshabilitaControl('motivoReactiva');
	deshabilitaControl('motivoCancel');
	$('#esNuevoComenCance').val('N');
	$('#tdFechaReactiva').hide();
	$('#tdInputFechaReactiva').hide();
	$('#tdUsuResp').hide();
	$('#tdInputUsuarioRes').hide();
	$('#trMotivoClaveUsu').hide();
}

// FUNCION DE EXITO DE TRANSACCION
function funcionExito(){
	//SI SE TRATA DE UNA REACTIVACION MOSTRARA EL MENSAJE SOLAMENTE
	if($('#tipoTransaccion').val() == 9){
		alert('Por seguridad debe hacer el reset de password del usuario reactivado');
	}
	limpiaPantalla();
}

//FUNCION DE ERROR DE TRANSACCION
function funcionError(){
	
}