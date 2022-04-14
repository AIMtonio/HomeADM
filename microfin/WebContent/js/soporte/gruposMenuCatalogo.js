$(document).ready(function() {
	esTab = true;
	//validaCap=false;
	//Definicion de Constantes y Enums  
	var catTipoTransaccionGrupoMenu = {
  		'agrega':'1',
  		'modifica':'2',
	};
	var catTipoConsultaGrupoMenu = {  
  		'principal':1,
  		'foranea':2, 
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------

   deshabilitaBoton('modifica', 'submit');
   deshabilitaBoton('agrega', 'submit');
	
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
            submitHandler: function(event) { 
                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','numero'); 
            }
    });			
		    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionGrupoMenu.agrega); 
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionGrupoMenu.modifica);
	});		
	
	/*$('#numero').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('numero', '2', '1', 'nombreCompleto', $('#numero').val(), 'listaUsuarios.htm');
	});*/ 
	$('#numero').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('numero', '1', '1', 'desplegado', $('#numero').val(), 'listaGruposMenu.htm');
	});	 
	$('#numero').blur(function() {
  		validaGrupo(this);
	});	
	
	$('#menu').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('menu', '1', '1', 'desplegado', $('#menu').val(), 'listaMenus.htm');
	});
	$('#menu').blur(function() {
  		consultaMenu(this.id);
	});
	
	
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			
			numero: {
				required: true
				
			},
			menu: {
				required: true
				
			},
			
			descripcion: { 
				required:  true
			},	
			
			desplegado: { 
				required: 	true
			},
					
				
		},
		messages: {
			
		
			numero: {
				required: 'Especificar Numero'
			
			},
			
			menu: {
				required: 'Especificar Menu'
				
			},

			
			descripcion: {
				required: 	'Especificar Descripcion'
			},
			
			desplegado: {
				required: 	'Especificar Desplegado'
			},
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	function validaGrupo(control) {
		var numGrupo = $('#numero').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		
		if(numGrupo != '' && !isNaN(numGrupo) && esTab){
			
			if(numGrupo=='0'){
				
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				
			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var grupMenuBeanCon = { 
  				'numero':numGrupo 
				};	
				grupoMServicio.consulta(catTipoConsultaGrupoMenu.principal,grupMenuBeanCon,function(grupoM) { 
							if(grupoM!=null){
								dwr.util.setValues(grupoM);
			
								esTab=true; 
								$('#menu').val(grupoM.menu);		 							
								consultaMenu('menu');
								deshabilitaBoton('agrega', 'submit');
								habilitaBoton('modifica', 'submit');								
							}else{
								alert("No Existe el grupo");
								deshabilitaBoton('modifica', 'submit');
   							deshabilitaBoton('agrega', 'submit');
								$('#numero').focus();
								$('#numero').select();																
							}
				});					
			}
												
		}
	}
	
	
	function consultaMenu(idControl) {
		var jqMenu= eval("'#" + idControl + "'");
		var numMenu = $(jqMenu).val();	
		setTimeout("$('#cajaLista').hide();", 200);		 
		if(numMenu != '' && !isNaN(numMenu) && esTab){
		var conForanea =3;
		var menuBeanCon = {
  				'numero':numMenu
				};
			menuServicio.consulta(conForanea,menuBeanCon,function(menus) {
						if(menus!=null){							
							$('#nombreMenu').val(menus.desplegado); 
																	
						}else{
							alert("No Existe el Menu");
								$('#menu').focus();
								$('#menu').select(); 
						}    						
				});
			} 
		}
	

});