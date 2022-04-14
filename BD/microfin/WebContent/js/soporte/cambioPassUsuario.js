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
  		'cambioPassword':4      
	};
	var catTipoConsultaUsuario = {  
		'contrasenia':6,
  		'cancela':5
	};
	var cancelado ='C';
	var activo = 'A'; 
	var bloqueado = 'B';
	var parametroBean = consultaParametrosSession();   
	//------------ Metodos y Manejo de Eventos -----------------------------------------

   deshabilitaBoton('cancelar', 'submit');
	paramConfigContrasenia();
	valdidaReglaPasword();

	$(':text').focus(function() {
	 	esTab = false;
	});
	 
	$.validator.setDefaults({
            submitHandler: function(event) { 
                    grabaFormaTransaccionCambio(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','usuarioID');
            } 
    });	
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#actualizar').click(function() {	
		var envia = validaNuevaContra('Confirmacontra');
		if( envia){
			$('#tipoTransaccion').val(catTipoActualizaUsuario.cambioPassword);  
		}else{
			return false;
		}	
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
	$('#contrasenia').blur(function() {
  		validaContrasenia(this.id); 
	});
	$('#Confirmacontra').blur(function() {
  		validaNuevaContra(this.id);  
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
					
		},
		messages: {
			
		 
			usuarioID: {
				required: 'Especificar Numero'
			
			},
			contrasenia: {
				required: 'Especificar ' 
			
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
		if(numUsuario != '' && !isNaN(numUsuario) && esTab){
			usuarioServicio.consulta(catTipoConsultaUsuario.cancela,usuarioBeanCon,function(usuario) {  
						if(usuario!=null){
						//dwr.util.setValues(usuario);
						$('#nombreCompleto'). val(usuario.nombreCompleto);
						$('#clave'). val(usuario.clave); 
						$('#fechUltAcces'). val(usuario.fechUltAcces);
						$('#fechUltPass'). val(usuario.fechUltPass); 	 	  	  
							var status = usuario.estatus; 
						if(status == cancelado){  
						alert('El usuario ya esta Cancelado');	  
						deshabilitaBoton('actualizar', 'submit'); 	 
						}	 			
						}else{  
							alert("No Existe el Usuario");
							inicializaForma('formaGenerica', 'UsuarioID');
						}    						
				});
			}
		}
		 
		
		function validaContrasenia(idControl) {
		var jqContra = eval("'#" + idControl + "'");
		var contrasen = $(jqContra).val();	
		//alert('contraseña'+contrasen);
		var usuarioBeanCon = {      
  						'usuarioID':$('#usuarioID').val(),
  						'contrasenia':contrasen
				};
		setTimeout("$('#cajaLista').hide();", 200);		 
		if(contrasen != '' && esTab){
			usuarioServicio.consulta(catTipoConsultaUsuario.contrasenia,usuarioBeanCon,function(usuario) {  
						if(usuario!=null){
						var incorr= 'La Contraseña Actual es incorrecta:';
							if(usuario.contrasenia==incorr){
							alert(usuario.contrasenia);
							$('#contrasenia').focus(); 
							$('#contrasenia').select();
							}
						} 		 						
				});
			}
		}
		
		function validaNuevaContra(idControl) { 
		var jqconfContra = eval("'#" + idControl + "'");
		var confContra = $(jqconfContra).val();	
		var nContra= $('#nuevaContra').val();  
			if(confContra!=nContra){    
				alert('Las contraseñas no coinciden');
				$('#nuevaContra').focus();
				$('#nuevaContra').val('');
				$('#Confirmacontra').val('');
				deshabilitaBoton('actualizar', 'submit');
				return false;
			}else{
				habilitaBoton('actualizar', 'submit');
				return true;
			}
		}
		
		function grabaFormaTransaccionCambio(event, idForma, idDivContenedor, idDivMensaje,
				inicializaforma, idCampoOrigen) {
			consultaSesion();
			var jqForma = eval("'#" + idForma + "'");
			var jqContenedor = eval("'#" + idDivContenedor + "'");
			var jqMensaje = eval("'#" + idDivMensaje + "'");
			var url = $(jqForma).attr('action');
			var resultadoTransaccion = 0;	
	
			quitaFormatoControles(idForma);
			//No descomentar la siguiente linea
			//event.preventDefault();
			$(jqMensaje).html('<img src="images/barras.jpg" alt=""/>');   
			$(jqContenedor).block({
				message: $(jqMensaje),
				css: {border:		'none',
						background:	'none'}
				});
			// Envio de la forma
			$.post( url, serializaForma(idForma), function( data ) {
				if(data.length >0) {
					$(jqMensaje).html(data);
					var exitoTransaccion = $('#numeroMensaje').val();
					resultadoTransaccion = exitoTransaccion; 
					if (exitoTransaccion == 3 || exitoTransaccion == 2){
						$('#nuevaContra').val('');
						$('#Confirmacontra').val('');
						$('#ligaCerrar').click(function () {
							$('#nuevaContra').focus();
						});
					}
					if (exitoTransaccion == 0 && inicializaforma == 'true' ){
						inicializaForma(idForma, idCampoOrigen);
						$('#ligaCerrar').click(function () {
							cerrarSession();
						});
						//cerrarSession();
					}
					var campo = eval("'#" + idCampoOrigen + "'");
					if($('#consecutivo').val() != 0){
						$(campo).val($('#consecutivo').val());
					}		
				}
			});
		return resultadoTransaccion;
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
			mensajeLabel += 'Reglas para definir password: <br>&nbsp;&nbsp;&nbsp;1.Longitud Mínima de ' + caracterMinimo + ' Caracteres.';
	
			if(reqCaracterMayus == 'S'){
				if(caracterMayus > 1) {
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;2.Debe contener al menos: ' + caracterMayus + ' Caracteres Alfabéticos Mayúsculas.');
				}else{
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;2.Debe contener al menos: ' + caracterMayus + ' Caracter Alfabético Mayúsculas.');
				}
			}
	
			if(reqCaracterMinus == 'S'){
				if(caracterMinus > 1){
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;3.Debe contener al menos: ' + caracterMinus + ' Caracteres Alfabéticos Minúscula.');
				}else{
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;3.Debe contener al menos: ' + caracterMinus + ' Caracter Alfabético Minúscula.');
				}
			}
	
			if(reqCaracterNumerico == 'S'){
				if(caracterNumerico > 1){
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;4.Debe contener al menos: ' + caracterNumerico + ' Caracteres Numéricos.');
				}else{
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;4.Debe contener al menos: ' + caracterNumerico + ' Caracter Numérico.');
				}
			}
	
			if(reqCaracterEspecial == 'S'){
				if(caracterEspecial > 1){
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;5.Debe contener al menos: ' + caracterEspecial + ' Caracteres Especiales.<br>&nbsp;&nbsp;&nbsp;6.No debe ser igual a ningun password anterior.');
				}else{
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;5.Debe contener al menos: ' + caracterEspecial + ' Caracter Especial.<br>&nbsp;&nbsp;&nbsp;6.No debe ser igual a ningun password anterior.');
				}
			}
		}else{
			mensajeLabel += 'Reglas para definir password: <br>&nbsp;&nbsp;&nbsp;1. Longitud Mínima de 6 caracteres.<br>&nbsp;&nbsp;&nbsp;2. Debe contener al menos: 1 Caracter Alfabético Mayúsculas, 1 Caracter Alfabético Minúscula,1 Número o Caracter Especial.<br>&nbsp;&nbsp;&nbsp;3.No debe ser igual a ningun password anterior.';
		}
		
		$('#mensajeLabel').html(mensajeLabel);
	}		
	