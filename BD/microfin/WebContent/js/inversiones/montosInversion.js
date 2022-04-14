$(document).ready(function() {

	esTab = true;

	// Definicion de Constantes y Enums
	var catTipoTransaccionInversiones = {
			'agrega' : 1,
			'modifica' : 2
	};
	
	var catTipoListaMontosInversion = {
			'principal':1,
			'secundaria':2
	};
	
	// Definicion de Constantes y Enums
	var catTipoConsultaTipoInversion = {
			'principal' : 1,
			'secundaria' : 2
	};

	var catTipoListaTipoInversion = {
			'todas' : 5
	};

	
	deshabilitaBoton('agregaInv', 'submit');
	$('#tipoInversionID').focus();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
			submitHandler: function(event) { 
         	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoInversionID'); 
			}
    });			
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agregaInv').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionInversiones.agrega);
		creaPlazosInversion();
		
	});
			
	$('#tipoInversionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		if(this.value.length >= 3){
			var camposLista = new Array();
        	var parametrosLista = new Array();
        	camposLista[0] = "monedaId";
        	camposLista[1] = "descripcion";
        	parametrosLista[0] = 0;
        	parametrosLista[1] = $('#tipoInversionID').val();
        	
       	lista('tipoInversionID', 3, catTipoListaTipoInversion.todas,
       			 camposLista, parametrosLista, 'listaTipoInversiones.htm');		
		}
	});
		
	$('#tipoInversionID').blur(function() {
		validaTipoInversion();
		if(!isNaN($('#tipoInversionID').val())){
			consultaPlazos();
		}
	});
	
	function consultaPlazos(){	
		var params = {};
		params['tipoLista'] = 1;
		params['tipoInversionID'] = $('#tipoInversionID').val();
		
		$.post("gridMontosInversion.htm", params, function(data){				
				if(data.length >0) {	
					$('#gridMontos').html(data);
					$('#gridMontos').show();
				}else{					
					$('#gridMontos').html("");
					$('#gridMontos').show();
				}
		});
	}
	
	$('#formaGenerica').validate({
		rules: {
			tipoInversionID: { 
				minlength: 1
			}
		},
		messages: { 			
		 	tipoInversionID: {
				minlength: 'Al menos un Caracter'
			}
		}		
	});
		
	function validaTipoInversion(){			
		var tipoInversion = $('#tipoInversionID').val();		
		var tipoConsulta = catTipoConsultaTipoInversion.secundaria;		
		setTimeout("$('#cajaLista').hide();", 200);
		
		var tipoInversionBean = {
      	'tipoInvercionID':tipoInversion,
         'monedaId':0
      };		
		
		if(tipoInversion != '' && !isNaN(tipoInversion) && esTab){
			
			tipoInversionesServicio.consultaPrincipal(tipoConsulta, tipoInversionBean, function(tipoInver){
				
				if(tipoInver!=null){
					$('#tipoInversionID').val(tipoInver.tipoInvercionID);							
					$('#descripcion').val(tipoInver.descripcion);
					$('#monedaID').val(tipoInver.monedaId);
					$('#descripcionMoneda').val(tipoInver.descripcionMoneda);
					$('#estatusTipoInver').val(tipoInver.estatus);
					if(tipoInver.estatus == 'I'){
						mensajeSis("El Producto "+tipoInver.descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
						deshabilitaBoton('agregaInv', 'submit');
						$('#tipoInversionID').focus();
					}else{
						habilitaBoton('agregaInv', 'submit');	
					}
									
				}else{
					alert("No Existe el Tipo de Inversión");
					$('#tipoInversionID').focus();
					$('#estatusTipoInver').val('');
				}
			});
		}
	}
	
	function creaPlazosInversion(){
		var contador = 1;	
		$('#montosInferior').val("");
		$('#montosSuperior').val("");		
		quitaFormatoControles('gridMontosInv');
		
		$('input[name=plazoInferior]').each(function() {	
			var MontoInferioruno =$('#inferior'+contador).asNumber();			
			if (contador != 1){
				$('#montosInferior').val($('#montosInferior').val() + ','  + MontoInferioruno);
			}else{				
				$('#montosInferior').val(MontoInferioruno);
			}

			contador = contador + 1;
			MontoInferioruno='';
		});
		contador = 1;
		$('input[name=plazoSuperior]').each(function() {
			var montoSuperiorUno=$('#superior'+contador).asNumber();
			if (contador != 1){
				$('#montosSuperior').val($('#montosSuperior').val() + ','  + montoSuperiorUno);
			}else{
				
				$('#montosSuperior').val(montoSuperiorUno);
			}
			contador = contador + 1;
			montoSuperiorUno='';
		});	
	}
	
	

	

});

