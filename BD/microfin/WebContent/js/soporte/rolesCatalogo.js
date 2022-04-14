$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionRol = {  
  		'agrega':'1',
  		'modifica':'2'	};
	
	var catTipoConsultaRol = {
  		'principal'	: 1,
  		'foranea'	: 2
	};	
	var prefijo='';
	var mostrarPrefijo='';
		//------------ Metodos y Manejo de Eventos -----------------------------------------
	 deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');
    conPrefijo();
    $('#rolID').focus();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	

	$.validator.setDefaults({
            submitHandler: function(event) { 
                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','rolID'); 
            }
    });				
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionRol.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionRol.modifica);
	});	

	$('#rolID').bind('keyup',function(e){

		lista('rolID', '2', '1', 'nombreRol', $('#rolID').val(), 'listaRoles.htm');
	});
	
	$('#descripcion').blur(function (){
		var claveUsuario=$('#descripcion').val();
		var tmpPrefijo='';
		if(mostrarPrefijo=='S'){		
			tmpPrefijo=claveUsuario.substring(0, 3);
			if(tmpPrefijo!=prefijo){
				$('#descripcion').val(prefijo+claveUsuario);
			}		
		}
	});
	
	$('#rolID').blur(function() { 
		conPrefijo();
  		validaRol(this.id); 
	});
	$('#nombreRol').blur(function(){
		var nombre = $('#nombreRol').val();
		var remplazarComas= nombre.replace(/[-_=¿*;:@.,+!"#$%&(=?¡'{-|})><ĸ¬°Çü½«»~÷Ø§ç¨`^€¶ŧ←↓→øþæßðđŋħł¢“µ·½\/\]\]\[\”\\]/gi, '');
		$('#nombreRol').val(remplazarComas);		
	});
	
	$('#descripcion').blur(function(){
		var nombre = $('#descripcion').val();
		var remplazarComas= nombre.replace(/[-_=¿*;:@.,+!"#$%&(=?¡'{-|})><ĸ¬°Çü½«»~÷Ø§ç¨`^€¶ŧ←↓→øþæßðđŋħł¢“µ·½\/\]\]\[\”\\]/gi, '');
		$('#descripcion').val(remplazarComas);
	});
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			
			rolID: {
				required: true
			},
	
			nombreRol: {
				required: true
			},	
			
			descripcion: { 
				required: true
			},	
		},
		messages: {
			
		
			rolID: {
				required: 'Especificar No.'
			},
			
			nombreRol: {
				required: 'Especificar Nombre'
			},
			
			descripcion: {
				required: 'Especificar Descripcion',
			}
		}		
	});
	
	//------------ Validaciones de Controles ----------------------ar las cajas de texto que acepte solo letras mayusculas y minusculas o solo numero simplemente hay que adecuarlo a la necesidad---------------
	
		function validaRol(control) {
		var numRol = $('#rolID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numRol != '' && !isNaN(numRol) && esTab){
			
			if(numRol=='0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','clienteID' )

			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var rolBeanCon = { 
  				'rolID':numRol
  				
				};
				
				rolesServicio.consultaRoles(catTipoConsultaRol.principal,rolBeanCon,function(rol) {
						if(rol!=null){
							dwr.util.setValues(rol);	
							conPrefijo();
							var descrip=rol.descripcion.substring(0, 3);
							if(descrip==prefijo){
								$('#descripcion').val(rol.descripcion.substring(3,rol.descripcion.length))
							}
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');													
						}else{
							
							alert("No Existe el rol");
							inicializaForma('formaGenerica','rolID' )
							deshabilitaBoton('modifica', 'submit');
   						deshabilitaBoton('agrega', 'submit');
								$('#rolID').focus();
								$('#rolID').select();	
																			
							}
				});
						
			}
												
		}
	}
	
	function conPrefijo(){
		var claveUsuario=$('#descripcion').val();
		var tmpPrefijo='';
		var parametrosSisCon ={
	 		 	'empresaID' : 1
		};				
		parametrosSisServicio.consulta(1,parametrosSisCon, function(varParamSistema) {
			if (varParamSistema != null) {	
				mostrarPrefijo=varParamSistema.mostrarPrefijo;
				if(mostrarPrefijo=='S' && claveUsuario!='' ){
					tmpPrefijo=claveUsuario.substring(0, 3);
				}
				companiasServicio.consulta(1, function(companiaBean) {
				if(companiaBean!=null){
					if(varParamSistema.mostrarPrefijo=='S'){
						if(tmpPrefijo==companiaBean.prefijo){
							$('#descripcion').val(claveUsuario);
						}
						else{
							$('#descripcion').val(companiaBean.prefijo);
							prefijo=companiaBean.prefijo;	
						}
						}
					}
				});	
			}

		});
	}

				
});
	