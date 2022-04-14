$(document).ready(function() {
	// Definicion de Constantes y Enums	
	esTab = true;
	
	var catTipoConsultaUsuario = {
  		'foranea':2
	}; 
	var catTipoTransaccionPerConta = {
  		'agrega':1,
  		'modifica':2,  		
  		'elimina':3
	};
	
	var catTipoConsultaPermisos = {
  		'principal':1
	}; 
			
	var parametroBean = consultaParametrosSession();	
	
	deshabilitaBoton('Graba', 'submit');
   agregaFormatoControles('formaGenerica');
   
	//------------ Metodos y Manejo de Eventos -----------------------------------------
			
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
         	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','usuarioID'); 
			}
    });			
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionPerConta.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionPerConta.modifica);
	});	
	
	$('#eliminar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionPerConta.elimina);
	});	
	
	
	$('#agrega').attr('tipoTransaccion', '1');
	$('#modifica').attr('tipoTransaccion', '2');
	$('#modifica').attr('tipoTransaccion', '2');
	
	$('#usuarioID').bind('keyup',function(e){
		lista('usuarioID', '2', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});
	
	$('#usuarioID').blur(function() {
  		consultaUsuario(this.id);
	});
	
	
	$('#formaGenerica').validate({
		rules: {
			usuarioID: { 
				required: true
			}
		},
		messages: { 			
		 	usuarioID: {
				required: 'Especique el Usuario'
			}
		}		
	});
			
	function consultaUsuario(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var varUsuario = $(jqUsuario).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		var usuarioBeanCon = {
  			'usuarioID':varUsuario 
		};	
		var consultaForanea = 2;
		if(varUsuario != '' && !isNaN(varUsuario) && esTab){
			usuarioServicio.consulta(catTipoConsultaUsuario.foranea,usuarioBeanCon,function(usuario) {
					if(usuario!=null){
						$('#usuarioID').val(usuario.usuarioID);
						$('#nomUsu').val(usuario.nombreCompleto);
					
						consultaPermisos(idControl);							
					}else{
						alert("No Existe el Usuario");
						inicializaForma('formaGenerica','usuarioID');	
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('eliminar', 'submit');
						$('#usuarioID').focus();
						$('#usuarioID').select();																
					}
			});							
		}
	}
	
	function consultaPermisos(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var varUsuario = $(jqUsuario).val();	
		setTimeout("$('#cajaLista').hide();", 200);
		var usuarioBeanCon = {
	  			'usuarioID':varUsuario 
		};	
		if(varUsuario != '' && !isNaN(varUsuario) && esTab){
			permisosContablesServicio.consulta(catTipoConsultaPermisos.principal,usuarioBeanCon,function(permisos) {
					if(permisos!=null){
						dwr.util.setValues(permisos);	 
						activarDesCheck(permisos.afectacionFeVa,permisos.cierreEjercicio,permisos.cierrePeriodo, 
						permisos.modificaPolizas) ;
						habilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('eliminar', 'submit');									
					}else{
						$('#afectacionFeVa').attr('checked', false);
						$('#cierreEjercicio').attr('checked', false);
						$('#cierrePeriodo').attr('checked', false);
						$('#modificaPolizas').attr('checked', false);
						deshabilitaBoton('modifica', 'submit');
						habilitaBoton('agrega', 'submit');
						deshabilitaBoton('eliminar', 'submit');
						$('#usuarioID').focus();
						$('#usuarioID').select();																
					}
			});							
		}
	}
	function activarDesCheck(afectacionFeVa,cierreEjercicio,cierrePeriodo, 
						modificaPolizas) { 
		
		if (afectacionFeVa == 'S'){
			$('#afectacionFeVa').attr("checked",true);
		} else{$('#afectacionFeVa').attr("checked",false);}
		
		if (cierreEjercicio == 'S'){
			$('#cierreEjercicio').attr("checked",true);
		} else{$('#cierreEjercicio').attr('checked', false);}
		
		if (cierrePeriodo == 'S'){
			$('#cierrePeriodo').attr("checked",true);
		} else{$('#cierrePeriodo').attr('checked', false);}
		
		if (modificaPolizas == 'S'){
			$('#modificaPolizas').attr("checked",true);
		}  else{$('#modificaPolizas').attr('checked', false);}  
		
	} 
	
});
