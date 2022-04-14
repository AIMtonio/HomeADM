$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionCentro = {  
  		'agrega':'1',
  		'modifica':'2'	};
	
	var catTipoConsultaCentro = { 
  		'principal'	: 1,
  		'foranea'	: 2
	};	
	
		//------------ Metodos y Manejo de Eventos -----------------------------------------
	 deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');

	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	

	$.validator.setDefaults({
            submitHandler: function(event) { 
                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','centroCostoID'); 
            }
    });				
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCentro.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCentro.modifica);
	});	

	$('#centroCostoID').bind('keyup',function(e){
		lista('centroCostoID', '2', '1', 'descripcion', $('#centroCostoID').val(), 'listaCentroCostos.htm');
	});
	$('#centroCostoID').blur(function() {
  		validaCentroCostos(this);
	});
	
	$('#plazaID').bind('keyup',function(e){
		lista('plazaID', '2', '1', 'nombre', $('#plazaID').val(), 'listaPlazas.htm');
	});
	 
	 $('#plazaID').blur(function() { 
  		consultaPlaza(this.id);  
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			
			centroCostoID: {
				required: true
			},
	
			descripcion: {
				required: true
			},	
			
			responsable: { 
				required: true
			},
			plazaID: { 
				required: true
			},	
		},
		messages: {
			
		
			centroCostoID: {
				required: 'Especificar No.'
			},
			
			descripcion: {
				required: 'Especificar Descripcion'
			},
			
			responsable: {
				required: 'Especificar Responsable'
			},
			plazaID: {
				required: 'Especificar Plaza'
			},
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	function validaCentroCostos(control) {
		var numcentroCosto = $('#centroCostoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
			if(numcentroCosto != '' && !isNaN(numcentroCosto) && esTab){	
					habilitaBoton('agrega', 'submit');
					habilitaBoton('modifica', 'submit');
					var centroBeanCon = {  
  					'centroCostoID':$('#centroCostoID').val()
				 }; 
				centroServicio.consulta(catTipoConsultaCentro.principal,centroBeanCon,function(centro) { 
						if(centro!=null){
						dwr.util.setValues(centro);
							$('#plazaID').val(centro.plazaID);
							esTab=true; 
							consultaPlaza('plazaID');
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');													
						}else{
								inicializaForma('formaGenerica','centroCostoID');
								habilitaBoton('agrega', 'submit');
								deshabilitaBoton('modifica', 'submit');
								deshabilitaBoton('elimina', 'submit');			 														
							} 
					});
			}
		}
	
	
	function consultaPlaza(idControl) {
		var jqPlaza = eval("'#" + idControl + "'");
		var numPlaza = $(jqPlaza).val();	
		setTimeout("$('#cajaLista').hide();", 200);		
		var plazaBeanCon = { 
  				'plazaID':$('#plazaID').val()
				};
		if(numPlaza != '' && !isNaN(numPlaza) && esTab){
			plazasServicio.consulta(catTipoConsultaCentro.foranea,plazaBeanCon,function(plaza) {
						if(plaza!=null){						
							$('#descriPlaza').val(plaza.nombre);
																	
						}else{
							alert("No Existe la Plaza");
							$('#plazaID').focus();
							$('#plazaID').select();	
						}    	 						
				});
			}
		}	
		
});
	