
$(document).ready(function() {
	esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionPromotor= {
	  		'grabar': '1',
	  		'modificar': '2'
	}; 
	var catTipoConPromotor = {
	  	    'principal': 1
	}; 
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	
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
	
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');

	$('#grabar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionPromotor.grabar);

	});
	
	$('#modificar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionPromotor.modificar);

	});
	
	$('#numero').bind('keyup',function(e){
		lista('numero', '1', '1', 'numero', $('#numero').val(), 'listaCatPromotoresExtInv.htm');
	
	});
	
	$('#numero').focus();
        

    $('#numero').blur(function(){
    	consultaPromotor();

    });
    
    $("#telefono").setMask('phone-us');
	$("#numCelular").setMask('phone-us');

	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			numero: {
				required: true
			},
			nombre: {
				required: true,
				minlength: 2
			},
			
			telefono: { 
				required: true,			 
				},
	
			
			numCelular: { 
				required: true,				 
				},
				
			correo: { 
				required: true,
				email : true
					 
					},
					
			estatus: { 
				required: true
							 
			}
		},
		messages: {
			numero: {
				required: 'Especificar Número de Promotor'
			},
			nombre: {
				required : 'Especificar Nombre',
				minlength : 'Al menos Caracteres'
			},
			
			telefono: {
				required: 'Especificar Número de Teléfono',				
			},

			
			numCelular: {
				required: 'Especificar Número de Celular',

			},
			correo: {
				required: 'Especificar Correo',
				email : 'Correo Inválido'


			},
			estatus: {
				required: 'Especificar Estatus',

			}	
		}			
	});

	// funciones
	
	function consultaPromotor(){
	 	var num =  $('#numero').val();
        if(num == 0){
        	limpiaForma();
	        habilitaBoton('grabar', 'submit');
	    	deshabilitaBoton('modificar', 'submit');

        }else if (num != '' && !isNaN(num) && esTab){
        	
        	var promotorBean= {
        			'numero' :  num 
        	};
        	catPromotoresExtInvServicio.consulta(catTipoConPromotor.principal, promotorBean, function(promotores){
  			if(promotores != null){
  				dwr.util.setValues(promotores);  				
  				$('#extTelefono').val(promotores.extTelefono);
  		    	habilitaBoton('modificar', 'submit');
  		      	deshabilitaBoton('grabar', 'submit');
  			}else{
  				mensajeSis("El Promotor Externo no Existe");
  		    	$('#numero').focus();

  			 }
  		 });
 
        }
		
	
	}
	
	
	  function limpiaForma(){
		    $('#nombre').val('');
			$('#telefono').val('');
			$('#numCelular').val('');
			$('#correo').val('');
			$('#estatus').val('');
	  }
	    
	
});