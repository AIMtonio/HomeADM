
$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession();
	$("#companiaID").focus();

	//Definicion de Constantes y Enums  
	var catTipoTransaccionCompania= {
	  		'agregar':'1',
	  		'modificar': '2'
	}; 

	

//------------ Metodos y Manejo de Eventos -----------------------------------------
  	
  	$(':text').focus(function() {	
	 	esTab = false;
	});
	
  	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','companiaID');
	  	}
	});	
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	
	
	 $('#agrega').click(function() {		
			$('#tipoTransaccion').val(catTipoTransaccionCompania.agregar);
	});

	
    $('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCompania.modificar);
	});

	$('#companiaID').bind('keyup',function(e) { 
		lista('companiaID', '2', '2', 'razonSocial', $('#companiaID').val(), 'listaCompanias.htm');
	});
	


    $('#companiaID').blur(function(){
    	validaCompania(this.id);

    });
    


    jQuery.validator.addMethod("soloLetras", function(value, element) {
		  return this.optional(element) || /^[a-z]+$/i.test(value);
		}, "Ingrese un subdominio válido");

    
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			companiaID: {
				required: true
			},
			
				
			razonSocial: { 
				required: true
					 
			},
			
			direccionCompleta: { 
				required: true
					 
			},
			
			origenDatos: { 
				required: true
					 
			},
			
			prefijo: { 
				required: true
					 
			},
			subdominio:{
				soloLetras: true
			}
		},
		messages: {
			companiaID: {
				required: 'Especificar Número de Compañia.'
			},
			razonSocial: { 
				required: 'Expecificar Razon Social.'
					 
			},
			direccionCompleta: { 
				required: 'Expecificar Dirección.'
					 
			},
			origenDatos: { 
				required: 'Expecificar Origen de Datos.'
					 
			},
			
			prefijo: { 
				required: 'Expecificar Prefijo.'
					 
			}
					
		}			
	});

	
	
	function consultaCompania(idControl) {
		var jqCompania = eval("'#" + idControl + "'");
		var numCompania = $(jqCliente).val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if (numCompania != '' && !isNaN(numCompania) ) {

			companiasServicio.consulta(2, numCompania, function(
					compania) {
				if (compania != null) {
					$('#companiaID').val(compania.companiaID);
					$('#razonSocial').val(compania.razonSocial);
					$('#direccionCompleta').val(compania.direccionCompleta);
					$('#origenDatos').val(compania.origenDatos);
					$('#prefijo').val(compania.prefijo);
					habilitaBoton('modifica','submit');

				} else {
					alert("No Existe la Compañia.");
					limpiaForma();
					deshabilitaBoton('agrega','submit');
					deshabilitaBoton('modifica','submit');
					$('#companiaID').focus();

				}
			});
		}
		
		else{
			deshabilitaBoton('agrega','submit');
			deshabilitaBoton('modifica','submit');
	
			$('#companiaID').focus();
			limpiaForma();
			
		}
	}
	
	
	function validaCompania(control) {
		var numCompania = $('#companiaID').val();
		
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCompania != '' && !isNaN(numCompania)){
			
			if(numCompania=='0'){
				
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','companiaID');
					
				
			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');	
				
				var compania = {
					 'companiaID' : $('#companiaID').val()
					};
							
				companiasServicio.consulta(2, compania,function(compania) {
						if(compania!=null){
							dwr.util.setValues(compania);	
			
							esTab = true;
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');																			
							
							
						
						}else{
							
							alert("No Existe la compañia");
							deshabilitaBoton('modifica', 'submit');
							deshabilitaBoton('agrega', 'submit');
   							$('#companiaID').focus();
							$('#companiaID').select();	
						
							//inicializaForma($('#formaGenerica'),$('#promotorID'));
																			
							}
				});
								
			}
												
		}
	}
	
	

	  function limpiaForma(){
			$('#companiaID').val('');
		    $('#razonSocial').val('');
			$('#direccionCompleta').val('');
			$('#origenDatos').val('');
			$('#prefijo').val('');

	  }

	    
});


