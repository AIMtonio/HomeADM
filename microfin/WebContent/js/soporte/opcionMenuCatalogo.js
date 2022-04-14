$(document).ready(function() {
	esTab = true;
	//validaCap=false;
	//Definicion de Constantes y Enums  
	var catTipoTransaccionOpMenu = {
  		'agrega':'1',
  		'modifica':'2',
	};
	var catTipoConsultaOpMenu = {
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
		$('#tipoTransaccion').val(catTipoTransaccionOpMenu.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionOpMenu.modifica);
	});		
	
	/*$('#numero').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('numero', '2', '1', 'nombreCompleto', $('#numero').val(), 'listaUsuarios.htm');
	});*/ 
		 
	$('#numero').blur(function() {
  		validaOpcion(this);
	});	
	$('#grupoMenu').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('grupoMenu', '2', '1', 'desplegado', $('#grupoMenu').val(), 'listaGruposMenu.htm');
	});
	$('#grupoMenu').blur(function() {
  		consultaGrupo(this.id);
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			
			numero: {
				required: true
				
			},
			grupoMenu: {
				required: true
				
			},
			
			descripcion: { 
				required:  true
			},	
			
			desplegado: { 
				required: 	true
			},
			recurso: { 
				required: 	true
			},		
				
		},
		messages: {
			
		
			numero: {
				required: 'Especificar Numero'
			
			},
			
			grupoMenu: {
				required: 'Especificar Grupo'
				
			},

			
			descripcion: {
				required: 	'Especificar Descripcion'
			},
			
			desplegado: {
				required: 	'Especificar Desplegado'
			},
			recurso: {
				required: 	'Especificar Recurso'
			},
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	function validaOpcion(control) {
		var numOpcion = $('#numero').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		
		if(numOpcion != '' && !isNaN(numOpcion) && esTab){
			
			if(numOpcion=='0'){
				
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				
			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var opMenuBeanCon = {
  				'numero':numOpcion 
				};	
				opMenuServicio.consulta(1,opMenuBeanCon,function(opcionM) { 
							if(opcionM!=null){
								dwr.util.setValues(opcionM);
			
								esTab=true; 
								$('#grupoMenu').val(opcionM.grupoMenu);		 							
								consultaGrupo('grupoMenu');
								deshabilitaBoton('agrega', 'submit');
								habilitaBoton('modifica', 'submit');								
							}else{
								alert("No Existe la opcion");
								deshabilitaBoton('modifica', 'submit');
   							deshabilitaBoton('agrega', 'submit');
								$('#numero').focus();
								$('#numero').select();																
							}
				});					
			}
												
		}
	}
	
	
	function consultaGrupo(idControl) {
		var jqGrupo= eval("'#" + idControl + "'");
		var numGrupo = $(jqGrupo).val();	
		setTimeout("$('#cajaLista').hide();", 200);		 
		if(numGrupo != '' && !isNaN(numGrupo) && esTab){
		var grupoBeanCon = {
  				'numero':numGrupo
				};
			grupoMServicio.consulta(catTipoConsultaOpMenu.foranea,grupoBeanCon,function(grupos) {
						if(grupos!=null){							
							$('#nombreGrupo').val(grupos.desplegado); 
																	
						}else{
							alert("No Existe el grupo");
								$('#grupoMenu').focus();
								$('#grupoMenu').select(); 
						}    						
				});
			} 
		}
	

});