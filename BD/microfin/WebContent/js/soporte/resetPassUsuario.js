var caracterMinimo = 0;
var caracterMayus = 0;
var caracterMinus = 0;
var caracterNumerico = 0;
var caracterEspecial = 0;
var reqCaracterMayus = "";
var reqCaracterMinus  = "";
var reqCaracterNumerico = "";
var reqCaracterEspecial = "";
var habilitaConfPass  = "";

$(document).ready(function() {
	esTab = true;
	//validaCap=false;
	//Definicion de Constantes y Enums  
	var catTipoActualizaUsuario = {
  		'resetPassword':  8
	};
	var catTipoConsultaUsuario = { 
  		'cancela':5
	};
	var cancelado ='C';
	var activo = 'A';
	var bloqueado = 'B';
	var parametroBean = consultaParametrosSession();   
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	paramConfigContrasenia();
	valdidaReglaPasword();
	validaPassword();
   deshabilitaBoton('actualizar', 'submit');
   deshabilitaBoton('cancelar', 'submit');
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
            submitHandler: function(event) { 
            	if(validaPassword()==true){
                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','usuarioID'); 
            	}
            }
    });	
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#actualizar').click(function() {		
		$('#tipoTransaccion').val(catTipoActualizaUsuario.resetPassword);  
	});
	
	$('#Continuar').click(function() {
	if( parseInt($('#numeroMensaje').val()) == 0){	
		
	$('#contenedorForma').html(''); 

		}
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
			contrasenia: {
				required: true
				
			},
			
			confirmarContra:{
				required : true
			},
					
		},
		messages: {
			
		
			usuarioID: {
				required: 'Especificar Numero'
			
			},
			contrasenia: {
				required: 'Especificar Contraseña '
			
			},
			confirmarContra: {
				required: 'Especificar la confirmacion de la contraseña'
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
		if(numUsuario != '' && !isNaN(numUsuario)  ){
			usuarioServicio.consulta(catTipoConsultaUsuario.cancela,usuarioBeanCon,function(usuario) {  
						if(usuario!=null){
						//dwr.util.setValues(usuario);
						$('#nombreCompleto'). val(usuario.nombreCompleto);
						$('#clave'). val(usuario.clave); 
						$('#fechUltAcces'). val(usuario.fechUltAcces);
						$('#fechUltPass'). val(usuario.fechUltPass); 	 	  	 
							var status = usuario.estatus; 
						if(status == cancelado){  
						mensajeSis('El usuario ya esta Cancelado');	  
						deshabilitaBoton('actualizar', 'submit'); 	 
						}	else{
							habilitaBoton('actualizar', 'submit');
						} 			
						}else{ 
							mensajeSis("No Existe el Usuario");
							inicializaForma('formaGenerica', 'UsuarioID');
							deshabilitaBoton('actualizar', 'submit');
						}    						
				});
			}
		}
		
});


//Consulta de parametros de configuracion de contraseña
function paramConfigContrasenia() {
	var numEmpresaID = 1;
	var tipoCon = 23;
	var ParametrosSisBean = {
		'empresaID'	:numEmpresaID
	};
	parametrosSisServicio.consulta(tipoCon,ParametrosSisBean, { async: false, callback:function(parametrosSisBean) {
		if (parametrosSisBean != null) {
			caracterMinimo = parametrosSisBean.caracterMinimo;
			caracterMayus = parametrosSisBean.caracterMayus;
			caracterMinus = parametrosSisBean.caracterMinus;
			caracterNumerico = parametrosSisBean.caracterNumerico;
			caracterEspecial = parametrosSisBean.caracterEspecial;
			reqCaracterMayus = parametrosSisBean.reqCaracterMayus;
			reqCaracterMinus = parametrosSisBean.reqCaracterMinus;
			reqCaracterNumerico = parametrosSisBean.reqCaracterNumerico;
			reqCaracterEspecial = parametrosSisBean.reqCaracterEspecial;
			habilitaConfPass = parametrosSisBean.habilitaConfPass;
		}
	}});
}

	function valdidaReglaPasword(){
		var mensajeLabel = '';
	
		if(habilitaConfPass == "S"){
			mensajeLabel += 'Reglas para definir password: <br>&nbsp;&nbsp;&nbsp;1.-Longitud Mínima de ' + caracterMinimo + ' Caracteres.';
	
			if(reqCaracterMayus == 'S'){
				if(caracterMayus > 1){
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;2.-Debe contener al menos: ' + caracterMayus + ' Caracteres Alfabéticos Mayúsculas.');
				}else{
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;2.-Debe contener al menos: ' + caracterMayus + ' Caracter Alfabético Mayúsculas.');	
				}
			}
	
			if(reqCaracterMinus == 'S'){
				if(caracterMinus > 1){
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;3.-Debe contener al menos: ' + caracterMinus + ' Caracteres Alfabéticos Minúscula.');
				}else{
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;3.-Debe contener al menos: ' + caracterMinus + ' Caracter Alfabético Minúscula.');
				}
			}
	
			if(reqCaracterNumerico == 'S'){
				if(caracterNumerico > 1){
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;4.-Debe contener al menos: ' + caracterNumerico + ' Caracteres Numérico.');
				}else{
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;4.-Debe contener al menos: ' + caracterNumerico + ' Caracter Numérico.');
				}
			}
	
			if(reqCaracterEspecial == 'S'){
				if(caracterEspecial > 1) {
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;5.-Debe contener al menos: ' + caracterEspecial + ' Caracteres Especiales.');
				}else{
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;5.-Debe contener al menos: ' + caracterEspecial + ' Caracter Especial.');
				}
			}
		}else{
			mensajeLabel += 'Reglas para definir password: <br>&nbsp;&nbsp;&nbsp;1. Longitud Mínima de 6 caracteres.<br>&nbsp;&nbsp;&nbsp;2. Debe contener al menos: 1 Caracter Alfabético Mayúsculas, 1 Caracter Alfabético Minúscula,1 Número o Caracter Especial.';
		}
		
		$('#mensajeLabel').html(mensajeLabel);
	}		

	
	

	function validaPassword(){
		var contrasenia = $('#contrasenia').val();
		var confirmarContra = $('#confirmarContra').val();
		if(contrasenia != confirmarContra){
			mensajeSis("la contraseña y la confirmacion son diferentes");
			return false;
		} else {
			return true;
		}
	}