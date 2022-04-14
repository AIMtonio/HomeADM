$(document).ready(function() {

	esTab = true;

	// Definicion de Constantes y Enums
	var catTipoTransaccionInverciones = {
			'agrega' : 1,
			'modifica' : 2
	};
	
	var catTipoListaDiasInversion = {
			'principal':1
	};
	
	// Definicion de Constantes y Enums
	var catTipoConsultaTipoInversion = {
			'principal' : 1
	};
	

	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
			
	$('#formaGenerica').submit(function(event){
		grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje');		
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionInverciones.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionInverciones.modifica);
	});
	
	
	
	$('#tipoInvercionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		if(this.value.length >= 3){
			lista('tipoInvercionID', '3', '1', 'descripcion', $('#tipoInvercionID').val(), 'listaTipoInversiones.htm');
		}

	});
		
	$('#tipoInvercionID').blur(function() {
		validaTipoInvercion();
	});
		
	
	function validaTipoInvercion(){			
		var tipoInversion = $('#tipoInvercionID').val();		
		var tipoConsulta = catTipoConsultaTipoInversion.principal;		
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(tipoInversion != '' && !isNaN(tipoInversion) && esTab){
			
			habilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
			
			tipoInversionesServicio.consultaPrincipal(tipoConsulta, tipoInversion, function(tipoInver){
				
				if(tipoInver!=null){							
					$('#descripcion').val(tipoInver.descripcion);					
				}else{
					alert("No Existe el tipo de Inversion");
				}
			});
		}
	}
	
	
	
	
	$("#add").click(function() {
/*		
		tab = document.getElementById('miTabla');
		  fil = document.getElementsByTagName('tr')[0].cloneNode(true);
		  tab.appendChild(fil);
		*/
		var numeroFila = document.getElementById("contador").value;
		var nuevaFila = parseInt(numeroFila) + 1;

		document.getElementById("contador").value = "";
		
        var n = $('tr:last td', $("#miTabla")).length;
        var tds = '<tr>';
	    for(var i = 0; i < n; i++){
	    	if(i == 0){
	    		var valor = document.getElementById("plazoSuperior"+numeroFila+"").value;
	    		tds += '<td align="center"><input type="text" size="5" name="plazoInferior" id="plazoInferior'+nuevaFila+'" value="'+valor+'" readOnly /></td>';
	    	}
	    	if(i == 1){
	    		tds += '<td align="center"><input type="text" size="5" name="plazoSuperior" id="plazoSuperior'+nuevaFila+' "value="" autocomplete="off" /></td>';
	    	}
	        
	    }
	    tds += '</tr>';
    
    document.getElementById("contador").value = nuevaFila;

    $("#miTabla").append(tds);   
    
    return false;
    
  });

});

