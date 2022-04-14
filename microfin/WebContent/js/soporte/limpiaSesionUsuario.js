$(document).ready(function() {
	esTab = true;
	//validaCap=false;
	//Definicion de Constantes y Enums  
	var catTipoActualizaUsuario = {
			'actualizaCancel':3,
			'resetPassword':4, 
			'actualizaSesion':7,
	};
	var catTipoConsultaUsuario = { 
			'cancela':5, 
			'limpia':9,
	};
	var cancelado ='C';
	var activo = 'A';
	var bloqueado = 'B';
	var parametroBean = consultaParametrosSession(); 

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	deshabilitaBoton('limpiar', 'submit');

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

	/*	$('#cancelar').click(function() {		
		$('#tipoTransaccion').val(catTipoActualizaUsuario.actualizaCancel);  
	});*/
	$('#limpiar').click(function() {
		var claveUsu = $('#clave').val();
		eliminaSessionUsu(claveUsu);
		/*$('#tipoTransaccion').val(catTipoActualizaUsuario.actualizaSesion); */ 
	});

	$('#usuarioID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('usuarioID', '2', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});

	$('#usuarioID').blur(function() {
		consultaUsuario(this.id);
	});


	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({

		rules: {

			usuarioID: {
				required: true

			},

		},
		messages: {


			usuarioID: {
				required: 'Especificar Numero'

			},


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
		if(numUsuario != '' && !isNaN(numUsuario)  ){
			usuarioServicio.consulta(catTipoConsultaUsuario.limpia,usuarioBeanCon,function(usuario) {  
				if(usuario!=null){
					dwr.util.setValues(usuario); 
					var status = usuario.estatus;
					var clave = usuario.clave;
					consultaUsuarioLogeado(clave); 
				}else{ 
					alert("No Existe el Usuario");
					limpiaPantalla();
					deshabilitaBoton('limpiar', 'submit');	 		
				}    						
			});
		}
	}
	
	function consultaUsuarioLogeado(claveU) {
		var claveUsuario = claveU;
		usuarioServicio.consultaUsuarioLogeado(claveUsuario,function(usuario) {  
				var estaLogeado = usuario;
				if(estaLogeado=="S"){
					alert('El Usuario '+claveUsuario+' tiene una Sesión Activa');
					$('#logueado option[value=S]').attr('selected',true);
					habilitaBoton('limpiar', 'submit');
				}
				else{
					$('#logueado option[value=N]').attr('selected',true);
					deshabilitaBoton('limpiar', 'submit');	 		
				}
		});
	
	}
	
	function eliminaSessionUsu(claveU) {
		var claveUsuario = claveU;
		usuarioServicio.eliminaSessionUsuario(claveUsuario,function(eliminaSe) {  
			if(eliminaSe!=null){
				alert(""+eliminaSe.descripcion);
				deshabilitaBoton('limpiar', 'submit');	 		
			}else{
				alert("El procedimiento no regresa ningun valor");
			}
					
		});
	
	}
	


	function limpiaPantalla(){

		inicializaForma('formaGenerica', 'UsuarioID');
		$('#estatus option[value=A]').attr('selected',true);
		$('#estatusSesion option[value=A]').attr('selected',true);
		$('#logueado option[value=S]').attr('selected',true);

	}

});