
$(document).ready(function() {
	parametros = consultaParametrosSession();

	// Declaración de constantes
	var catTipoConsultaOegano = {  
	  		'principal'		: 1,
	  		'foranea'		: 2
	  		
		};	
		
	var catTipoTranOrgano = { 
		'alta'			: 1,
		'modifica'		: 2,
		'elimina'		:3
	};		
	//------------ Metodos y Manejo de Eventos -----------------------------------------
  deshabilitaBoton('grabarOrgDecision', 'submit');
   deshabilitaBoton('modificar', 'submit');
   deshabilitaBoton('eliminar', 'submit');
   
	agregaFormatoControles('formaGenerica');				
		
	
	
	$.validator.setDefaults({
	      submitHandler: function(event) { 
	   	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','organoID','exitoPantallaOrganoDe','falloPantallaOrganoDe');	           
	      }
	   });	
	
	$('#grabarOrgDecision').click(function() {
		$('#tipoTransaccion').val(catTipoTranOrgano.alta);				
	});
	$('#modificar').click(function() {
		$('#tipoTransaccion').val(catTipoTranOrgano.modifica);	
		
	});
	$('#eliminar').click(function() {
		$('#tipoTransaccion').val(catTipoTranOrgano.elimina);		
	});
	
	
	$('#organoID').blur(function() {
		if(isNaN($('#organoID').val()) ){
			$('#organoID').val("");
			$('#organoID').focus();			
		 }else{ 
			 validaOrganoDecision(this.id);
		}
	});
	
	 $('#organoID').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array(); 
		    var parametrosLista = new Array(); 
		    	//camposLista[0] = $('#descripcion').val();
		    	camposLista[0] ="descripcion";
		    	parametrosLista[0] = $('#organoID').val();
		    	listaAlfanumerica('organoID', '2', '2', camposLista, parametrosLista, 'organosDecisionListaVista.htm'); }
		
	 });

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			organoID: 'required',
			descripcion:'required'
		},		
		messages: {
			organoID: 'Especifique el Facultado',
			descripcion: 'Especifique la descripción',
		}		
	});
	
	

	//------------ Validaciones de Controles -------------------------------------
	
		function validaOrganoDecision(control) {
			var jqSolicitud  = eval("'#" +control + "'");
			var solCred = $(jqSolicitud).val();	
			
			if(solCred != '' && !isNaN(solCred)){				
				if(solCred=='0'){
					habilitaBoton('grabarOrgDecision', 'submit');
					deshabilitaBoton('modificar', 'submit');
					deshabilitaBoton('eliminar', 'submit');
					$('#descripcion').val("");

				} else {				
					var organoDecisionBean = { 
							'organoID':solCred	  				
					};
					
					organoDecisionServicio.consulta(catTipoConsultaOegano.principal,organoDecisionBean,function(data) {
							if(data!=null){
								dwr.util.setValues(data);										
								deshabilitaBoton('eliminar', 'submit');
								deshabilitaBoton('grabarOrgDecision', 'submit');
								habilitaBoton('modificar', 'submit');
								habilitaBoton('eliminar', 'submit');
								consultaGridOrganosDecision();
							}else{								
							alert("No Existe el Facultado");
							deshabilitaBoton('modificar', 'submit');
							deshabilitaBoton('eliminar', 'submit');
	   						deshabilitaBoton('grabarOrgDecision', 'submit');
	   						inicializaForma('formaGenerica','organoID' );
							$('#organoID').focus();
							$('#organoID').select();
							consultaGridOrganosDecision();
							$('#organoID').val(''); 
							
							}
					});
							
				}
													
			}
		}
		
		
});



//funciones para el exito o error de la pantalla
function exitoPantallaOrganoDe() {
	consultaGridOrganosDecision();
	deshabilitaBoton('grabarOrgDecision', 'submit');
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('eliminar', 'submit');
	$('#descripcion').val('');
	
}



function falloPantallaAutCreditoGr() {  
}

consultaGridOrganosDecision();
function consultaGridOrganosDecision(){	
	var params = {};
	params['tipoLista'] = 1;
	params['organoID'] =0;
	
	$.post("organosDecisionGridVista.htm", params, function(data){
		if(data.length >0) {				
			$('#organoDecision').html(data);
			$('#organoDecision').show();
			$("#numeroOrgano").val(consultaFilas());	
			
			
		}else{				
			$('#organoDecision').html("");
			$('#organoDecision').hide(); 
		}
	});
}

// consulta las filas existentes en el grid de Organos
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;
		
	});
	return totales;
}

