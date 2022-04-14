$(document).ready(function() {
	esTab = true;
		
	//Definicion de Constantes y Enums  
	var catTipoActualizaUsuario = {
  		'actualizaBloDes':2,
	};
	var catTipoConsultaUsuario = {
  		'bloqueadoDesbloq':4, 
	};
	var bloqueado ='B';
	var parametroBean = consultaParametrosSession(); 
	$('#usuarioID').focus();
	//------------ Metodos y Manejo de Eventos -----------------------------------------

	deshabilitaBoton('actualiza', 'submit');
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
            submitHandler: function(event) { 
                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','usuarioID'); 
            }
    });	
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#actualiza').click(function() {		
		$('#tipoTransaccion').val(catTipoActualizaUsuario.actualizaBloDes);  
	});
	
	$('#usuarioID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('usuarioID', '2', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});
		
	$('#usuarioID').blur(function() {
  		consultaUsuario(this.id);
	});
	
	$('#estatus').blur(function() {
		var status = $('#estatus').val();
  		if(status == bloqueado){  		
  			mostrarCampos();	
  			$('#fechaBloq').val(parametroBean.fechaSucursal);  
  		}else{
  			ocultarCampos();
  		}  
	});	
	
	$('#estatus').change(function() {
		var status = $('#estatus').val();
  		if(status == bloqueado){
  			mostrarCampos();
  			$('#fechaBloq').val(parametroBean.fechaSucursal);  
  		}else{
  			ocultarCampos();
  		}  
	});	
	
	$('#fechaBloqueo').blur(function() {
		$('#actualiza').focus();  
	});		


			
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			estatus: {
				required: true
			},
			motivoBloqueo: {
				required : function() {return $('#estatus').val() == 'B';},
			}

			
		},
		messages: {
			estatus: {
				required: 'Especificar Estatus'
			},
			motivoBloqueo: {
				required: 'Especificar Motivo de Bloqueo'
			}
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	
	function consultaUsuario(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();	
		var usuarioBeanCon = {
  				'usuarioID':numUsuario 
				};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numUsuario != '' && !isNaN(numUsuario) && esTab){
			usuarioServicio.consulta(catTipoConsultaUsuario.bloqueadoDesbloq,usuarioBeanCon,function(usuario) {  
						if(usuario!=null){		
						$('#nombreCompleto').val(usuario.nombreCompleto);
						$('#clave').val(usuario.clave);
						$('#fechUltAcces').val(usuario.fechUltAcces);
						$('#fechUltPass').val(usuario.fechUltPass);
						$('#motivoBloqueo').val(usuario.motivoBloqueo);
						$('#fechaBloq').val(usuario.fechaBloqueo);
						var status = usuario.estatus;     
						if(status == bloqueado){
				  			mostrarCampos();
				  			$('#estatus').val("B");
				  		}else{ 
				  			ocultarCampos();
					  		$('#motivoBloqueo').val('');
							$('#fechaBloqueo').val('');
				  			$('#estatus').val("A");
				  		}  
						habilitaBoton('actualiza', 'submit');
						var cancel= 'C';
				  		if(status == cancel){ 
				  			$('#usuarioID').focus();
				  			mensajeSis('El usuario no se puede bloquear está Cancelado');
				  			$('#estatus').attr("disabled",true);   
				  			deshabilitaBoton('actualiza', 'submit');		   	
				  		}else{ 
					  		$('#estatus').removeAttr('disabled');
				  		}
				  		
						}else{
							ocultarCampos();
					  		limpiarCampos();
							$('#usuarioID').focus();
							mensajeSis("No Existe el Usuario");
						}    						
				});
			}
		}

		function limpiarCampos() {
			$('#motivoBloqueo').val('');
			$('#fechaBloqueo').val('');
			$('#nombreCompleto').val('');
			$('#clave').val('');
			$('#fechUltAcces').val('');
			$('#fechUltPass').val('');
			$('#estatus').val('A');
		}

		function ocultarCampos(){
			$('#bloqueolblmo').hide();
  			$('#bloqueoinmo').hide();
  			$('#bloqueolblfe').hide();
  			$('#bloqueoinfe').hide();
		}	
		
		function mostrarCampos(){
			$('#bloqueolblmo').show();
  			$('#bloqueoinmo').show();
  			$('#bloqueolblfe').show();
  			$('#bloqueoinfe').show();
		}
});