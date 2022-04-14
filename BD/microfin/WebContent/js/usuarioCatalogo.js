$(document).ready(function() {
	esTab = true;
	validaCap=false;
	//Definicion de Constantes y Enums  
	var catTipoTransaccionUsuario = {
  		'agrega':'1',
  		'modifica':'2',
  		'inactiva':'3'
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------

   deshabilitaBoton('modifica', 'submit');
   deshabilitaBoton('agrega', 'submit');
	
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$('#formaGenerica').submit(function(event){
		if(validaCap==true){
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje')
		}else{
		   alert('Codigo de imagen incorrecto');
			return false;
		}
	});				
		    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionUsuario.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionUsuario.modifica);
	});		
	
	$('#numero').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('numero', '4', '1', 'nombre', $('#numero').val(), 'listaUsuarios.htm');
	});
		
	$('#numero').blur(function() {
  		validaUsuario(this);
	});		
	
	$('#j_captcha_response').blur(function() {
		validaCaptcha(this);
    });	
    
	/*$('#j_captcha_response').focus(function() {	
	deshabilitaBoton('modifica', 'submit');
  deshabilitaBoton('agrega', 'submit');    
    });*/
			
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			
			nombre: {
				required: true,
				minlength: 5
			},
			clave: {
				required: true,
				minlength: 8
			},
			contrasenia: {
				required: true,
				minlength: 6
			},			
		},
		messages: {
			
		
			nombre: {
				required: 'Especificar Nombre',
				minlength: 'Al menos 5 Caracteres'
			},
			
			clave: {
				required: 'Especificar Clave',
				minlength: 'Al menos 8 Caracteres'
			},

			contrasenia: {
				required: 'Especificar Contrasenia', 
				minlength: 'Al menos 6 Caracteres'
			}
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	function validaCaptcha(control)	{
		$j_captcha_response = document.getElementById("j_captcha_response").value;
      $.post("register",{j_captcha_response:$j_captcha_response}, function(data) {
         
      	if(data.length >0) {		
				$('#resultadoCapt').html(data);
				var cap=data.toString();
			 	
				if(cap=="true") {
			 		validaCap=true;			 			
				 }else{
				 	validaCap=false;
				 } 
			}	
		});   
  	 }	
	
	function validaUsuario(control) {
		var numUsuario = $('#numero').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		
		if(numUsuario != '' && !isNaN(numUsuario) && esTab){
			
			if(numUsuario=='0'){
				
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				limpiaForm($('#formaGenerica'));
				
			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				usuarioServicio.consulta(1, numUsuario,function(usuario) {
							if(usuario!=null){
								dwr.util.setValues(usuario);
								deshabilitaBoton('agrega', 'submit');
								habilitaBoton('modifica', 'submit');								
							}else{
								limpiaForm($('#formaGenerica'));
								alert("No Existe el Usuario");
								deshabilitaBoton('modifica', 'submit');
   							deshabilitaBoton('agrega', 'submit');
								$('#numero').focus();
								$('#numero').select();																
							}
				});
								
			}
												
		}
	}	

});